#include "HomeworkLLVMPass.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/Demangle/Demangle.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Operator.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/GlobalVariable.h"  // 定义了 GlobalVariable
#include "llvm/IR/InstrTypes.h"      // 定义了 CallBase
#include "llvm/Analysis/CFG.h"       // 定义了 isPotentiallyReachable
#include "llvm/IR/Dominators.h"      // 定义了 DominatorTree
#include "llvm/IR/DataLayout.h"
#include <algorithm>
#include <array>
#include <iterator>
#include <vector>
#include <set>
#include <unordered_map>

namespace HomeworkLLVM {

bool useErrs = true; // 是否启用调试输出
llvm::raw_ostream &my_errs() {
    return useErrs ? llvm::errs() : llvm::nulls();
}


using cstring_ptr = std::unique_ptr<char, decltype(&free)>;
// Demangle a mangled name(反混淆)
cstring_ptr demangle(const char *const mangled) {
#if LLVM_VERSION_MAJOR < 17
    size_t len = 32;
    char *str = (char *)malloc(len * sizeof(char));
    int status = 0;
    char *ret = llvm::itaniumDemangle(mangled, str, &len, &status);
    if (status != 0)
        free(str);
#else
    char *ret = llvm::itaniumDemangle(mangled);
#endif
    return cstring_ptr(ret, &free);
}

// sort and unique a vector(排序、去重)
template <typename T> void sort_uniq(T &v) {
    if (v.empty()) return;
    std::sort(v.begin(), v.end());
    auto it = std::unique(v.begin(), v.end());
    v.erase(it, v.end());
}


// 递归地收集可能的函数指针目标
class FuncDefCollector {
public:
    llvm::CallInst* callInst; // 函数调用指令
    unsigned lineNo;          // 调用指令所在行号
    std::vector<llvm::Function*> results; // 结果函数指针列表

    FuncDefCollector(llvm::CallInst* ci, unsigned line) : callInst(ci), lineNo(line) {}

    // 从 Call 指令调用的操作数开始进行“值流分析”
    void collect() {
        traceValue(callInst->getCalledOperand()->stripPointerCasts(), 0,
            [&](llvm::Value *V) {
                if (auto *F = llvm::dyn_cast<llvm::Function>(V)) {
                    if (F->isIntrinsic() || F->getName().starts_with("llvm.")) {
                        return; // 忽略内置函数
                    }
                    results.push_back(F);
                }
            }
        );
    }

    // 输出结果
    void report() {
        if (results.empty()) return; // 空结果（可能是内置函数或未解析的函数指针），不用输出
        sort_uniq(results); // 排序去重
        llvm::errs() << lineNo << " : ";
        bool first = true;
        for (auto fn : results) {
            if (!first) llvm::errs() << ", ";
            first = false;
            auto name = demangle(fn->getName().str().c_str());
            llvm::errs() << (name ? name.get() : fn->getName());
        }
        llvm::errs() << "\n";
    }

private:
    llvm::SmallPtrSet<llvm::BasicBlock*, 16> selectedBlock; // 记录已经访问过的基本块，用于PHI节点的可达性判断
    llvm::SmallPtrSet<llvm::Value*, 16> visitedSet;         // 记录已经访问过的Value，防止重复处理
    std::vector<llvm::Value*> visitedStack;       // 记录当前递归栈中的Value
    const llvm::DataLayout &DL = callInst->getModule()->getDataLayout();
    using ValueCallback = std::function<void(llvm::Value*)>; // 定义回调函数类型

    // 生成一个将值添加到集合的回调函数
    ValueCallback add_to_set(std::vector<llvm::Value*> &S) {
        return [&](llvm::Value* V) {
            S.push_back(V);
        };
    }

