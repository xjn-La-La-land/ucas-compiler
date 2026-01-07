; ModuleID = './test19.bc'
source_filename = "/home/clr/use-def/assign2-tests/test19.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-generic-linux"

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @plus(i32 noundef %0, i32 noundef %1) #0 !dbg !12 {
    #dbg_value(i32 %0, !18, !DIExpression(), !19)
    #dbg_value(i32 %1, !20, !DIExpression(), !19)
  %3 = add nsw i32 %0, %1, !dbg !21
  ret i32 %3, !dbg !22
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @minus(i32 noundef %0, i32 noundef %1) #0 !dbg !23 {
    #dbg_value(i32 %0, !24, !DIExpression(), !25)
    #dbg_value(i32 %1, !26, !DIExpression(), !25)
  %3 = sub nsw i32 %0, %1, !dbg !27
  ret i32 %3, !dbg !28
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @foo(i32 noundef %0, i32 noundef %1, ptr noundef %2, ptr noundef %3) #0 !dbg !29 {
    #dbg_value(i32 %0, !33, !DIExpression(), !34)
    #dbg_value(i32 %1, !35, !DIExpression(), !34)
    #dbg_value(ptr %2, !36, !DIExpression(), !34)
    #dbg_value(ptr %3, !37, !DIExpression(), !34)
  ret ptr %2, !dbg !38
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @clever(i32 noundef %0, i32 noundef %1, ptr noundef %2, ptr noundef %3) #0 !dbg !39 {
    #dbg_value(i32 %0, !40, !DIExpression(), !41)
    #dbg_value(i32 %1, !42, !DIExpression(), !41)
    #dbg_value(ptr %2, !43, !DIExpression(), !41)
    #dbg_value(ptr %3, !44, !DIExpression(), !41)
  %5 = call ptr @foo(i32 noundef %0, i32 noundef %1, ptr noundef %2, ptr noundef %3), !dbg !45
  ret ptr %5, !dbg !46
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @clever1(ptr noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3, ptr noundef %4) #0 !dbg !47 {
    #dbg_value(ptr %0, !51, !DIExpression(), !52)
    #dbg_value(i32 %1, !53, !DIExpression(), !52)
    #dbg_value(i32 %2, !54, !DIExpression(), !52)
    #dbg_value(ptr %3, !55, !DIExpression(), !52)
    #dbg_value(ptr %4, !56, !DIExpression(), !52)
  %6 = call ptr %0(i32 noundef %1, i32 noundef %2, ptr noundef %4, ptr noundef %3), !dbg !57
    #dbg_value(ptr %6, !58, !DIExpression(), !52)
  %7 = icmp eq i32 %1, 43, !dbg !59
  br i1 %7, label %8, label %9, !dbg !59

8:                                                ; preds = %5
    #dbg_value(ptr @plus, !58, !DIExpression(), !52)
    #dbg_value(ptr @minus, !55, !DIExpression(), !52)
  br label %9, !dbg !61

9:                                                ; preds = %8, %5
  %.01 = phi ptr [ @minus, %8 ], [ %3, %5 ]
  %.0 = phi ptr [ @plus, %8 ], [ %6, %5 ], !dbg !52
    #dbg_value(ptr %.0, !58, !DIExpression(), !52)
    #dbg_value(ptr %.01, !55, !DIExpression(), !52)
  %10 = call ptr %0(i32 noundef %1, i32 noundef %2, ptr noundef %.0, ptr noundef %.01), !dbg !63
  ret ptr %10, !dbg !64
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @moo(i8 noundef signext %0, i32 noundef %1, i32 noundef %2) #0 !dbg !65 {
    #dbg_value(i8 %0, !69, !DIExpression(), !70)
    #dbg_value(i32 %1, !71, !DIExpression(), !70)
    #dbg_value(i32 %2, !72, !DIExpression(), !70)
    #dbg_value(ptr @plus, !73, !DIExpression(), !70)
    #dbg_value(ptr @minus, !74, !DIExpression(), !70)
    #dbg_value(ptr @clever, !75, !DIExpression(), !70)
  %4 = sext i8 %0 to i32, !dbg !76
  %5 = icmp eq i32 %4, 43, !dbg !78
  br i1 %5, label %6, label %7, !dbg !78

6:                                                ; preds = %3
    #dbg_value(ptr @foo, !75, !DIExpression(), !70)
  br label %7, !dbg !79

