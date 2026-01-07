//==--- tools/clang-check/ClangInterpreter.cpp - Clang Interpreter tool --------------===//
//===----------------------------------------------------------------------===//
#pragma once
#include <cstdio>
#include <cstdlib>
#include <stdexcept>

#include "clang/AST/ASTConsumer.h"
#include "clang/AST/Decl.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendAction.h"
#include "clang/Tooling/Tooling.h"

using namespace clang;


extern bool useErrs;
llvm::raw_ostream &my_errs(); // 错误输出流（根据 --stderr 打开/关闭）

class CtrlFlowException {
public:
    enum CFEType { RETURN, BREAK, CONTINUE };
private:
    enum CFEType type;
public:
    CtrlFlowException(CFEType t) : type(t) { }
    long isReturn() { return type == RETURN; }
    long isBreak() { return type == BREAK; }
    long isContinue() { return type == CONTINUE; }
};


class StackFrame // 栈帧类
{
  private:
    /// StackFrame maps Variable Declaration to Value
    /// Which are either integer or addresses (also represented using an Integer value)
    std::map<Decl *, int64_t> mVars;  // 存储变量声明到值的映射
    std::map<Stmt *, int64_t> mExprs; // 存储语句到值的映射
    std::map<Stmt *, int64_t> mPtrs;  // 存储指针到值的映射（地址）
    /// The return value
    int64_t returnValue;

  public:
    StackFrame() : mVars(), mExprs(), mPtrs(), returnValue(0){}

    void bindDecl(Decl *decl, int64_t val) {
        mVars[decl] = val;
    }
    bool findDecl(Decl *decl) {
        return mVars.find(decl) != mVars.end();
    }
    int64_t getDeclVal(Decl *decl) {
        assert(findDecl(decl));
        return mVars.find(decl)->second;
    }
    void bindStmt(Stmt *stmt, int64_t val) {
        mExprs[stmt] = val;
    }
    bool findStmt(Stmt *stmt) {
        return mExprs.find(stmt) != mExprs.end();
    }
    int64_t getStmtVal(Stmt *stmt) {
        assert(findStmt(stmt));
        return mExprs[stmt];
    }
    void bindPtr(Stmt *stmt, int64_t val) {
        mPtrs[stmt] = val;
    }
    bool findPtr(Stmt *stmt) {
        return mPtrs.find(stmt) != mPtrs.end();
    }
    int64_t getPtrVal(Stmt *stmt) {
        assert(findPtr(stmt));
        return mPtrs[stmt];
    }
    void setReturnValue(int64_t val) {
        returnValue = val;
    }
    int64_t getReturnValue() {
        return returnValue;
    }
};

class GlobalVars // 全局变量类
{
  private:
    std::map<Decl *, int64_t> mVars; // 存储全局变量到值的映射
  public:
    GlobalVars() : mVars(){}

    void bindDecl(Decl *decl, int64_t val) {
        mVars[decl] = val;
    }
    int64_t getDeclVal(Decl *decl) {
        assert(mVars.find(decl) != mVars.end());
        return mVars.find(decl)->second;
    }
};


class Heap // 堆类，管理动态内存分配
{
  private:
    std::map<void *, int64_t> mSpace; // 存储分配的内存空间，<ptr, size>
  public:
    Heap() : mSpace(){}
    ~Heap() {
        // 析构 Heap 时 Free 掉局部变量中申请的空间（当然也有testcase源码中忘 Free 的情况）
        if(mSpace.empty()) return;
        for(auto& pair : mSpace) {
            void *ptr = pair.first;
            free(ptr);
        }
        mSpace.clear();
    }

    void *Malloc(int size) {
        void *ptr = malloc(size);
        if (!ptr) return nullptr; // 分配失败
        mSpace[ptr] = size;
        return ptr;
    }
    void Free(void *ptr) {
        assert(mSpace.find(ptr) != mSpace.end());
        mSpace.erase(ptr);
        free(ptr);
    }
};

class Environment
{
    std::vector<StackFrame> mStack; // 函数调用栈
    Heap mHeap; // 用于 Malloc / Free，管理堆上空间
    GlobalVars mGlobal; // 存储全局变量/常量

    const ASTContext &context;

    /// Declarations to the built-in functions
    FunctionDecl *mFree;   // free()
    FunctionDecl *mMalloc; // malloc()
    FunctionDecl *mInput;  // scanf()
    FunctionDecl *mOutput; // printf()