    /// @brief 值流分析 (Value Flow Analysis), 处理 Reg-to-Reg 的数据流。目标：追踪一个 SSA Value 的定义来源
    /// @param V: the Value to trace
    /// @param traceRetFlag: 追踪返回值的标志，0表示不追踪，>0表示追踪多少层返回值
    /// @param callback: 当追踪到流的终点（如 Function, Alloca, GlobalVariable）时调用
    void traceValue(llvm::Value* V, int traceRetFlag, ValueCallback callback) {
        if (visitedSet.count(V)) {
            my_errs() << "[traceValue] Detected recursion cycle on: " << *V << "\n";
            return;
        }

        visitedSet.insert(V); // 标记为已访问
        visitedStack.push_back(V); // 入栈

        // Case 1: 找到了最终目标 —— 函数定义
        if (auto *F = llvm::dyn_cast<llvm::Function>(V)) {
            my_errs() << "[traceValue] Found function pointer target: " << F->getName() << "\n";
            if (traceRetFlag > 0) { // 如果是在追踪返回值的过程中，继续看该函数的 ReturnInst
                llvm::ReturnInst &RI = getReturnInst(*F);
                my_errs() << "[traceValue]   Tracing Function Ret Value of " << F->getName() << "\n";
                traceValue(RI.getReturnValue(), traceRetFlag - 1, callback);
            }
            goto end_trace;
        }

        // Case 2: 局部变量 (Alloca)
        if (auto *Alloca = llvm::dyn_cast<llvm::AllocaInst>(V)) {
            my_errs() << "[traceValue] Found Alloca Instruction: " << *Alloca << "\n";
            goto end_trace;
        }

        // Case 3: 读取内存 (Load) —— 切换到“内存流分析”
        if (auto *LI = llvm::dyn_cast<llvm::LoadInst>(V)) {
            llvm::Value *ptr = LI->getPointerOperand();
            my_errs() << "[traceValue] Tracing Load Instruction: " << *LI << "\n"
                      << "[traceValue]   Loaded from pointer: " << *ptr << "\n";
            std::vector<llvm::StoreInst *> storeInsts;
            traceMemory(ptr, storeInsts, LI); // 找向 ptr 地址写入的StoreInst指令
            for (llvm::StoreInst *SI : storeInsts) {
                traceValue(SI->getValueOperand(), traceRetFlag, callback);
            }
            goto end_trace;
        }

        // Case 4: PHI 节点 (控制流合并)
        if (auto *PHI = llvm::dyn_cast<llvm::PHINode>(V)) {
            my_errs() << "[traceValue] Tracing PHI Node: " << *PHI << "\n";
            // 检查 PHI 节点的前驱基本块是否已经被选定 (上下文敏感路径剪枝)
            for (auto *block : selectedBlock) {
                int i = PHI->getBasicBlockIndex(block);
                if (i != -1) {
                    traceValue(PHI->getIncomingValue(i), traceRetFlag, callback);
                    goto end_trace;
                }
            }
            // 否则遍历所有来源
            for (int i = 0; i < PHI->getNumIncomingValues(); i++) {
                llvm::BasicBlock *incomingblock = PHI->getIncomingBlock(i);
                selectedBlock.insert(incomingblock);
                traceValue(PHI->getIncomingValue(i), traceRetFlag, callback);
                selectedBlock.erase(incomingblock);
            }
            goto end_trace;
        }

        // Case 5: 函数参数 (跨函数分析)
        if (auto *Arg = llvm::dyn_cast<llvm::Argument>(V)) { // V 是函数参数, foo(int(*a_fptr))
            llvm::Function *F = Arg->getParent(); // 获取参数所属的函数(foo)
            my_errs() << "[traceValue] Tracing Function Argument of " << F->getName() << ": " << *Arg << "\n";
            // 遍历函数的所有调用点
            std::vector<llvm::CallBase*> callBases;
            getCallBases(F, callBases);
            for (auto *CB : callBases) {
                my_errs() << "[traceValue]   At call site: " << *CB << "\n";
                unsigned argIdx = Arg->getArgNo();
                traceValue(CB->getArgOperand(argIdx), traceRetFlag, callback);
            }
            goto end_trace;
        }

        // Case 6: 函数调用返回值 (CallBase)
        if (auto *Call = llvm::dyn_cast<llvm::CallBase>(V)) {
            my_errs() << "[traceValue] Tracing CallBase: " << *Call << "\n";
            llvm::Function *Callee = Call->getCalledFunction();
            if (!Callee) {
                my_errs() << "[traceValue]   Indirect call!" << "\n"; // f1 = foo; f2 = f1(); f2();
                // 间接调用：先找出被调用的是谁，再追踪它的返回值
                // 这里 traceRetFlag + 1，表示我们需要再多追踪一层返回
                traceValue(Call->getCalledOperand(), traceRetFlag + 1, callback);
            } else if (Callee->isDeclaration()) { // malloc, external function
                my_errs() << "[traceValue]   External/Library function detected: " << Callee->getName() << ". Stop tracing deeper.\n";
            } else {
                my_errs() << "[traceValue]   Tracing Function Ret Value of " << Callee->getName() << "\n"; // // f1 = foo(); f1();
                llvm::ReturnInst &RI = getReturnInst(*Callee); // 找到被调用函数的返回指令
                traceValue(RI.getReturnValue(), traceRetFlag, callback);
            }
            goto end_trace;
        }

        // Case 7: 常量表达式 (如 cast)
        if (auto *CE = llvm::dyn_cast<llvm::ConstantExpr>(V)) {
            my_errs() << "[traceValue] Tracing Constant Expression: " << *CE << "\n";
            if (CE->isCast())
                traceValue(CE->getOperand(0), traceRetFlag, callback);
            goto end_trace;
        }
        
        // Case 8: 全局变量 (取其初始化值)
        if (auto *GV = llvm::dyn_cast<llvm::GlobalVariable>(V)) {
            my_errs() << "[traceValue] Tracing Global Variable: " << *GV << "\n";
            if (GV->hasInitializer()) {
                auto *Init = GV->getInitializer();
                // 如果初始化是函数，或者是指针转换
                if (llvm::isa<llvm::Function>(Init->stripPointerCasts()) || llvm::isa<llvm::ConstantExpr>(Init)) {
                    traceValue(GV->getInitializer(), traceRetFlag, callback);
                }
            }
            goto end_trace;
        }

        // Case 9: GEP 指令 (处理数组退化、指针运算等)
        // 当追踪参数时，如果实参是一个 GEP (例如 &arr[0])，我们需要把它报告给 traceMemory
        if (auto *GEP = llvm::dyn_cast<llvm::GetElementPtrInst>(V)) {
            my_errs() << "[traceValue] Found GEP definition: " << *GEP << "\n";
            traceValue(GEP->getPointerOperand(), traceRetFlag, callback);
            goto end_trace;
        }

        // Case 10: 空指针 (局部变量未初始化)
        if (llvm::dyn_cast<llvm::ConstantPointerNull>(V)) { // store ptr null, ptr %5, align 8(局部变量未初始化)
            my_errs() << "[traceValue] Null pointer detected, stop tracing.\n";
            goto end_trace;
        }

        my_errs() << "Unhandled value in traceValue(): " << *V << "\n";

    end_trace:
        callback(V);
        visitedStack.pop_back(); // 出栈
        visitedSet.erase(V);
        return;
    }


