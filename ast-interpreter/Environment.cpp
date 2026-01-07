// ===--- Environment.cpp - Environment Class Implementation -------===//

#include "Environment.h"


/// Initialize the global variables from the TranslationUnitDecl
void Environment::initGlobalVars(TranslationUnitDecl *unit)
{
    for (auto *SubDecl : unit->decls()) { // 将第一个栈帧中的全局变量取出
        if (VarDecl *vardecl = dyn_cast<VarDecl>(SubDecl)) {
            int64_t val = getDeclVal(vardecl);
            mGlobal.bindDecl(vardecl, val);
        }
    }

    mStack.pop_back(); // 清除用于全局变量的栈帧
    mStack.push_back(StackFrame()); // 创建 main 函数的栈帧
}


// 处理整数常量表达式节点
void Environment::intliteral(Expr *intlit) {
    Expr::EvalResult result;
    int64_t val = 0;
    if (intlit->EvaluateAsInt(result, this->context))
        val = result.Val.getInt().getExtValue();
    bindStmtVal(intlit, val); // 将（全局/局部）常量存入栈帧
}

// 处理字符常量表达式节点
void Environment::charliteral(Expr *charlit) {
    Expr::EvalResult result;
    int64_t val = 0;
    if (charlit->EvaluateAsInt(result, this->context))
        val = result.Val.getInt().getExtValue();
    bindStmtVal(charlit, val); // 将（全局/局部）常量存入栈帧
}

// 处理括号表达式节点
void Environment::paren(Expr *expr) {
    ParenExpr * paren = dyn_cast<ParenExpr>(expr);
    if(paren == nullptr) return;

    // 将子节点的val绑定到paren
    bindStmtVal(paren, getStmtVal(paren->getSubExpr()));
}

// 处理二元运算表达式节点
void Environment::binop(BinaryOperator *bop)
{
    Expr *left = bop->getLHS();
    Expr *right = bop->getRHS();

    BinaryOperator::Opcode op = bop->getOpcode();
    int64_t leftVal = getStmtVal(left);
    int64_t rightVal = getStmtVal(right);
    int64_t val = 0;

    QualType leftType = left->getType();
    QualType rightType = right->getType();
    
    // 指针运算，乘以类型大小 (e.g., int *p; p + 2 -> p + 2 * sizeof(int))
    if (leftType->isPointerType() && (rightType->isCharType() || rightType->isIntegerType()))
    {
        QualType peType = leftType->getPointeeType();
        int unit = context.getTypeSizeInChars(peType).getQuantity();
        rightVal *= unit;
    }
    // int *p; 2 + p -> 2 * sizeof(int) + p
    else if ((leftType->isCharType() || leftType->isIntegerType()) && rightType->isPointerType())
    {
        QualType peType = rightType->getPointeeType();
        int unit = context.getTypeSizeInChars(peType).getQuantity();
        leftVal *= unit;       
    }

    // 赋值运算符 =, *=, /=, %=, +=, -=, <<=, >>=, &=, ^=, |=
    // from clang/AST/OperationKinds.def
    if (bop->isAssignmentOp())
    {
        assert(left->isLValue() || left->isXValue()); // 左值或将亡值才能赋值
        assert(!leftType->isArrayType()); // 数组类型不能赋值
        switch (op) 
        {
            case BO_Assign:
                val = rightVal; break;
            case BO_AddAssign:
                val = leftVal + rightVal; break;
            case BO_SubAssign:
                val = leftVal - rightVal; break;
            case BO_MulAssign:
                val = leftVal * rightVal; break;
            case BO_DivAssign:
                assert(rightVal != 0);
                val = leftVal / rightVal; break;
            case BO_RemAssign:
                assert(rightVal != 0);
                val = leftVal % rightVal; break;
            case BO_ShlAssign:
                val = leftVal << rightVal; break;
            case BO_ShrAssign:
                val = leftVal >> rightVal; break;
            case BO_AndAssign:
                val = leftVal & rightVal; break;
            case BO_XorAssign:
                val = leftVal ^ rightVal; break;
            case BO_OrAssign:
                val = leftVal | rightVal; break;
            default:
                break;
        }
        assgnLVal(left, val); // assign to left operand
    }
    else // 非赋值运算符 +, -, *, /, %, <<, >>, <, >, <=, >=, ==, !=, &, ^, |, &&, ||
    {
        switch (op)
        {
            case BO_Add:
                val = leftVal + rightVal; break;
            case BO_Sub:
                val = leftVal - rightVal; break;
            case BO_Mul:
                val = leftVal * rightVal; break;
            case BO_Div:
                assert(rightVal != 0);
                val = leftVal / rightVal; break;
            case BO_Rem:
                assert(rightVal != 0);
                val = leftVal % rightVal; break;
            case BO_Shl:
                val = leftVal << rightVal; break;
            case BO_Shr:
                val = leftVal >> rightVal; break;
            case BO_LT:
                val = leftVal < rightVal; break;
            case BO_GT:
                val = leftVal > rightVal; break;
            case BO_LE:
                val = leftVal <= rightVal; break;
            case BO_GE:
                val = leftVal >= rightVal; break;                       
            case BO_EQ:
                val = leftVal == rightVal; break;
            case BO_NE:
                val = leftVal != rightVal; break;
            case BO_And:
                val = leftVal & rightVal; break;
            case BO_Xor:
                val = leftVal ^ rightVal; break;
            case BO_Or:
                val = leftVal | rightVal; break;
            case BO_LAnd:
                val = leftVal && rightVal; break;
            case BO_LOr:
                val = leftVal || rightVal; break;
            default:
                my_errs() << "[Error] Unsupported BinaryOperator.\n";
                bop->dump(my_errs(), this->context);
                break;
        }
    }
    bindStmtVal(bop, val);
}