    FunctionDecl *mEntry; // main 函数入口

  public:
    /// Get the declarations to the built-in functions
    Environment(const ASTContext &Context) : mStack(), mHeap(), mGlobal(), context(Context), mFree(nullptr), mMalloc(nullptr), mInput(nullptr), mOutput(nullptr), mEntry(nullptr) {
        mStack.push_back(StackFrame());
    }


    FunctionDecl *getEntry() { return mEntry; }
    StackFrame &currentFrame() { return mStack.back(); }

    bool isBuiltIn(CallExpr *callexpr) {
        FunctionDecl *callee = callexpr->getDirectCallee();
        return (callee == mFree || callee == mMalloc || callee == mInput || callee == mOutput);
    }

    // 查询变量的值
    int64_t getDeclVal(Decl *decl) {
        // 如果当前栈帧中没有此变量，则应该在全局中
        if(currentFrame().findDecl(decl)) 
            return currentFrame().getDeclVal(decl);
        else
            return mGlobal.getDeclVal(decl);
    }

    // 查询语句的值
    int64_t getStmtVal(Expr *expr) {
        // 全局里不应该存在 Stmt，指令都需要进函数
        return currentFrame().getStmtVal(expr);
    }
    // 查询条件表达式的值（bool）
    bool getCondVal(Expr *expr) {
        return getStmtVal(expr) != 0;
    }

    // 查询指针的值（地址）
    int64_t getPtrVal(Expr *expr) {
        return currentFrame().getPtrVal(expr);
    }

    // 为左值赋值:
    // - x = 5; 绑定 x 的值为 5
    // - *p = 10; 绑定地址 p 指向的值为 10
    // - arr[2] = 20; 绑定数组 arr 下标 2 的值为 20
    void assgnLVal(Expr *expr, int64_t val) {
        if (DeclRefExpr *declexpr = dyn_cast<DeclRefExpr>(expr))
        {
            Decl *decl = declexpr->getFoundDecl();
            currentFrame().bindDecl(decl, val);
        }
        else if (ArraySubscriptExpr *arraysub = dyn_cast<ArraySubscriptExpr>(expr))
        {
            int64_t addr = getPtrVal(arraysub);
            QualType type = arraysub->getType();
            if(type->isCharType()) {
                *((char *)addr) = (char)val;
            } else if(type->isIntegerType()) {
                *((int *)addr) = (int)val;
            } else if(type->isPointerType()) {
                *((int64_t *)addr) = val;
            }
        }
        else if (UnaryOperator *uop = dyn_cast<UnaryOperator>(expr))
        {
            assert(uop->getOpcode() == UO_Deref);
            int64_t addr = getPtrVal(uop);
            QualType type = uop->getType();
            if(type->isCharType()) {
                *((char *)addr) = (char)val;
            } else if(type->isIntegerType()) {
                *((int *)addr) = (int)val;
            } else if(type->isPointerType()) {
                *((int64_t *)addr) = val;
            }
        }
    }

    // 绑定语句的值
    void bindStmtVal(Expr *expr, int64_t val) {
        currentFrame().bindStmt(expr, val);
    }

    // 绑定指针的值（地址）
    void bindPtrVal(Expr *expr, int64_t val) {
        currentFrame().bindPtr(expr, val);
    }


    /// Initialize global variables
    void initGlobalVars(TranslationUnitDecl *);
    
    // Statement handlers
    void intliteral(Expr *);                // 处理整数常量表达式节点
    void charliteral(Expr *);               // 处理字符常量表达式节点
    void paren(Expr *);                     // 处理括号表达式节点
    void binop(BinaryOperator *);           // 处理二元运算表达式节点
    void unaryop(UnaryOperator *);          // 处理一元运算表达式节点
    void ueott(UnaryExprOrTypeTraitExpr *); // 处理 sizeof 表达式节点
    void cast(CastExpr *);                  // 处理类型转换表达式节点
    void arraysub(ArraySubscriptExpr *);    // 处理数组下标表达式节点

    // Declaration handlers
    void vardecl(Decl *);                // 处理变量声明节点
    void fdecl(Decl *);                  // 处理函数声明节点
    void declref(DeclRefExpr *);         // 处理引用声明节点

    void callbuildin(CallExpr *);        // 处理内置函数调用节点
    void call(CallExpr *);               // 处理一般函数调用节点
    void exit(CallExpr *);               // 处理函数退出
    void returnstmt(ReturnStmt *);       // 处理返回语句节点
};
