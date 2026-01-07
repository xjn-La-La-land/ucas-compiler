#ifndef HWLLVMP_H
#define HWLLVMP_H
#include "llvm/IR/Module.h"
namespace HomeworkLLVM {
bool passImpl(llvm::Module &M);
extern bool useErrs;
}
#endif
