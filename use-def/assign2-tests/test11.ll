; ModuleID = 'test11.bc'
source_filename = "/home/clr/use-def/assign2-tests/test11.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-generic-linux"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @plus(i32 noundef %0, i32 noundef %1) #0 !dbg !12 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
    #dbg_declare(ptr %3, !18, !DIExpression(), !19)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !20, !DIExpression(), !21)
  %5 = load i32, ptr %3, align 4, !dbg !22
  %6 = load i32, ptr %4, align 4, !dbg !23
  %7 = add nsw i32 %5, %6, !dbg !24
  ret i32 %7, !dbg !25
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @minus(i32 noundef %0, i32 noundef %1) #0 !dbg !26 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
    #dbg_declare(ptr %3, !27, !DIExpression(), !28)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !29, !DIExpression(), !30)
  %5 = load i32, ptr %3, align 4, !dbg !31
  %6 = load i32, ptr %4, align 4, !dbg !32
  %7 = sub nsw i32 %5, %6, !dbg !33
  ret i32 %7, !dbg !34
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @foo(i32 noundef %0, i32 noundef %1, ptr noundef %2, ptr noundef %3) #0 !dbg !35 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  store i32 %0, ptr %5, align 4
    #dbg_declare(ptr %5, !39, !DIExpression(), !40)
  store i32 %1, ptr %6, align 4
    #dbg_declare(ptr %6, !41, !DIExpression(), !42)
  store ptr %2, ptr %7, align 8
    #dbg_declare(ptr %7, !43, !DIExpression(), !44)
  store ptr %3, ptr %8, align 8
    #dbg_declare(ptr %8, !45, !DIExpression(), !46)
  %9 = load ptr, ptr %7, align 8, !dbg !47
  ret ptr %9, !dbg !48
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @clever(i32 noundef %0, i32 noundef %1, ptr noundef %2, ptr noundef %3) #0 !dbg !49 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  store i32 %0, ptr %5, align 4
    #dbg_declare(ptr %5, !52, !DIExpression(), !53)
  store i32 %1, ptr %6, align 4
    #dbg_declare(ptr %6, !54, !DIExpression(), !55)
  store ptr %2, ptr %7, align 8
    #dbg_declare(ptr %7, !56, !DIExpression(), !57)
  store ptr %3, ptr %8, align 8
    #dbg_declare(ptr %8, !58, !DIExpression(), !59)
    #dbg_declare(ptr %9, !60, !DIExpression(), !61)
  %10 = load i32, ptr %5, align 4, !dbg !62
  %11 = load i32, ptr %6, align 4, !dbg !63
  %12 = load ptr, ptr %7, align 8, !dbg !64
  %13 = load ptr, ptr %8, align 8, !dbg !65
  %14 = call ptr @foo(i32 noundef %10, i32 noundef %11, ptr noundef %12, ptr noundef %13), !dbg !66
  store ptr %14, ptr %9, align 8, !dbg !67
  %15 = load ptr, ptr %9, align 8, !dbg !68
  %16 = load i32, ptr %5, align 4, !dbg !69
  %17 = load i32, ptr %6, align 4, !dbg !70
  %18 = call i32 %15(i32 noundef %16, i32 noundef %17), !dbg !68
  ret i32 %18, !dbg !71
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @moo(i8 noundef signext %0, i32 noundef %1, i32 noundef %2) #0 !dbg !72 {
  %4 = alloca i8, align 1
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca i32, align 4
  store i8 %0, ptr %4, align 1
    #dbg_declare(ptr %4, !76, !DIExpression(), !77)
  store i32 %1, ptr %5, align 4
    #dbg_declare(ptr %5, !78, !DIExpression(), !79)
  store i32 %2, ptr %6, align 4
    #dbg_declare(ptr %6, !80, !DIExpression(), !81)
    #dbg_declare(ptr %7, !82, !DIExpression(), !83)
  store ptr @plus, ptr %7, align 8, !dbg !83
    #dbg_declare(ptr %8, !84, !DIExpression(), !85)
  store ptr @minus, ptr %8, align 8, !dbg !85
    #dbg_declare(ptr %9, !86, !DIExpression(), !87)
  store ptr null, ptr %9, align 8, !dbg !87
  %11 = load i8, ptr %4, align 1, !dbg !88
  %12 = sext i8 %11 to i32, !dbg !88
  %13 = icmp eq i32 %12, 43, !dbg !90
  br i1 %13, label %14, label %16, !dbg !90

