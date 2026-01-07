//==--- tools/clang-check/ClangInterpreter.cpp - Clang Interpreter tool --------------===//
//===----------------------------------------------------------------------===//

#include "clang/AST/ASTConsumer.h"
#include "clang/AST/EvaluatedExprVisitor.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendAction.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"

using namespace clang;

#include "Environment.h"

class InterpreterVisitor : public EvaluatedExprVisitor<InterpreterVisitor>
{
  public:
    explicit InterpreterVisitor(const ASTContext &context, Environment *env)
        : EvaluatedExprVisitor(context), mEnv(env){}
    virtual ~InterpreterVisitor(){}

    virtual void VisitIntegerLiteral(IntegerLiteral *intl) {
        mEnv->intliteral(intl);
    }
    
    virtual void VisitCharacterLiteral(CharacterLiteral *charl) {
        mEnv->charliteral(charl);
    }

    virtual void VisitParenExpr(ParenExpr *paren) {
        VisitStmt(paren);
        mEnv->paren(paren);
    }

    virtual void VisitBinaryOperator(BinaryOperator *bop) {
        VisitStmt(bop);
        mEnv->binop(bop);
    }
    virtual void VisitUnaryOperator(UnaryOperator *uop) {
        VisitStmt(uop);
        mEnv->unaryop(uop);
    }
    virtual void VisitDeclRefExpr(DeclRefExpr *expr) {
        VisitStmt(expr);
        mEnv->declref(expr);
    }
    virtual void VisitCastExpr(CastExpr *expr) {
        VisitStmt(expr);
        mEnv->cast(expr);
    }
    virtual void VisitCallExpr(CallExpr *call) {
        VisitStmt(call);
        
        if(mEnv->isBuiltIn(call)) {
            // printf("Call built-in function.\n");
            mEnv->callbuildin(call);
            return;
        }

        mEnv->call(call);
        FunctionDecl *callee = call->getDirectCallee();
        if(callee->isDefined()) {
            callee = callee->getDefinition();
        }
        try {
            VisitStmt(callee->getBody());
        } catch (CtrlFlowException &e) {
            if(e.isReturn()) {
                std::string funcName = callee->getNameAsString();
                my_errs() << "Return from function call" << funcName << ".\n";
            } else {
                throw std::logic_error("Unexpected CtrlFlowException");
            }
        }
        
        mEnv->exit(call);
    }

    virtual void VisitReturnStmt(ReturnStmt *returnstmt) {
        VisitStmt(returnstmt);
        mEnv->returnstmt(returnstmt);
        throw CtrlFlowException(CtrlFlowException::RETURN);
    }

    virtual void VisitArraySubscriptExpr(ArraySubscriptExpr *arraysub) {
        VisitStmt(arraysub);
        mEnv->arraysub(arraysub);
    }

    virtual void VisitUnaryExprOrTypeTraitExpr(UnaryExprOrTypeTraitExpr *ueott) {
        VisitStmt(ueott);
        mEnv->ueott(ueott);
    }

    virtual void VisitDeclStmt(DeclStmt *declstmt) {
        for (auto *SubDecl : declstmt->decls())
        {
            if(SubDecl == nullptr) continue;
            if(VarDecl *vardecl = dyn_cast<VarDecl>(SubDecl)) {
                VisitVarDecl(vardecl);
            }
            // more decl
        }
    }

    virtual void VisitIfStmt(IfStmt *ifstmt) {
        Expr *condExpr = ifstmt->getCond();
        Stmt *thenStmt = ifstmt->getThen();
        Stmt *elseStmt = ifstmt->getElse();
        
        if(condExpr == nullptr) return;
        Visit(condExpr);
        if(mEnv->getCondVal(condExpr)) {
            Visit(thenStmt);
        } else if (elseStmt) {
            Visit(elseStmt);
        }
    }

    // 处理三目运算符
    virtual void VisitConditionalOperator(ConditionalOperator *condop) {
        Expr *condExpr = condop->getCond();
        Expr *trueExpr = condop->getTrueExpr();
        Expr *falseExpr = condop->getFalseExpr();
        if (condExpr == nullptr || trueExpr == nullptr || falseExpr == nullptr)
          return;

        Visit(condExpr);
        if(mEnv->getCondVal(condExpr)) {
            Visit(trueExpr);
            mEnv->bindStmtVal(condop, mEnv->getStmtVal(trueExpr));
        } else {
            Visit(falseExpr);
            mEnv->bindStmtVal(condop, mEnv->getStmtVal(falseExpr));
        }        
    }

    virtual void VisitWhileStmt(WhileStmt * whstmt) {
        Expr *condExpr = whstmt->getCond();
        Stmt *bodyStmt = whstmt->getBody();
        if(condExpr == nullptr) return;

        Visit(condExpr);
        while(mEnv->getCondVal(condExpr))
        {
            try {
                Visit(bodyStmt); // At least: NullStmt
            } catch (CtrlFlowException &e) {
                if(e.isBreak()) {
                    my_errs() << "Break in While loop.\n";
                    break;
                } else if(e.isContinue()) {
                    my_errs() << "Continue in While loop.\n";
                } else {
                    throw std::logic_error("Unexpected CtrlFlowException");
                }
            }
            Visit(condExpr);
        }
    }