// 处理一元运算表达式节点
void Environment::unaryop(UnaryOperator *uop)
{
    Expr *expr = uop->getSubExpr();

	int64_t val = 0;
    int64_t exprVal = getStmtVal(expr);
    UnaryOperator::Opcode op = uop->getOpcode();
    
    // 处理自增自减运算 ++, --
    if (uop->isIncrementDecrementOp())
    {
        QualType type = expr->getType();
        int unit = 1;
        if (type->isPointerType()) { // 对指针类型的自增自减，按类型大小移动
            QualType peType = type->getPointeeType();
            unit = context.getTypeSizeInChars(peType).getQuantity();
        }

        switch (op)
        {
            case UO_PreInc:
                exprVal += unit;
                val = exprVal;
                break;
            case UO_PreDec:
                exprVal -= unit;
                val = exprVal;
                break;
            case UO_PostInc:
                val = exprVal;
                exprVal += unit;
                break;
            case UO_PostDec:
                val = exprVal;
                exprVal -= unit;
                break;
            default:
                break;
        }
        assgnLVal(expr, exprVal); // assign to expr
    }
    else // 处理其他一元运算 -, +, ~, !, *, &
    {
        switch (op)
        {
            case UO_Minus:
                val = -exprVal;
                break;
            case UO_Plus:
                val = +exprVal;
                break;
            case UO_Not:
                val = ~exprVal;
                break;
            case UO_LNot:
                val = !exprVal;
                break;

            case UO_Deref: {
                QualType type = uop->getType();
                if(type->isCharType()) {
                    val = *((char *)exprVal);
                } else if (type->isIntegerType()) {
                    val = *((int *)exprVal);
                } else if (type->isPointerType()) {
                    val = *((int64_t *)exprVal);
                }
                bindPtrVal(uop, exprVal);
                break;
            }
            case UO_AddrOf: {
                // Extra TODO: Support UO_AddrOf like `int *p = &a;`
                break;
            }

            default:
                my_errs() << "[Error] Unsupported UnaryOperator.\n";
                uop->dump(my_errs(), this->context);
                break;
        }
    }
    bindStmtVal(uop, val);
}

