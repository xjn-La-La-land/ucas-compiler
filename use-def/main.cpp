#include "HomeworkLLVMPass.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Pass.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/raw_ostream.h"

#include "llvm/IR/Dominators.h"            // DominatorTree
#include "llvm/IR/PassManager.h"           // Needed for full definition
#include "llvm/Passes/PassBuilder.h"

#include "llvm/Transforms/Utils/Mem2Reg.h"

#include "llvm/Support/FileSystem.h"

#include <string>
#include <system_error>

#include <llvm/Support/ManagedStatic.h>
#include <llvm/Support/ToolOutputFile.h>

#include <llvm/Transforms/Scalar.h>
#include <llvm/Transforms/Utils.h>

using namespace llvm;

class EnableFunctionOptPass : public PassInfoMixin<EnableFunctionOptPass> {
public:
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) {
        bool Changed = false;
        for (auto & F : M) {
          if (F.hasFnAttribute(Attribute::OptimizeNone)) {
              F.removeFnAttr(Attribute::OptimizeNone);
              Changed = true;
          }
        }
        return Changed ? PreservedAnalyses::none() 
                       : PreservedAnalyses::all();
    }
    
    static StringRef name() { return "EnableFunctionOptPass"; }
};


LLVMContext context;
SMDiagnostic Err;
cl::opt<std::string> InputFilename(cl::Positional, cl::desc("<input file>"), cl::Required);
cl::opt<bool> StdErrOption("stderr", cl::desc("Enable stderr output"));
cl::alias StdErrOptionShort("e", cl::aliasopt(StdErrOption));
cl::opt<std::string> DumpAfterMem2Reg("dump-after-mem2reg",
    cl::desc("Dump IR after mem2reg to the specified .ll file"),
    cl::value_desc("filename"),
    cl::init(""));

int main(const int argc, const char *const argv[]) {
    cl::ParseCommandLineOptions(argc, argv);

    auto M = parseIRFile(InputFilename, Err, context);
    if (!M) {
        Err.print(InputFilename.c_str(), errs());
    }
    HomeworkLLVM::useErrs = StdErrOption;

    // 应用 mem2reg (PromoteMemoryToRegister) 优化
    PassBuilder PB;
    LoopAnalysisManager LAM;
    FunctionAnalysisManager FAM;
    CGSCCAnalysisManager CGAM;
    ModuleAnalysisManager MAM;

    PB.registerModuleAnalyses(MAM);
    PB.registerCGSCCAnalyses(CGAM);
    PB.registerFunctionAnalyses(FAM);
    PB.registerLoopAnalyses(LAM);
    PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);

    ModulePassManager MPM;

    MPM.addPass(EnableFunctionOptPass());
    // The new mem2reg
    MPM.addPass(createModuleToFunctionPassAdaptor(PromotePass()));

    MPM.run(*M, MAM);

    // 输出 mem2reg 后的 IR
    if (!DumpAfterMem2Reg.empty()) {
        std::error_code EC;
        raw_fd_ostream OS(DumpAfterMem2Reg, EC, sys::fs::OF_None);
        if (EC) {
            errs() << "Error opening file '" << DumpAfterMem2Reg
                   << "': " << EC.message() << "\n";
            return 1;
        }
        M->print(OS, nullptr);
        outs() << "IR dumped to " << DumpAfterMem2Reg << "\n";
    }
    
    if (HomeworkLLVM::passImpl(*M)) {
        return 1;
    }

    return 0;
}