    virtual void VisitForStmt(ForStmt *forstmt) {
        Stmt *initStmt = forstmt->getInit();
        Expr *condExpr = forstmt->getCond();
        Expr *incExpr = forstmt->getInc();
        Stmt *bodyStmt = forstmt->getBody();
            
        if(initStmt) Visit(initStmt);
        
        while(true) 
        {
            if(condExpr) { // for(;;); -> condExpr is nullptr
                Visit(condExpr);
                if(!mEnv->getCondVal(condExpr)) break;
            }
            try {
                Visit(bodyStmt); // At least: NullStmt
            } catch (CtrlFlowException &e) {
                if(e.isBreak()) {
                    my_errs() << "Break in For loop.\n";
                    break;
                } else if(e.isContinue()) {
                    my_errs() << "Continue in For loop.\n";
                } else {
                    throw std::logic_error("Unexpected CtrlFlowException");
                }
            } 
            if(incExpr) Visit(incExpr);
        }
    }

    virtual void VisitBreakStmt(BreakStmt *breakstmt) {
        throw CtrlFlowException(CtrlFlowException::BREAK);
    }

    virtual void VisitContinueStmt(ContinueStmt *constmt) {
        throw CtrlFlowException(CtrlFlowException::CONTINUE);
    }  

    virtual void VisitVarDecl(VarDecl *vardecl) {
        if(vardecl == nullptr) return;
        if(vardecl->hasInit()) {
            Expr * init = vardecl->getInit();
            Visit(init); // 从init子节点本身开始Visit，而不是VisitStmt
        }
        mEnv->vardecl(vardecl);
    }

    virtual void VisitFunctionDecl(FunctionDecl *fdecl) {
        mEnv->fdecl(fdecl);
    }

    void Init(TranslationUnitDecl *unit) {
        for (auto *SubDecl : unit->decls())
        {
            if(SubDecl == nullptr) continue;
            if(FunctionDecl *fdecl = dyn_cast<FunctionDecl>(SubDecl)) {
                VisitFunctionDecl(fdecl);
            } else if(VarDecl *vardecl = dyn_cast<VarDecl>(SubDecl)) {
                VisitVarDecl(vardecl);
            }
        }
        mEnv->initGlobalVars(unit);
        FunctionDecl *entry = mEnv->getEntry();
        try {
            VisitStmt(entry->getBody());
        } catch (CtrlFlowException &e) {
            if (e.isReturn()) {
                my_errs() << "Return from function call main.\n";
            } else {
                throw std::logic_error("Unexpected CtrlFlowException");
            }
        }
    }

  private:
    Environment *mEnv;
};

class InterpreterConsumer : public ASTConsumer
{
  public:
    explicit InterpreterConsumer(const ASTContext &context) : mEnv(context), mVisitor(context, &mEnv){}
    virtual ~InterpreterConsumer(){}

    virtual void HandleTranslationUnit(clang::ASTContext &Context)
    {
        TranslationUnitDecl *decl = Context.getTranslationUnitDecl();
        mVisitor.Init(decl);
    }

  private:
    Environment mEnv;
    InterpreterVisitor mVisitor;
};

class InterpreterClassAction : public ASTFrontendAction
{
  public:
    virtual std::unique_ptr<clang::ASTConsumer> CreateASTConsumer(clang::CompilerInstance &Compiler,
                                                                  llvm::StringRef InFile)
    {
        return std::unique_ptr<clang::ASTConsumer>(
            new InterpreterConsumer(Compiler.getASTContext()));
    }
};

llvm::cl::opt<std::string> InputFile(llvm::cl::Positional, llvm::cl::desc("<source>.c"), llvm::cl::Required);
llvm::cl::opt<bool> FileOption("file", llvm::cl::desc("Enable read from file"));
llvm::cl::alias FileOptionShort("f", llvm::cl::aliasopt(FileOption));
llvm::cl::opt<bool> StdErrOption("stderr", llvm::cl::desc("Enable stderr output"));
llvm::cl::alias StdErrOptionShort("e", llvm::cl::aliasopt(StdErrOption));
std::string readFileContent(std::string);

bool useErrs = true;
llvm::raw_ostream &my_errs() {
    return useErrs ? llvm::errs() : llvm::nulls();
}

int main(int argc, char *argv[])
{
    llvm::cl::ParseCommandLineOptions(argc, argv, "Clang AST Interpreter for tiny C.\n");

    if (InputFile.empty()) {
        llvm::errs() << "[Error] Missing required C source file parameter.\n";
        llvm::cl::PrintHelpMessage(false, true);
        return 1;
    }

    // 获取命令行参数的值
    std::string inputFile = InputFile;
    bool useFile = FileOption;
    useErrs = StdErrOption;

    std::string sourceCode;
    // 判断直接传入源代码字符串还是从源代码文件读取
    if (!useFile) {
        sourceCode = inputFile;
    } else { // read code from file
        llvm::StringRef InputFilename(inputFile);
        auto FileOrErr = llvm::MemoryBuffer::getFile(InputFilename); // 打开输入文件
        if (FileOrErr) {
            auto File = std::move(FileOrErr.get());
            sourceCode = File->getBuffer().str();
        } else {
            llvm::errs() << "[Error] Fail to read file: " << InputFilename << ".\n";
        }
    }

    if(sourceCode.empty()) return 1;

    // llvm::errs() << "Hello from errs()!\n";
    // llvm::errs().flush();

    clang::tooling::runToolOnCode(
        std::unique_ptr<clang::FrontendAction>(new InterpreterClassAction),
        sourceCode
    );
    return 0;
}