    struct ValueWithParent {
        llvm::Value *value;
        llvm::Instruction *parentInst; // 追踪路径上最后一个在相同基本块内的指令

        ValueWithParent(llvm::Value* val) : value(val), parentInst(nullptr) {}
        ValueWithParent(llvm::Value* val, llvm::Instruction* parent) : value(val), parentInst(parent) {}
    };
    
    // 存储 GEP 指令及其所属的调用指令
    struct GEPInfo {
        llvm::GetElementPtrInst* GEP;  // 兄弟 GEP 指令
        llvm::Instruction* parentInst; // 兄弟 GEP 所在的指令(函数调用call指令)

        GEPInfo(llvm::GetElementPtrInst* gep, llvm::Instruction* parent)
            : GEP(gep), parentInst(parent) {}
        GEPInfo(llvm::GetElementPtrInst* gep)
            : GEP(gep), parentInst(nullptr) {}
    };
    // 存储 Store 指令及其所属的调用指令
    struct storeInstInfo {
        llvm::StoreInst* SI;           // Store 指令
        llvm::Instruction* parentInst; // Store 所在的指令(函数调用call指令 / 本身)

        storeInstInfo(llvm::StoreInst* si, llvm::Instruction* parent)
            : SI(si), parentInst(parent) {}
        