14:                                               ; preds = %3
  %15 = load ptr, ptr %7, align 8, !dbg !91
  store ptr %15, ptr %9, align 8, !dbg !93
  br label %23, !dbg !94

16:                                               ; preds = %3
  %17 = load i8, ptr %4, align 1, !dbg !95
  %18 = sext i8 %17 to i32, !dbg !95
  %19 = icmp eq i32 %18, 45, !dbg !97
  br i1 %19, label %20, label %22, !dbg !97

20:                                               ; preds = %16
  %21 = load ptr, ptr %8, align 8, !dbg !98
  store ptr %21, ptr %9, align 8, !dbg !100
  br label %22, !dbg !101

22:                                               ; preds = %20, %16
  br label %23

23:                                               ; preds = %22, %14
    #dbg_declare(ptr %10, !102, !DIExpression(), !104)
  %24 = load i32, ptr %5, align 4, !dbg !105
  %25 = load i32, ptr %6, align 4, !dbg !106
  %26 = load ptr, ptr %7, align 8, !dbg !107
  %27 = load ptr, ptr %9, align 8, !dbg !108
  %28 = call i32 @clever(i32 noundef %24, i32 noundef %25, ptr noundef %26, ptr noundef %27), !dbg !109
  store i32 %28, ptr %10, align 4, !dbg !104
  ret i32 0, !dbg !110
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8, !9, !10}
!llvm.ident = !{!11}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 20.1.8", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/clr/use-def/assign2-tests/test11.c", directory: "/home/clr/use-def/build", checksumkind: CSK_MD5, checksum: "8cad89d6b244462572e3f6d5426a3de8")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 8, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 2}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{i32 1, !"ThinLTO", i32 0}
!10 = !{i32 1, !"EnableSplitLTOUnit", i32 1}
!11 = !{!"clang version 20.1.8"}
!12 = distinct !DISubprogram(name: "plus", scope: !13, file: !13, line: 1, type: !14, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!13 = !DIFile(filename: "assign2-tests/test11.c", directory: "/home/clr/use-def", checksumkind: CSK_MD5, checksum: "8cad89d6b244462572e3f6d5426a3de8")
!14 = !DISubroutineType(types: !15)
!15 = !{!16, !16, !16}
!16 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!17 = !{}
!18 = !DILocalVariable(name: "a", arg: 1, scope: !12, file: !13, line: 1, type: !16)
!19 = !DILocation(line: 1, column: 14, scope: !12)
!20 = !DILocalVariable(name: "b", arg: 2, scope: !12, file: !13, line: 1, type: !16)
!21 = !DILocation(line: 1, column: 21, scope: !12)
!22 = !DILocation(line: 2, column: 11, scope: !12)
!23 = !DILocation(line: 2, column: 13, scope: !12)
!24 = !DILocation(line: 2, column: 12, scope: !12)
!25 = !DILocation(line: 2, column: 4, scope: !12)
!26 = distinct !DISubprogram(name: "minus", scope: !13, file: !13, line: 5, type: !14, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!27 = !DILocalVariable(name: "a", arg: 1, scope: !26, file: !13, line: 5, type: !16)
!28 = !DILocation(line: 5, column: 15, scope: !26)
!29 = !DILocalVariable(name: "b", arg: 2, scope: !26, file: !13, line: 5, type: !16)
!30 = !DILocation(line: 5, column: 22, scope: !26)
!31 = !DILocation(line: 6, column: 11, scope: !26)
!32 = !DILocation(line: 6, column: 13, scope: !26)
!33 = !DILocation(line: 6, column: 12, scope: !26)
!34 = !DILocation(line: 6, column: 4, scope: !26)
!35 = distinct !DISubprogram(name: "foo", scope: !13, file: !13, line: 9, type: !36, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!36 = !DISubroutineType(types: !37)
!37 = !{!38, !16, !16, !38, !38}
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!39 = !DILocalVariable(name: "a", arg: 1, scope: !35, file: !13, line: 9, type: !16)
!40 = !DILocation(line: 9, column: 15, scope: !35)
!41 = !DILocalVariable(name: "b", arg: 2, scope: !35, file: !13, line: 9, type: !16)
!42 = !DILocation(line: 9, column: 22, scope: !35)
!43 = !DILocalVariable(name: "a_fptr", arg: 3, scope: !35, file: !13, line: 9, type: !38)
!44 = !DILocation(line: 9, column: 31, scope: !35)
!45 = !DILocalVariable(name: "b_fptr", arg: 4, scope: !35, file: !13, line: 9, type: !38)
!46 = !DILocation(line: 9, column: 55, scope: !35)
!47 = !DILocation(line: 10, column: 11, scope: !35)
!48 = !DILocation(line: 10, column: 4, scope: !35)
!49 = distinct !DISubprogram(name: "clever", scope: !13, file: !13, line: 13, type: !50, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!50 = !DISubroutineType(types: !51)
!51 = !{!16, !16, !16, !38, !38}
!52 = !DILocalVariable(name: "a", arg: 1, scope: !49, file: !13, line: 13, type: !16)
!53 = !DILocation(line: 13, column: 16, scope: !49)
!54 = !DILocalVariable(name: "b", arg: 2, scope: !49, file: !13, line: 13, type: !16)
!55 = !DILocation(line: 13, column: 23, scope: !49)
!56 = !DILocalVariable(name: "a_fptr", arg: 3, scope: !49, file: !13, line: 13, type: !38)
!57 = !DILocation(line: 13, column: 32, scope: !49)
!58 = !DILocalVariable(name: "b_fptr", arg: 4, scope: !49, file: !13, line: 13, type: !38)
!59 = !DILocation(line: 13, column: 56, scope: !49)
!60 = !DILocalVariable(name: "s_fptr", scope: !49, file: !13, line: 14, type: !38)
!61 = !DILocation(line: 14, column: 10, scope: !49)
!62 = !DILocation(line: 15, column: 17, scope: !49)
!63 = !DILocation(line: 15, column: 20, scope: !49)
!64 = !DILocation(line: 15, column: 23, scope: !49)
!65 = !DILocation(line: 15, column: 31, scope: !49)
!66 = !DILocation(line: 15, column: 13, scope: !49)
!67 = !DILocation(line: 15, column: 11, scope: !49)
!68 = !DILocation(line: 16, column: 11, scope: !49)
!69 = !DILocation(line: 16, column: 18, scope: !49)
!70 = !DILocation(line: 16, column: 21, scope: !49)
!71 = !DILocation(line: 16, column: 4, scope: !49)
!72 = distinct !DISubprogram(name: "moo", scope: !13, file: !13, line: 20, type: !73, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!73 = !DISubroutineType(types: !74)
!74 = !{!16, !75, !16, !16}
!75 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!76 = !DILocalVariable(name: "x", arg: 1, scope: !72, file: !13, line: 20, type: !75)
!77 = !DILocation(line: 20, column: 14, scope: !72)
!78 = !DILocalVariable(name: "op1", arg: 2, scope: !72, file: !13, line: 20, type: !16)
!79 = !DILocation(line: 20, column: 21, scope: !72)
!80 = !DILocalVariable(name: "op2", arg: 3, scope: !72, file: !13, line: 20, type: !16)
!81 = !DILocation(line: 20, column: 30, scope: !72)
!82 = !DILocalVariable(name: "a_fptr", scope: !72, file: !13, line: 21, type: !38)
!83 = !DILocation(line: 21, column: 11, scope: !72)
!84 = !DILocalVariable(name: "s_fptr", scope: !72, file: !13, line: 22, type: !38)
!85 = !DILocation(line: 22, column: 11, scope: !72)
!86 = !DILocalVariable(name: "t_fptr", scope: !72, file: !13, line: 23, type: !38)
!87 = !DILocation(line: 23, column: 11, scope: !72)
!88 = !DILocation(line: 25, column: 9, scope: !89)
!89 = distinct !DILexicalBlock(scope: !72, file: !13, line: 25, column: 9)
!90 = !DILocation(line: 25, column: 11, scope: !89)
!91 = !DILocation(line: 26, column: 17, scope: !92)
!92 = distinct !DILexicalBlock(scope: !89, file: !13, line: 25, column: 19)
!93 = !DILocation(line: 26, column: 15, scope: !92)
!94 = !DILocation(line: 27, column: 5, scope: !92)
!95 = !DILocation(line: 28, column: 14, scope: !96)
!96 = distinct !DILexicalBlock(scope: !89, file: !13, line: 28, column: 14)
!97 = !DILocation(line: 28, column: 16, scope: !96)
!98 = !DILocation(line: 29, column: 17, scope: !99)
!99 = distinct !DILexicalBlock(scope: !96, file: !13, line: 28, column: 24)
!100 = !DILocation(line: 29, column: 15, scope: !99)
!101 = !DILocation(line: 30, column: 5, scope: !99)
!102 = !DILocalVariable(name: "result", scope: !72, file: !13, line: 32, type: !103)
!103 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!104 = !DILocation(line: 32, column: 14, scope: !72)
!105 = !DILocation(line: 32, column: 30, scope: !72)
!106 = !DILocation(line: 32, column: 35, scope: !72)
!107 = !DILocation(line: 32, column: 40, scope: !72)
!108 = !DILocation(line: 32, column: 48, scope: !72)
!109 = !DILocation(line: 32, column: 23, scope: !72)
!110 = !DILocation(line: 33, column: 5, scope: !72)

^0 = module: (path: "test11.bc", hash: (0, 0, 0, 0, 0))
^1 = gv: (name: "foo", summaries: (function: (module: ^0, flags: (linkage: external, visibility: default, notEligibleToImport: 1, live: 0, dsoLocal: 1, canAutoHide: 0, importType: definition), insts: 10, funcFlags: (readNone: 0, readOnly: 0, noRecurse: 0, returnDoesNotAlias: 0, noInline: 1, alwaysInline: 0, noUnwind: 1, mayThrow: 0, hasUnknownCall: 0, mustBeUnreachable: 0)))) ; guid = 6699318081062747564
^2 = gv: (name: "moo", summaries: (function: (module: ^0, flags: (linkage: external, visibility: default, notEligibleToImport: 1, live: 0, dsoLocal: 1, canAutoHide: 0, importType: definition), insts: 35, funcFlags: (readNone: 0, readOnly: 0, noRecurse: 0, returnDoesNotAlias: 0, noInline: 1, alwaysInline: 0, noUnwind: 1, mayThrow: 0, hasUnknownCall: 0, mustBeUnreachable: 0), calls: ((callee: ^5)), refs: (^4, ^3)))) ; guid = 7827552258766328247
^3 = gv: (name: "minus", summaries: (function: (module: ^0, flags: (linkage: external, visibility: default, notEligibleToImport: 1, live: 0, dsoLocal: 1, canAutoHide: 0, importType: definition), insts: 8, funcFlags: (readNone: 0, readOnly: 0, noRecurse: 0, returnDoesNotAlias: 0, noInline: 1, alwaysInline: 0, noUnwind: 1, mayThrow: 0, hasUnknownCall: 0, mustBeUnreachable: 0)))) ; guid = 8567377541225955034
^4 = gv: (name: "plus", summaries: (function: (module: ^0, flags: (linkage: external, visibility: default, notEligibleToImport: 1, live: 0, dsoLocal: 1, canAutoHide: 0, importType: definition), insts: 8, funcFlags: (readNone: 0, readOnly: 0, noRecurse: 0, returnDoesNotAlias: 0, noInline: 1, alwaysInline: 0, noUnwind: 1, mayThrow: 0, hasUnknownCall: 0, mustBeUnreachable: 0)))) ; guid = 10629072617527366103
^5 = gv: (name: "clever", summaries: (function: (module: ^0, flags: (linkage: external, visibility: default, notEligibleToImport: 1, live: 0, dsoLocal: 1, canAutoHide: 0, importType: definition), insts: 20, funcFlags: (readNone: 0, readOnly: 0, noRecurse: 0, returnDoesNotAlias: 0, noInline: 1, alwaysInline: 0, noUnwind: 1, mayThrow: 0, hasUnknownCall: 1, mustBeUnreachable: 0), calls: ((callee: ^1))))) ; guid = 11358678916020220504
^6 = flags: 8
^7 = blockcount: 0