// 处理 sizeof 表达式节点
void Environment::ueott(UnaryExprOrTypeTraitExpr *ueott)
{
    UnaryExprOrTypeTrait uett = ueott->getKind();
    int64_t size = 0;
    if (uett == UETT_SizeOf) {
        QualType argType = ueott->getTypeOfArgument();
        size = context.getTypeSizeInChars(argType).getQuantity();
    }
    else {
        my_errs() << "[Error] Unsupported UnaryExprOrTypeTraitExpr.\n";
        ueott->dump(my_errs(), this->context);
    }
    bindStmtVal(ueott, size);
}


// 处理变量声明节点: int a = 5; int arr[10]; char *p;
void Environment::vardecl(Decl *decl)
{
    VarDecl *vardecl = dyn_cast<VarDecl>(decl);
    if(vardecl == nullptr) return;
    QualType type = vardecl->getType();
    if(type->isCharType() || type->isIntegerType() || type->isPointerType())
    {
        int64_t val = 0;
        if(vardecl->hasInit()) {
            val = getStmtVal(vardecl->getInit());
        }
        currentFrame().bindDecl(vardecl, val); // 绑定变量到当前栈帧
    }
    else if(type->isArrayType())
    {
        auto array = dyn_cast<ConstantArrayType>(type.getTypePtr());
        int size = array->getSize().getZExtValue();
        QualType elemType = array->getElementType();
        int unit = context.getTypeSizeInChars(elemType).getQuantity();
        // 在堆上为数组分配空间
        void *addr = nullptr;
        addr = mHeap.Malloc(size * unit);
        memset(addr, 0, size * unit); // 初始化为0
        currentFrame().bindDecl(vardecl, (int64_t)addr);
        // 初始化赋值
        if (vardecl->hasInit()) {
            Expr *initExpr = vardecl->getInit();
            auto *initList = dyn_cast<InitListExpr>(initExpr);
            if (initList == nullptr) {
                my_errs() << "[Error] Unsupported Array InitExpr.\n";
                initExpr->dump(my_errs(), this->context);
                return;
            }
            unsigned numInits = initList->getNumInits();
            assert(numInits <= (unsigned)size);
            for (unsigned i = 0; i < numInits; ++i) {
                int64_t elemVal = getStmtVal(initList->getInit(i));
                if(elemType->isCharType()) {
                    *((char *)addr + i * unit) = (char)elemVal;
                } else if(elemType->isIntegerType()) {
                    *((int *)addr + i * unit) = (int)elemVal;
                } else if(elemType->isPointerType()) {
                    *((int64_t *)addr + i * unit) = elemVal;
                }
            }
        }
    }
    else {
        my_errs() << "[Error] Unsupported VarDecl.\n";
    }
}

// 处理函数声明节点: extern int PRINT();
void Environment::fdecl(Decl *decl)
{
    FunctionDecl *fdecl = dyn_cast<FunctionDecl>(decl);

    if(fdecl == nullptr) return;
    if (fdecl->getName() == "FREE")
        mFree = fdecl;
    else if (fdecl->getName() == "MALLOC")
        mMalloc = fdecl;
    else if (fdecl->getName() == "GET")
        mInput = fdecl;
    else if (fdecl->getName() == "PRINT")
        mOutput = fdecl;
    else if (fdecl->getName() == "main")
        mEntry = fdecl;
    // else: 其他非内置函数不需要额外处理
}

// 处理引用声明节点: 变量引用/函数引用
void Environment::declref(DeclRefExpr *declref)
{
    QualType type = declref->getType();
    
    // 如果是变量，获取当前 Decl 的值绑定到当前 Stmt
    if (type->isCharType() || type->isIntegerType() || type->isArrayType() || type->isPointerType())
    {
        Decl *decl = declref->getFoundDecl();
        int64_t val = getDeclVal(decl);
        bindStmtVal(declref, val);
    }
    else if(!type->isFunctionType()) // 不对函数进行处理（Call函数单独处理）
    {
        my_errs() << "[Error] Unsupported DeclRef.\n";
        declref->dump(my_errs(), this->context);
    }
}