        // 比较两个 storeInstInfo 的指令序先后
        bool operator<(const storeInstInfo& other) const {
            if (parentInst->getParent() != other.parentInst->getParent()) {
                my_errs() << "[storeInstInfo] Comparing different basic blocks: "
                          << parentInst->getParent()->getName() << " vs "
                          << other.parentInst->getParent()->getName() << "\n";
                return false;
            }
            return parentInst->comesBefore(other.parentInst);
        }
    };

    /// @brief 内存流分析 (Memory Flow Analysis), 处理 Mem-to-Reg 的数据流。目标：寻找向 Address 地址写入的 StoreInst 指令
    /// @param Address: the memory address to trace
    /// @param storeInsts: the vector to collect StoreInst pointers
    /// @param CtxLI: the **exact** LoadInst from Address we are tracing (for context-sensitive analysis)
    void traceMemory(llvm::Value* Address, std::vector<llvm::StoreInst *> &storeInsts, llvm::LoadInst *CtxLI) {

        // Case 1: 结构体/数组元素 (GEP 指令)
        // 需要处理“兄弟 GEP” (指向同一成员的不同 GEP 指令)
        if (auto *GEP = llvm::dyn_cast<llvm::GetElementPtrInst>(Address)) {
            my_errs() << "[traceMemory] Tracing GEP Instruction: " << *GEP << "\n";

            std::vector<ValueWithParent> resolvedBases; // 存储解析到的基地址
            std::vector<GEPInfo> siblingGEPs; // 存储兄弟 GEP 指令信息
            std::vector<storeInstInfo> possibleStoreInsts; // 存储可能的 Store 指令信息

            // 首先找到 GEP 的基地址来源（Alloc指令）
            int64_t totalOffset = 0; // 计算总偏移量
            llvm::BasicBlock *thisBB = CtxLI->getParent(); // LoadInst 所在基本块
                        
            ValueCallback collectBases = [&](llvm::Value *resolvedBase) {
                if (auto *parentGEP = llvm::dyn_cast<llvm::GetElementPtrInst>(resolvedBase)) { // 如果 base 本身是 GEP，则继续递归查找
                    totalOffset += getGEPOffset(parentGEP);
                } else if (auto *allocInst = llvm::dyn_cast<llvm::AllocaInst>(resolvedBase)) {
                    resolvedBases.push_back(ValueWithParent(allocInst)); // 找到基地址
 
                    // 处理跨基本块的 GEP 链
                    if (!isInSameBasicBlock(llvm::dyn_cast<llvm::Instruction>(resolvedBase), CtxLI)) {
                        for (auto it = visitedStack.rbegin(); it != visitedStack.rend(); ++it) {
                            if (auto *inst = llvm::dyn_cast<llvm::Instruction>(*it)) {
                                if (inst->getParent() == thisBB) {
                                    resolvedBases.back().parentInst = inst; // 记录最后一个在相同基本块内的指令
                                    break;
                                }
                            }
                        }
                    }
                }
            };

            traceValue(GEP, 0, collectBases); // 解析基地址的真身
            // 接下来根据基地址和偏移，寻找所有兄弟 GEP 指令（相同地址的GEP）
            for (ValueWithParent resolvedBase : resolvedBases) {
                llvm::Instruction* parentInst = resolvedBase.parentInst;
                llvm::Value* base = resolvedBase.value;
                findSiblingGEPs(base, totalOffset, siblingGEPs, parentInst);
            }


            // 对于每个兄弟 GEP，寻找写入该地址的 StoreInst
            for (GEPInfo siblingGEPInfo : siblingGEPs) {
                findStoresTo(siblingGEPInfo, possibleStoreInsts, CtxLI);
            }

            // 汇总所有找到的 StoreInst, 删掉在基本块之间被覆盖的
            for (auto sinfo : possibleStoreInsts) {
                bool kill = false;
                for (auto other_sinfo : possibleStoreInsts) {
                    // 如果 sinfo 的 parentInst 在 other_sinfo 的 parentInst 之前，说明 sinfo 被覆盖了
                    if (sinfo.SI != other_sinfo.SI && sinfo < other_sinfo) {
                        kill = true;
                        break; // kill sinfo
                    }
                }
                if (!kill) storeInsts.push_back(sinfo.SI);
            }


            for (llvm::StoreInst *SI : storeInsts) {
                my_errs() << "[traceMemory] Found Store to GEP: " << *SI << "\n";
            }
            return;
        }

        // Case 2: PHI 节点 (地址的选择),例如: ptr = cond ? &a : &b; *ptr
        if (auto *PHI = llvm::dyn_cast<llvm::PHINode>(Address)) {
            my_errs() << "[traceMemory] Tracing PHI Node: " << *PHI << "\n";
            // 检查 PHI 节点的前驱基本块是否已经被选定 (上下文敏感路径剪枝)
            for (auto *block : selectedBlock) {
                int i = PHI->getBasicBlockIndex(block);
                if (i != -1) {
                    traceMemory(PHI->getIncomingValue(i), storeInsts, CtxLI);
                    return;
                }
            }
            // 否则遍历所有来源
            for (int i = 0; i < PHI->getNumIncomingValues(); i++) {
                llvm::BasicBlock *incomingblock = PHI->getIncomingBlock(i);
                selectedBlock.insert(incomingblock);
                traceMemory(PHI->getIncomingValue(i), storeInsts, CtxLI);
                selectedBlock.erase(incomingblock);
            }
            return;
        }

        // Case 3: 普通指针 (Alloca, GlobalVariable, 或简单的 Cast)
        // 直接查找写入该地址的 Store
        my_errs() << "[traceMemory] Tracing direct memory address: " << *Address << "\n";
        findStoresTo(Address, storeInsts, CtxLI);
    }

