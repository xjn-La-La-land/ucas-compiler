; ModuleID = './test11.bc'
source_filename = "/home/clr/use-def/assign2-tests/test11.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-generic-linux"

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @plus(i32 noundef %0, i32 noundef %1) #0 !dbg !18 {
    #dbg_value(i32 %0, !21, !DIExpression(), !22)
    #dbg_value(i32 %1, !23, !DIExpression(), !22)
  %3 = add nsw i32 %0, %1, !dbg !24
  ret i32 %3, !dbg !25
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @minus(i32 noundef %0, i32 noundef %1) #0 !dbg !26 {
    #dbg_value(i32 %0, !27, !DIExpression(), !28)
    #dbg_value(i32 %1, !29, !DIExpression(), !28)
  %3 = sub nsw i32 %0, %1, !dbg !30
  ret i32 %3, !dbg !31
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @clever(i32 noundef %0, i32 noundef %1, ptr noundef %2) #0 !dbg !32 {
    #dbg_value(i32 %0, !35, !DIExpression(), !36)
    #dbg_value(i32 %1, !37, !DIExpression(), !36)
    #dbg_value(ptr %2, !38, !DIExpression(), !36)
  %4 = call i32 %2(i32 noundef %0, i32 noundef %1), !dbg !39
  ret i32 %4, !dbg !40
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @moo(i8 noundef signext %0, i32 noundef %1, i32 noundef %2) #0 !dbg !41 {
    #dbg_value(i8 %0, !45, !DIExpression(), !46)
    #dbg_value(i32 %1, !47, !DIExpression(), !46)
    #dbg_value(i32 %2, !48, !DIExpression(), !46)
    #dbg_value(ptr @plus, !49, !DIExpression(), !46)
    #dbg_value(ptr @minus, !50, !DIExpression(), !46)
  %4 = call noalias ptr @malloc(i64 noundef 8) #2, !dbg !51
    #dbg_value(ptr %4, !52, !DIExpression(), !46)
  %5 = sext i8 %0 to i32, !dbg !53
  %6 = icmp eq i32 %5, 43, !dbg !55
  br i1 %6, label %7, label %8, !dbg !55

7:                                                ; preds = %3
  store ptr @plus, ptr %4, align 8, !dbg !56
  br label %8, !dbg !58

8:                                                ; preds = %7, %3
  %9 = sext i8 %0 to i32, !dbg !59
  %10 = icmp eq i32 %9, 45, !dbg !61
  br i1 %10, label %11, label %12, !dbg !61

11:                                               ; preds = %8
  store ptr @minus, ptr %4, align 8, !dbg !62
  br label %12, !dbg !64

12:                                               ; preds = %11, %8
  %13 = load ptr, ptr %4, align 8, !dbg !65
  %14 = call i32 @clever(i32 noundef %1, i32 noundef %2, ptr noundef %13), !dbg !66
    #dbg_value(i32 %14, !67, !DIExpression(), !46)
  ret i32 0, !dbg !69
}