7:                                                ; preds = %6, %3
  %.0 = phi ptr [ @foo, %6 ], [ @clever, %3 ], !dbg !70
    #dbg_value(ptr %.0, !75, !DIExpression(), !70)
  %8 = call ptr @clever1(ptr noundef %.0, i32 noundef %1, i32 noundef %2, ptr noundef @minus, ptr noundef @plus), !dbg !81
    #dbg_value(ptr %8, !82, !DIExpression(), !70)
  %9 = call i32 %8(i32 noundef %1, i32 noundef %2), !dbg !83
  ret i32 0, !dbg !84
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8, !9, !10}
!llvm.ident = !{!11}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 20.1.8", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/clr/use-def/assign2-tests/test19.c", directory: "/home/clr/use-def/build", checksumkind: CSK_MD5, checksum: "184e045b7b77c4affc8819528a57be13")
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
!12 = distinct !DISubprogram(name: "plus", scope: !13, file: !13, line: 2, type: !14, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!13 = !DIFile(filename: "assign2-tests/test19.c", directory: "/home/clr/use-def", checksumkind: CSK_MD5, checksum: "184e045b7b77c4affc8819528a57be13")
!14 = !DISubroutineType(types: !15)
!15 = !{!16, !16, !16}
!16 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!17 = !{}
!18 = !DILocalVariable(name: "a", arg: 1, scope: !12, file: !13, line: 2, type: !16)
!19 = !DILocation(line: 0, scope: !12)
!20 = !DILocalVariable(name: "b", arg: 2, scope: !12, file: !13, line: 2, type: !16)
!21 = !DILocation(line: 3, column: 12, scope: !12)
!22 = !DILocation(line: 3, column: 4, scope: !12)
!23 = distinct !DISubprogram(name: "minus", scope: !13, file: !13, line: 6, type: !14, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!24 = !DILocalVariable(name: "a", arg: 1, scope: !23, file: !13, line: 6, type: !16)
!25 = !DILocation(line: 0, scope: !23)
!26 = !DILocalVariable(name: "b", arg: 2, scope: !23, file: !13, line: 6, type: !16)
!27 = !DILocation(line: 7, column: 12, scope: !23)
!28 = !DILocation(line: 7, column: 4, scope: !23)
!29 = distinct !DISubprogram(name: "foo", scope: !13, file: !13, line: 10, type: !30, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!30 = !DISubroutineType(types: !31)
!31 = !{!32, !16, !16, !32, !32}
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!33 = !DILocalVariable(name: "a", arg: 1, scope: !29, file: !13, line: 10, type: !16)
!34 = !DILocation(line: 0, scope: !29)
!35 = !DILocalVariable(name: "b", arg: 2, scope: !29, file: !13, line: 10, type: !16)
!36 = !DILocalVariable(name: "a_fptr", arg: 3, scope: !29, file: !13, line: 10, type: !32)
!37 = !DILocalVariable(name: "b_fptr", arg: 4, scope: !29, file: !13, line: 10, type: !32)
!38 = !DILocation(line: 11, column: 4, scope: !29)
!39 = distinct !DISubprogram(name: "clever", scope: !13, file: !13, line: 13, type: !30, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!40 = !DILocalVariable(name: "a", arg: 1, scope: !39, file: !13, line: 13, type: !16)
!41 = !DILocation(line: 0, scope: !39)
!42 = !DILocalVariable(name: "b", arg: 2, scope: !39, file: !13, line: 13, type: !16)
!43 = !DILocalVariable(name: "a_fptr", arg: 3, scope: !39, file: !13, line: 13, type: !32)
!44 = !DILocalVariable(name: "b_fptr", arg: 4, scope: !39, file: !13, line: 13, type: !32)
!45 = !DILocation(line: 14, column: 11, scope: !39)
!46 = !DILocation(line: 14, column: 4, scope: !39)
!47 = distinct !DISubprogram(name: "clever1", scope: !13, file: !13, line: 17, type: !48, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!48 = !DISubroutineType(types: !49)
!49 = !{!32, !50, !16, !16, !32, !32}
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!51 = !DILocalVariable(name: "goo_ptr", arg: 1, scope: !47, file: !13, line: 17, type: !50)
!52 = !DILocation(line: 0, scope: !47)
!53 = !DILocalVariable(name: "a", arg: 2, scope: !47, file: !13, line: 17, type: !16)
!54 = !DILocalVariable(name: "b", arg: 3, scope: !47, file: !13, line: 17, type: !16)
!55 = !DILocalVariable(name: "a_fptr", arg: 4, scope: !47, file: !13, line: 17, type: !32)
!56 = !DILocalVariable(name: "b_fptr", arg: 5, scope: !47, file: !13, line: 17, type: !32)
!57 = !DILocation(line: 18, column: 30, scope: !47)
!58 = !DILocalVariable(name: "f_fptr", scope: !47, file: !13, line: 18, type: !32)
!59 = !DILocation(line: 19, column: 10, scope: !60)
!60 = distinct !DILexicalBlock(scope: !47, file: !13, line: 19, column: 8)
!61 = !DILocation(line: 23, column: 4, scope: !62)
!62 = distinct !DILexicalBlock(scope: !60, file: !13, line: 20, column: 4)
!63 = !DILocation(line: 24, column: 11, scope: !47)
!64 = !DILocation(line: 24, column: 4, scope: !47)
!65 = distinct !DISubprogram(name: "moo", scope: !13, file: !13, line: 26, type: !66, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!66 = !DISubroutineType(types: !67)
!67 = !{!16, !68, !16, !16}
!68 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!69 = !DILocalVariable(name: "x", arg: 1, scope: !65, file: !13, line: 26, type: !68)
!70 = !DILocation(line: 0, scope: !65)
!71 = !DILocalVariable(name: "op1", arg: 2, scope: !65, file: !13, line: 26, type: !16)
!72 = !DILocalVariable(name: "op2", arg: 3, scope: !65, file: !13, line: 26, type: !16)
!73 = !DILocalVariable(name: "a_fptr", scope: !65, file: !13, line: 27, type: !32)
!74 = !DILocalVariable(name: "s_fptr", scope: !65, file: !13, line: 28, type: !32)
!75 = !DILocalVariable(name: "goo_ptr", scope: !65, file: !13, line: 29, type: !50)
!76 = !DILocation(line: 31, column: 9, scope: !77)
!77 = distinct !DILexicalBlock(scope: !65, file: !13, line: 31, column: 9)
!78 = !DILocation(line: 31, column: 11, scope: !77)
!79 = !DILocation(line: 34, column: 5, scope: !80)
!80 = distinct !DILexicalBlock(scope: !77, file: !13, line: 32, column: 5)
!81 = !DILocation(line: 36, column: 31, scope: !65)
!82 = !DILocalVariable(name: "t_fptr", scope: !65, file: !13, line: 36, type: !32)
!83 = !DILocation(line: 37, column: 5, scope: !65)
!84 = !DILocation(line: 39, column: 5, scope: !65)