    // 搜索写入了 TargetAddr 的 StoreInst，加入 storeInsts 列表
    // 检查 StoreInst 是否可能影响到 CtxInst (Load)
    void findStoresTo(llvm::Value *TargetAddr, std::vector<llvm::StoreInst *> &storeInsts, llvm::LoadInst *CtxLI) {
        for (llvm::User *U : TargetAddr->users()) {
            if (auto *SI = llvm::dyn_cast<llvm::StoreInst>(U)) {
                if (isReachableStore(SI, CtxLI)) {
                    my_errs() << "[findStoresTo] Found Store Instruction: " << *SI << "\n";
                    storeInsts.push_back(SI);
                }
            }
        }
    }

    // 搜索写入了 TargetAddr 的 StoreInst，加入 storeInsts 列表（并添加位置信息）
    // 检查 StoreInst 是否可能影响到 CtxInst (Load)
    void findStoresTo(GEPInfo gepInfo, std::vector<storeInstInfo> &storeInstInfos, llvm::LoadInst *CtxLI) {
        for (llvm::User *U : gepInfo.GEP->users()) {
            if (auto *SI = llvm::dyn_cast<llvm::StoreInst>(U)) {
                if (isReachableStore(SI, CtxLI)) {
                    llvm::Instruction* parentInst = gepInfo.parentInst ? gepInfo.parentInst : SI;
                    storeInstInfos.push_back({SI, parentInst});
                }
            }
        }
    }

    // 计算 GEP 指令相对于其 Base Pointer 的常量偏移量 (以字节为单位)
    int64_t getGEPOffset(llvm::GetElementPtrInst *GEP) {
        // 准备一个 APInt 来接收结果，位宽通常设为指针大小 (例如 64位)
        llvm::APInt Offset(DL.getIndexTypeSizeInBits(GEP->getType()), 0);
        
        // 调用 LLVM 内置方法
        if (GEP->accumulateConstantOffset(DL, Offset)) {
            return Offset.getSExtValue(); // 返回有符号整数
        }

        my_errs() << "[getGEPOffset] Failed to compute constant offset for GEP: " << *GEP << "\n";
        return std::numeric_limits<int64_t>::min(); // 计算失败 (非编译期常量索引)
    }