// 处理类型转换表达式节点
void Environment::cast(CastExpr *castexpr)
{
    QualType type = castexpr->getType();

    if (type->isCharType() || type->isIntegerType() ||
        (type->isPointerType() && !type->isFunctionPointerType())) // cast 时，不能包括 FunctionPointer，因为栈帧中可能并没有其信息
    {
        Expr *expr = castexpr->getSubExpr();
        int64_t val = getStmtVal(expr);
        bindStmtVal(castexpr, val);
    }
    else if(!type->isFunctionPointerType())
    {
        my_errs() << "[Error] Unsupported CastExpr.\n";
        castexpr->dump(my_errs(), this->context);
    }
}

// 处理数组下标表达式节点
void Environment::arraysub(ArraySubscriptExpr *arraysub)
{
    Expr *base = arraysub->getBase();
    Expr *index = arraysub->getIdx();

    QualType type = arraysub->getType();
    int64_t val = 0, addr = 0;
    if(type->isCharType()) {
        addr = getStmtVal(base) + getStmtVal(index) * sizeof(char);
        val = *((char *)addr);
    } else if(type->isIntegerType()) {
        addr = getStmtVal(base) + getStmtVal(index) * sizeof(int);
        val = *((int *)addr);
    } else if(type->isPointerType()) {
        addr = getStmtVal(base) + getStmtVal(index) * sizeof(int64_t);
        val = *((int64_t *)addr);
    }
    bindStmtVal(arraysub, val);
    bindPtrVal(arraysub, addr);
}


// 处理内置函数调用节点
void Environment::callbuildin(CallExpr *callexpr)
{
    int64_t val = 0;
    FunctionDecl *callee = callexpr->getDirectCallee();
    if (callee == mInput)
    {
        my_errs() << "Please Input an Integer Value : ";
        scanf("%ld", &val);
        bindStmtVal(callexpr, val);
    }
    else if (callee == mOutput)
    {
        Expr *msg = callexpr->getArg(0);
        llvm::outs() << getStmtVal(msg);
    }
    else if (callee == mMalloc)
    {
        Expr *size = callexpr->getArg(0);
        void *ptr = mHeap.Malloc((int)getStmtVal(size));
        bindStmtVal(callexpr, (int64_t)ptr);
    }
    else if (callee == mFree)
    {
        Expr *addr = callexpr->getArg(0);
        mHeap.Free((void *)getStmtVal(addr));
    }
    else
    {
        my_errs() << "[Error] Unsupported BuildIn Function.\n";
        callexpr->dump(my_errs(), this->context);
    }
}

// 处理一般函数调用节点
void Environment::call(CallExpr *callexpr)
{
    FunctionDecl *callee = callexpr->getDirectCallee();
    if (callee->isDefined()) {
        callee = callee->getDefinition();
    }
    int argsNum = callexpr->getNumArgs();
    assert(argsNum == callee->getNumParams());
    StackFrame calleeFrame = StackFrame(); // 新建栈帧
    for(int i = 0; i < argsNum; ++i) { // 绑定参数到新栈帧
        calleeFrame.bindDecl(callee->getParamDecl(i), getStmtVal(callexpr->getArg(i)));
    }
    mStack.push_back(calleeFrame);
}

// 处理函数退出
void Environment::exit(CallExpr *callexpr)
{
    FunctionDecl *callee = callexpr->getDirectCallee();
    QualType type = callee->getReturnType();
    if (!type->isVoidType()) {
        int64_t returnValue = currentFrame().getReturnValue();
        mStack.pop_back();
        bindStmtVal(callexpr, returnValue);
    }
    else {
        mStack.pop_back();
    }
}

// 处理返回语句节点
void Environment::returnstmt(ReturnStmt *returnstmt)
{
    Expr *retVal = returnstmt->getRetValue();
    QualType type = retVal->getType();
    if (type->isVoidType()) return;

    currentFrame().setReturnValue(getStmtVal(retVal)); // 设置返回值
}
