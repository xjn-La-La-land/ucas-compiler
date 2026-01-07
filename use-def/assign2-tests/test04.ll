; ModuleID = 'test04.bc'
source_filename = "/home/clr/use-def/assign2-tests/test04.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-generic-linux"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @plus(i32 noundef %0, i32 noundef %1) #0 !dbg !14 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
    #dbg_declare(ptr %3, !20, !DIExpression(), !21)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !22, !DIExpression(), !23)
  %5 = load i32, ptr %3, align 4, !dbg !24
  %6 = load i32, ptr %4, align 4, !dbg !25
  %7 = add nsw i32 %5, %6, !dbg !26
  ret i32 %7, !dbg !27
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @minus(i32 noundef %0, i32 noundef %1) #0 !dbg !28 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
    #dbg_declare(ptr %3, !29, !DIExpression(), !30)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !31, !DIExpression(), !32)
  %5 = load i32, ptr %3, align 4, !dbg !33
  %6 = load i32, ptr %4, align 4, !dbg !34
  %7 = sub nsw i32 %5, %6, !dbg !35
  ret i32 %7, !dbg !36
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo(i32 noundef %0, i32 noundef %1, ptr noundef %2) #0 !dbg !37 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  store i32 %0, ptr %4, align 4
    #dbg_declare(ptr %4, !41, !DIExpression(), !42)
  store i32 %1, ptr %5, align 4
    #dbg_declare(ptr %5, !43, !DIExpression(), !44)
  store ptr %2, ptr %6, align 8
    #dbg_declare(ptr %6, !45, !DIExpression(), !46)
  %7 = load ptr, ptr %6, align 8, !dbg !47
  %8 = load i32, ptr %4, align 4, !dbg !48
  %9 = load i32, ptr %5, align 4, !dbg !49
  %10 = call i32 %7(i32 noundef %8, i32 noundef %9), !dbg !47
  ret i32 %10, !dbg !50
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @clever(i32 noundef %0) #0 !dbg !51 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
    #dbg_declare(ptr %2, !54, !DIExpression(), !55)
    #dbg_declare(ptr %3, !56, !DIExpression(), !57)
  store ptr @plus, ptr %3, align 8, !dbg !57
    #dbg_declare(ptr %4, !58, !DIExpression(), !59)
  store ptr @minus, ptr %4, align 8, !dbg !59
    #dbg_declare(ptr %5, !60, !DIExpression(), !61)
  store ptr null, ptr %5, align 8, !dbg !61
    #dbg_declare(ptr %6, !62, !DIExpression(), !63)
  store ptr null, ptr %6, align 8, !dbg !63
    #dbg_declare(ptr %7, !64, !DIExpression(), !65)
  store ptr null, ptr %7, align 8, !dbg !65
    #dbg_declare(ptr %8, !66, !DIExpression(), !68)
  store ptr @foo, ptr %8, align 8, !dbg !68
    #dbg_declare(ptr %9, !69, !DIExpression(), !70)
  store i32 1, ptr %9, align 4, !dbg !70
    #dbg_declare(ptr %10, !71, !DIExpression(), !72)
  store i32 2, ptr %10, align 4, !dbg !72
  %12 = load i32, ptr %2, align 4, !dbg !73
  %13 = icmp sge i32 %12, 4, !dbg !75
  br i1 %13, label %14, label %16, !dbg !75

14:                                               ; preds = %1
  %15 = load ptr, ptr %4, align 8, !dbg !76
  store ptr %15, ptr %5, align 8, !dbg !78
  br label %16, !dbg !79

16:                                               ; preds = %14, %1
  %17 = load ptr, ptr %8, align 8, !dbg !80
  %18 = load i32, ptr %9, align 4, !dbg !81
  %19 = load i32, ptr %10, align 4, !dbg !82
  %20 = load ptr, ptr %5, align 8, !dbg !83
  %21 = call i32 %17(i32 noundef %18, i32 noundef %19, ptr noundef %20), !dbg !80
  %22 = load i32, ptr %2, align 4, !dbg !84
  %23 = icmp sge i32 %22, 5, !dbg !86
  br i1 %23, label %24, label %27, !dbg !86