    // 搜索偏移量为 Offset 的 GEP 指令
    void findSiblingGEPs(llvm::Value *BasePtr, int64_t Offset,
                         std::vector<GEPInfo> &siblingGEPs, llvm::Instruction *parentInst = nullptr)
    {
        for (llvm::User *U : BasePtr->users()) {
            if (auto *GEP = llvm::dyn_cast<llvm::GetElementPtrInst>(U)) {
                int64_t gepOffset = getGEPOffset(GEP);
                if (gepOffset == Offset) {
                    siblingGEPs.push_back(GEPInfo(GEP, parentInst));
                }
                findSiblingGEPs(GEP, Offset - gepOffset, siblingGEPs, parentInst); // 递归查找更深层的 GEP
            }
            // base 被作为参数传递
            else if (auto *CB = llvm::dyn_cast<llvm::CallBase>(U)) {
                int argIdx = findArgIndexInCall(CB, BasePtr); // 查找参数位置
                if (argIdx == -1) continue;

                llvm::Function *Callee = CB->getCalledFunction();
                my_errs() << "[findSiblingGEPs] Found CallBase: " << *CB << "\n";
                if (Callee && !Callee->isDeclaration()) {
                    llvm::Value *FormalArg = Callee->getArg(argIdx);
                    llvm::Instruction *newParentInst = parentInst ? parentInst : CB;
                    findSiblingGEPs(FormalArg, Offset, siblingGEPs, newParentInst);
                }
            }
        }
    }


    // 辅助函数：检查两个指针是否指向同一个位置
    bool isSameMemoryLocation(llvm::Value *P1, llvm::Value *P2) {
        if (P1 == P2) return true;

        if (auto *GEP1 = llvm::dyn_cast<llvm::GetElementPtrInst>(P1)) {
            if (auto *GEP2 = llvm::dyn_cast<llvm::GetElementPtrInst>(P2)) {
                // (A) 基地址必须相同；(B) 偏移量必须完全一致
                if (isSameMemoryLocation(GEP1->getPointerOperand(), GEP2->getPointerOperand()) &&
                    getGEPOffset(GEP1) == getGEPOffset(GEP2)) {
                    return true;
                }
            }
        }
        return false;
    }


    // 检查 StoreInst 是否可能影响到 CtxInst (Load)
    bool isReachableStore(llvm::StoreInst *SI, llvm::LoadInst *LI) {
        if (!LI) return true; // 如果没有上下文，默认都接受

        llvm::BasicBlock *StoreBB = SI->getParent();
        llvm::BasicBlock *LoadBB = LI->getParent();
        llvm::Function *StoreFunc = StoreBB->getParent();
        llvm::Function *LoadFunc = LoadBB->getParent();

        llvm::Value *TargetPtr = SI->getPointerOperand();

        bool SameBlock = (StoreBB == LoadBB); // 是否在同一基本块内
        bool SameFunction = (StoreFunc == LoadFunc); // 是否在同一函数内

        // 同一基本块内，Load 在 Store 之前，Store 不可能影响 Load
        if (SameBlock && LI->comesBefore(SI)) return false;

        // Source Block Local Kill: 检查在同一块内，Store 后面是否有覆盖写入！
        llvm::Instruction *EndInst = (SameBlock) ? LI : nullptr;
        for (llvm::Instruction *I = SI->getNextNode(); I != EndInst; I = I->getNextNode()) {
            if (auto *OtherSI = llvm::dyn_cast<llvm::StoreInst>(I)) {
                if (isSameMemoryLocation(OtherSI->getPointerOperand(), TargetPtr)) {
                    // 发现了后面有覆盖写入，SI 直接无效
                    my_errs() << "[isReachableStore] Store killed by later Store in same block: " << *OtherSI << "\n";
                    return false;
                }
            }
        }

        // 使用 DominatorTree 判断 StoreBB 是否支配 LoadBB (近似判断)
        if (SameFunction && !llvm::isPotentiallyReachable(SI, LI)) {
            return false;
        }

        return true; // 不在同一函数的情况，默认认为 Caller 的 Store 能到达 Callee
    }