; Function Attrs: nounwind allocsize(0)
declare noalias ptr @malloc(i64 noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!8, !9, !10, !11, !12, !13, !14, !15, !16}
!llvm.ident = !{!17}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 20.1.8", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/clr/use-def/assign2-tests/test11.c", directory: "/home/clr/use-def/build", checksumkind: CSK_MD5, checksum: "6a224bc6db4780205a267585f7b6f058")
!2 = !{!3}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!5 = !DISubroutineType(types: !6)
!6 = !{!7, !7, !7}
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{i32 7, !"Dwarf Version", i32 5}
!9 = !{i32 2, !"Debug Info Version", i32 3}
!10 = !{i32 1, !"wchar_size", i32 4}
!11 = !{i32 8, !"PIC Level", i32 2}
!12 = !{i32 7, !"PIE Level", i32 2}
!13 = !{i32 7, !"uwtable", i32 2}
!14 = !{i32 7, !"frame-pointer", i32 2}
!15 = !{i32 1, !"ThinLTO", i32 0}
!16 = !{i32 1, !"EnableSplitLTOUnit", i32 1}
!17 = !{!"clang version 20.1.8"}
!18 = distinct !DISubprogram(name: "plus", scope: !19, file: !19, line: 2, type: !5, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !20)
!19 = !DIFile(filename: "assign2-tests/test11.c", directory: "/home/clr/use-def", checksumkind: CSK_MD5, checksum: "6a224bc6db4780205a267585f7b6f058")
!20 = !{}
!21 = !DILocalVariable(name: "a", arg: 1, scope: !18, file: !19, line: 2, type: !7)
!22 = !DILocation(line: 0, scope: !18)
!23 = !DILocalVariable(name: "b", arg: 2, scope: !18, file: !19, line: 2, type: !7)
!24 = !DILocation(line: 3, column: 12, scope: !18)
!25 = !DILocation(line: 3, column: 4, scope: !18)
!26 = distinct !DISubprogram(name: "minus", scope: !19, file: !19, line: 6, type: !5, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !20)
!27 = !DILocalVariable(name: "a", arg: 1, scope: !26, file: !19, line: 6, type: !7)
!28 = !DILocation(line: 0, scope: !26)
!29 = !DILocalVariable(name: "b", arg: 2, scope: !26, file: !19, line: 6, type: !7)
!30 = !DILocation(line: 7, column: 12, scope: !26)
!31 = !DILocation(line: 7, column: 4, scope: !26)
!32 = distinct !DISubprogram(name: "clever", scope: !19, file: !19, line: 10, type: !33, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !20)
!33 = !DISubroutineType(types: !34)
!34 = !{!7, !7, !7, !4}
!35 = !DILocalVariable(name: "a", arg: 1, scope: !32, file: !19, line: 10, type: !7)
!36 = !DILocation(line: 0, scope: !32)
!37 = !DILocalVariable(name: "b", arg: 2, scope: !32, file: !19, line: 10, type: !7)
!38 = !DILocalVariable(name: "a_fptr", arg: 3, scope: !32, file: !19, line: 10, type: !4)
!39 = !DILocation(line: 11, column: 12, scope: !32)
!40 = !DILocation(line: 11, column: 5, scope: !32)
!41 = distinct !DISubprogram(name: "moo", scope: !19, file: !19, line: 15, type: !42, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !20)
!42 = !DISubroutineType(types: !43)
!43 = !{!7, !44, !7, !7}
!44 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!45 = !DILocalVariable(name: "x", arg: 1, scope: !41, file: !19, line: 15, type: !44)
!46 = !DILocation(line: 0, scope: !41)
!47 = !DILocalVariable(name: "op1", arg: 2, scope: !41, file: !19, line: 15, type: !7)
!48 = !DILocalVariable(name: "op2", arg: 3, scope: !41, file: !19, line: 15, type: !7)
!49 = !DILocalVariable(name: "a_fptr", scope: !41, file: !19, line: 16, type: !4)
!50 = !DILocalVariable(name: "s_fptr", scope: !41, file: !19, line: 17, type: !4)
!51 = !DILocation(line: 18, column: 52, scope: !41)
!52 = !DILocalVariable(name: "t_fptr", scope: !41, file: !19, line: 18, type: !3)
!53 = !DILocation(line: 20, column: 9, scope: !54)
!54 = distinct !DILexicalBlock(scope: !41, file: !19, line: 20, column: 9)
!55 = !DILocation(line: 20, column: 11, scope: !54)
!56 = !DILocation(line: 21, column: 16, scope: !57)
!57 = distinct !DILexicalBlock(scope: !54, file: !19, line: 20, column: 19)
!58 = !DILocation(line: 22, column: 5, scope: !57)
!59 = !DILocation(line: 23, column: 9, scope: !60)
!60 = distinct !DILexicalBlock(scope: !41, file: !19, line: 23, column: 9)
!61 = !DILocation(line: 23, column: 11, scope: !60)
!62 = !DILocation(line: 24, column: 16, scope: !63)
!63 = distinct !DILexicalBlock(scope: !60, file: !19, line: 23, column: 19)
!64 = !DILocation(line: 25, column: 5, scope: !63)
!65 = !DILocation(line: 27, column: 40, scope: !41)
!66 = !DILocation(line: 27, column: 23, scope: !41)
!67 = !DILocalVariable(name: "result", scope: !41, file: !19, line: 27, type: !68)
!68 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!69 = !DILocation(line: 28, column: 5, scope: !41)