24:                                               ; preds = %16
  %25 = load ptr, ptr %3, align 8, !dbg !87
  store ptr %25, ptr %5, align 8, !dbg !89
  %26 = load ptr, ptr %5, align 8, !dbg !90
  store ptr %26, ptr %6, align 8, !dbg !91
  br label %27, !dbg !92

27:                                               ; preds = %24, %16
  %28 = load ptr, ptr %5, align 8, !dbg !93
  %29 = icmp ne ptr %28, null, !dbg !95
  br i1 %29, label %30, label %36, !dbg !95

30:                                               ; preds = %27
    #dbg_declare(ptr %11, !96, !DIExpression(), !99)
  %31 = load ptr, ptr %8, align 8, !dbg !100
  %32 = load i32, ptr %9, align 4, !dbg !101
  %33 = load i32, ptr %10, align 4, !dbg !102
  %34 = load ptr, ptr %6, align 8, !dbg !103
  %35 = call i32 %31(i32 noundef %32, i32 noundef %33, ptr noundef %34), !dbg !100
  store i32 %35, ptr %11, align 4, !dbg !99
  br label %36, !dbg !104

36:                                               ; preds = %30, %27
  ret i32 0, !dbg !105
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!4, !5, !6, !7, !8, !9, !10, !11, !12}
!llvm.ident = !{!13}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 20.1.8", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/clr/use-def/assign2-tests/test04.c", directory: "/home/clr/use-def/build", checksumkind: CSK_MD5, checksum: "23a2ea5b825d3f908265c6f7c56aeac4")
!2 = !{!3}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!4 = !{i32 7, !"Dwarf Version", i32 5}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = !{i32 8, !"PIC Level", i32 2}
!8 = !{i32 7, !"PIE Level", i32 2}
!9 = !{i32 7, !"uwtable", i32 2}
!10 = !{i32 7, !"frame-pointer", i32 2}
!11 = !{i32 1, !"ThinLTO", i32 0}
!12 = !{i32 1, !"EnableSplitLTOUnit", i32 1}
!13 = !{!"clang version 20.1.8"}
!14 = distinct !DISubprogram(name: "plus", scope: !15, file: !15, line: 2, type: !16, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!15 = !DIFile(filename: "assign2-tests/test04.c", directory: "/home/clr/use-def", checksumkind: CSK_MD5, checksum: "23a2ea5b825d3f908265c6f7c56aeac4")
!16 = !DISubroutineType(types: !17)
!17 = !{!18, !18, !18}
!18 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!19 = !{}
!20 = !DILocalVariable(name: "a", arg: 1, scope: !14, file: !15, line: 2, type: !18)
!21 = !DILocation(line: 2, column: 14, scope: !14)
!22 = !DILocalVariable(name: "b", arg: 2, scope: !14, file: !15, line: 2, type: !18)
!23 = !DILocation(line: 2, column: 21, scope: !14)
!24 = !DILocation(line: 3, column: 11, scope: !14)
!25 = !DILocation(line: 3, column: 13, scope: !14)
!26 = !DILocation(line: 3, column: 12, scope: !14)
!27 = !DILocation(line: 3, column: 4, scope: !14)
!28 = distinct !DISubprogram(name: "minus", scope: !15, file: !15, line: 6, type: !16, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!29 = !DILocalVariable(name: "a", arg: 1, scope: !28, file: !15, line: 6, type: !18)
!30 = !DILocation(line: 6, column: 15, scope: !28)
!31 = !DILocalVariable(name: "b", arg: 2, scope: !28, file: !15, line: 6, type: !18)
!32 = !DILocation(line: 6, column: 22, scope: !28)
!33 = !DILocation(line: 7, column: 11, scope: !28)
!34 = !DILocation(line: 7, column: 13, scope: !28)
!35 = !DILocation(line: 7, column: 12, scope: !28)
!36 = !DILocation(line: 7, column: 4, scope: !28)
!37 = distinct !DISubprogram(name: "foo", scope: !15, file: !15, line: 9, type: !38, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!38 = !DISubroutineType(types: !39)
!39 = !{!18, !18, !18, !40}
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!41 = !DILocalVariable(name: "a", arg: 1, scope: !37, file: !15, line: 9, type: !18)
!42 = !DILocation(line: 9, column: 13, scope: !37)
!43 = !DILocalVariable(name: "b", arg: 2, scope: !37, file: !15, line: 9, type: !18)
!44 = !DILocation(line: 9, column: 20, scope: !37)
!45 = !DILocalVariable(name: "a_fptr", arg: 3, scope: !37, file: !15, line: 9, type: !40)
!46 = !DILocation(line: 9, column: 29, scope: !37)
!47 = !DILocation(line: 10, column: 12, scope: !37)
!48 = !DILocation(line: 10, column: 19, scope: !37)
!49 = !DILocation(line: 10, column: 22, scope: !37)
!50 = !DILocation(line: 10, column: 5, scope: !37)
!51 = distinct !DISubprogram(name: "clever", scope: !15, file: !15, line: 13, type: !52, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!52 = !DISubroutineType(types: !53)
!53 = !{!18, !18}
!54 = !DILocalVariable(name: "x", arg: 1, scope: !51, file: !15, line: 13, type: !18)
!55 = !DILocation(line: 13, column: 16, scope: !51)
!56 = !DILocalVariable(name: "a_fptr", scope: !51, file: !15, line: 14, type: !40)
!57 = !DILocation(line: 14, column: 11, scope: !51)
!58 = !DILocalVariable(name: "s_fptr", scope: !51, file: !15, line: 15, type: !40)
!59 = !DILocation(line: 15, column: 11, scope: !51)
!60 = !DILocalVariable(name: "t_fptr", scope: !51, file: !15, line: 16, type: !40)
!61 = !DILocation(line: 16, column: 11, scope: !51)
!62 = !DILocalVariable(name: "q_fptr", scope: !51, file: !15, line: 17, type: !40)
!63 = !DILocation(line: 17, column: 11, scope: !51)
!64 = !DILocalVariable(name: "r_fptr", scope: !51, file: !15, line: 18, type: !40)
!65 = !DILocation(line: 18, column: 11, scope: !51)
!66 = !DILocalVariable(name: "af_ptr", scope: !51, file: !15, line: 19, type: !67)
!67 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!68 = !DILocation(line: 19, column: 11, scope: !51)
!69 = !DILocalVariable(name: "op1", scope: !51, file: !15, line: 21, type: !18)
!70 = !DILocation(line: 21, column: 9, scope: !51)
!71 = !DILocalVariable(name: "op2", scope: !51, file: !15, line: 21, type: !18)
!72 = !DILocation(line: 21, column: 16, scope: !51)
!73 = !DILocation(line: 23, column: 9, scope: !74)
!74 = distinct !DILexicalBlock(scope: !51, file: !15, line: 23, column: 9)
!75 = !DILocation(line: 23, column: 11, scope: !74)
!76 = !DILocation(line: 24, column: 17, scope: !77)
!77 = distinct !DILexicalBlock(scope: !74, file: !15, line: 23, column: 17)
!78 = !DILocation(line: 24, column: 15, scope: !77)
!79 = !DILocation(line: 25, column: 5, scope: !77)
!80 = !DILocation(line: 26, column: 5, scope: !51)
!81 = !DILocation(line: 26, column: 12, scope: !51)
!82 = !DILocation(line: 26, column: 16, scope: !51)
!83 = !DILocation(line: 26, column: 20, scope: !51)
!84 = !DILocation(line: 27, column: 9, scope: !85)
!85 = distinct !DILexicalBlock(scope: !51, file: !15, line: 27, column: 9)
!86 = !DILocation(line: 27, column: 11, scope: !85)
!87 = !DILocation(line: 28, column: 17, scope: !88)
!88 = distinct !DILexicalBlock(scope: !85, file: !15, line: 27, column: 17)
!89 = !DILocation(line: 28, column: 15, scope: !88)
!90 = !DILocation(line: 29, column: 17, scope: !88)
!91 = !DILocation(line: 29, column: 15, scope: !88)
!92 = !DILocation(line: 30, column: 5, scope: !88)
!93 = !DILocation(line: 32, column: 9, scope: !94)
!94 = distinct !DILexicalBlock(scope: !51, file: !15, line: 32, column: 9)
!95 = !DILocation(line: 32, column: 16, scope: !94)
!96 = !DILocalVariable(name: "result", scope: !97, file: !15, line: 33, type: !98)
!97 = distinct !DILexicalBlock(scope: !94, file: !15, line: 32, column: 25)
!98 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!99 = !DILocation(line: 33, column: 17, scope: !97)
!100 = !DILocation(line: 33, column: 26, scope: !97)
!101 = !DILocation(line: 33, column: 33, scope: !97)
!102 = !DILocation(line: 33, column: 37, scope: !97)
!103 = !DILocation(line: 33, column: 41, scope: !97)
!104 = !DILocation(line: 34, column: 5, scope: !97)
!105 = !DILocation(line: 35, column: 4, scope: !51)

^0 = module: (path: "test04.bc", hash: (0, 0, 0, 0, 0))
^1 = gv: (name: "foo", summaries: (function: (module: ^0, flags: (linkage: external, visibility: default, notEligibleToImport: 1, live: 0, dsoLocal: 1, canAutoHide: 0, importType: definition), insts: 11, funcFlags: (readNone: 0, readOnly: 0, noRecurse: 0, returnDoesNotAlias: 0, noInline: 1, alwaysInline: 0, noUnwind: 1, mayThrow: 0, hasUnknownCall: 1, mustBeUnreachable: 0)))) ; guid = 6699318081062747564
^2 = gv: (name: "minus", summaries: (function: (module: ^0, flags: (linkage: external, visibility: default, notEligibleToImport: 1, live: 0, dsoLocal: 1, canAutoHide: 0, importType: definition), insts: 8, funcFlags: (readNone: 0, readOnly: 0, noRecurse: 0, returnDoesNotAlias: 0, noInline: 1, alwaysInline: 0, noUnwind: 1, mayThrow: 0, hasUnknownCall: 0, mustBeUnreachable: 0)))) ; guid = 8567377541225955034
^3 = gv: (name: "plus", summaries: (function: (module: ^0, flags: (linkage: external, visibility: default, notEligibleToImport: 1, live: 0, dsoLocal: 1, canAutoHide: 0, importType: definition), insts: 8, funcFlags: (readNone: 0, readOnly: 0, noRecurse: 0, returnDoesNotAlias: 0, noInline: 1, alwaysInline: 0, noUnwind: 1, mayThrow: 0, hasUnknownCall: 0, mustBeUnreachable: 0)))) ; guid = 10629072617527366103
^4 = gv: (name: "clever", summaries: (function: (module: ^0, flags: (linkage: external, visibility: default, notEligibleToImport: 1, live: 0, dsoLocal: 1, canAutoHide: 0, importType: definition), insts: 49, funcFlags: (readNone: 0, readOnly: 0, noRecurse: 0, returnDoesNotAlias: 0, noInline: 1, alwaysInline: 0, noUnwind: 1, mayThrow: 0, hasUnknownCall: 1, mustBeUnreachable: 0), refs: (^3, ^2, ^1)))) ; guid = 11358678916020220504
^5 = flags: 8
^6 = blockcount: 0