    // 查找函数的所有调用点
    void getCallBases(llvm::Value *V, std::vector<llvm::CallBase*> &callBases,
                    llvm::SmallPtrSet<llvm::Value*, 16> &visited) {
        if (visited.contains(V))
            return;
        visited.insert(V);

        for (auto *U : V->users()) {
            if (auto *CB = llvm::dyn_cast<llvm::CallBase>(U)) {
                llvm::Value *callee = CB->getCalledOperand()->stripPointerCasts();
                if (callee == V) {  // 直接调用: f1();
                    my_errs() << "[getCallBases] CallBase found: " << *CB << "\n";
                    callBases.push_back(CB);
                } else { // 函数指针作为参数传递的情况: f2(f1);
                    my_errs() << "[getCallBases] Passed as argument to func " << callee->getName() << "\n";
                    int ArgIndex = findArgIndexInCall(CB, V); // 查找参数位置
                    my_errs() << "[getCallBases] Argument index: " << ArgIndex << "\n";
                    
                    auto collecter = FuncDefCollector(llvm::cast<llvm::CallInst>(CB), 0);
                    collecter.collect(); // 查找 f2 的可能定义
                    for (auto *fn : collecter.results) { // 查找函数指针参数的所有调用点
                        getCallBases(fn->getArg(ArgIndex), callBases, visited);
                    }
                }
            }
            else if (auto *SI = llvm::dyn_cast<llvm::StoreInst>(U)) { // store V → ptr, then load from ptr
                auto *ptr = SI->getPointerOperand();
                my_errs() << "[getCallBases] Following stored pointer: " << *ptr << "\n";
                for (auto *PU : ptr->users()) {
                    if (auto *LI = llvm::dyn_cast<llvm::LoadInst>(PU)) {
                        getCallBases(LI, callBases, visited);
                    }
                }
            }
            else if (auto *PN = llvm::dyn_cast<llvm::PHINode>(U)) { // PHI Node
                getCallBases(PN, callBases, visited); // 向后查找
            }
            else {
                my_errs() << "[getCallBases] Unhandled user: " << *U << "\n";
            }
        }
    }

    // 查找函数的所有调用点
    void getCallBases(llvm::Value *V, std::vector<llvm::CallBase*> &callBases) {
        llvm::SmallPtrSet<llvm::Value*, 16> visited;
        getCallBases(V, callBases, visited);
    }

    // 获取函数返回指令
    llvm::ReturnInst & getReturnInst(llvm::Function &F) {
        for (auto &BB : F) {
            if (auto *RI = llvm::dyn_cast<llvm::ReturnInst>(BB.getTerminator())) {
                my_errs() << "[getReturnInst] Found ReturnInst" << *RI << "\n";
                return *RI;
            }
        }
        my_errs() << "Function " << F.getName() << " has no ReturnInst!\n";
        llvm::report_fatal_error("No ReturnInst found");
    }

    // 判断两个指令是否在同一基本块内
    bool isInSameBasicBlock(llvm::Instruction *I1, llvm::Instruction *I2) {
        return I1->getParent() == I2->getParent();
    }

    // 查找参数在调用指令中的索引
    int findArgIndexInCall(llvm::CallBase *CB, llvm::Value *ArgVal) {
        for (unsigned i = 0; i < CB->arg_size(); i++) {
            if (CB->getArgOperand(i)->stripPointerCasts() == ArgVal) {
                return i;
            }
        }
        return -1; // 未找到
    }
};




// This method implements what the pass does
bool passImpl(llvm::Module &M) {
    for (llvm::Function &F : M) { // 遍历模块中的每个函数
        if (F.isDeclaration()) continue; // 跳过无体函数

        for (llvm::BasicBlock &BB : F) { // 遍历函数中的每个基本块
            for (llvm::Instruction &I : BB) { // 遍历基本块中的每条指令
                if (auto *CI = llvm::dyn_cast<llvm::CallInst>(&I)) { // 找到所有的函数调用指令！
                    unsigned line = I.getDebugLoc() ? I.getDebugLoc().getLine() : 0; // 指令所在的源代码行号
                    auto collecter = FuncDefCollector(CI, line);
                    collecter.collect(); // 收集可能的函数指针目标
                    collecter.report();  // 输出结果
                }
            }
        }
    }

    return false;
}
} // namespace HomeworkLLVM
