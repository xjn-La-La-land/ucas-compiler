IR dumped to test21.ll
15 :
22 : llvm.memset.p0.i64
31 : clever
clr@5793bd35fba7~/use-def/build $ cat test21.ll
; ModuleID = './test21.bc'
source_filename = "/home/clr/use-def/assign2-tests/test21.c"
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
define dso_local i32 @clever(i32 noundef %0, i32 noundef %1, ptr noundef %2) #0 !dbg !29 {
    #dbg_value(i32 %0, !34, !DIExpression(), !35)
    #dbg_value(i32 %1, !36, !DIExpression(), !35)
    #dbg_value(ptr %2, !37, !DIExpression(), !35)
  %4 = getelementptr inbounds ptr, ptr %2, i64 2, !dbg !38
  %5 = load ptr, ptr %4, align 8, !dbg !38
  %6 = call i32 %5(i32 noundef %0, i32 noundef %1), !dbg !38
  ret i32 %6, !dbg !39
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @moo(i8 noundef signext %0, i32 noundef %1, i32 noundef %2) #0 !dbg !40 {
  %4 = alloca [3 x ptr], align 16
    #dbg_value(i8 %0, !44, !DIExpression(), !45)
    #dbg_value(i32 %1, !46, !DIExpression(), !45)
    #dbg_value(i32 %2, !47, !DIExpression(), !45)
    #dbg_value(ptr @plus, !48, !DIExpression(), !45)
    #dbg_value(ptr @minus, !49, !DIExpression(), !45)
    #dbg_declare(ptr %4, !50, !DIExpression(), !54)
  call void @llvm.memset.p0.i64(ptr align 16 %4, i8 0, i64 24, i1 false), !dbg !54
  %5 = sext i8 %0 to i32, !dbg !55
  %6 = icmp eq i32 %5, 43, !dbg !57
  br i1 %6, label %7, label %9, !dbg !57

7:                                                ; preds = %3
  %8 = getelementptr inbounds [3 x ptr], ptr %4, i64 0, i64 2, !dbg !58
  store ptr @plus, ptr %8, align 16, !dbg !60
  br label %15, !dbg !61

9:                                                ; preds = %3
  %10 = sext i8 %0 to i32, !dbg !62
  %11 = icmp eq i32 %10, 45, !dbg !64
  br i1 %11, label %12, label %14, !dbg !64

12:                                               ; preds = %9
  %13 = getelementptr inbounds [3 x ptr], ptr %4, i64 0, i64 2, !dbg !65
  store ptr @minus, ptr %13, align 16, !dbg !67
  br label %14, !dbg !68

14:                                               ; preds = %12, %9
  br label %15

15:                                               ; preds = %14, %7
  %16 = getelementptr inbounds [3 x ptr], ptr %4, i64 0, i64 0, !dbg !69
  %17 = call i32 @clever(i32 noundef %1, i32 noundef %2, ptr noundef %16), !dbg !70
    #dbg_value(i32 %17, !71, !DIExpression(), !45)
  ret i32 0, !dbg !73
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: write) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8, !9, !10}
!llvm.ident = !{!11}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 20.1.8", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/clr/use-def/assign2-tests/test21.c", directory: "/home/clr/use-def/build", checksumkind: CSK_MD5, checksum: "e56c947a976834a4c550bc3ef781cadd")
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
!12 = distinct !DISubprogram(name: "plus", scope: !13, file: !13, line: 6, type: !14, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!13 = !DIFile(filename: "assign2-tests/test21.c", directory: "/home/clr/use-def", checksumkind: CSK_MD5, checksum: "e56c947a976834a4c550bc3ef781cadd")
!14 = !DISubroutineType(types: !15)
!15 = !{!16, !16, !16}
!16 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!17 = !{}
!18 = !DILocalVariable(name: "a", arg: 1, scope: !12, file: !13, line: 6, type: !16)
!19 = !DILocation(line: 0, scope: !12)
!20 = !DILocalVariable(name: "b", arg: 2, scope: !12, file: !13, line: 6, type: !16)
!21 = !DILocation(line: 7, column: 12, scope: !12)
!22 = !DILocation(line: 7, column: 4, scope: !12)
!23 = distinct !DISubprogram(name: "minus", scope: !13, file: !13, line: 10, type: !14, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!24 = !DILocalVariable(name: "a", arg: 1, scope: !23, file: !13, line: 10, type: !16)
!25 = !DILocation(line: 0, scope: !23)
!26 = !DILocalVariable(name: "b", arg: 2, scope: !23, file: !13, line: 10, type: !16)
!27 = !DILocation(line: 11, column: 12, scope: !23)
!28 = !DILocation(line: 11, column: 4, scope: !23)
!29 = distinct !DISubprogram(name: "clever", scope: !13, file: !13, line: 14, type: !30, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!30 = !DISubroutineType(types: !31)
!31 = !{!16, !16, !16, !32}
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!34 = !DILocalVariable(name: "a", arg: 1, scope: !29, file: !13, line: 14, type: !16)
!35 = !DILocation(line: 0, scope: !29)
!36 = !DILocalVariable(name: "b", arg: 2, scope: !29, file: !13, line: 14, type: !16)
!37 = !DILocalVariable(name: "a_fptr", arg: 3, scope: !29, file: !13, line: 14, type: !32)
!38 = !DILocation(line: 15, column: 12, scope: !29)
!39 = !DILocation(line: 15, column: 5, scope: !29)
!40 = distinct !DISubprogram(name: "moo", scope: !13, file: !13, line: 19, type: !41, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!41 = !DISubroutineType(types: !42)
!42 = !{!16, !43, !16, !16}
!43 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!44 = !DILocalVariable(name: "x", arg: 1, scope: !40, file: !13, line: 19, type: !43)
!45 = !DILocation(line: 0, scope: !40)
!46 = !DILocalVariable(name: "op1", arg: 2, scope: !40, file: !13, line: 19, type: !16)
!47 = !DILocalVariable(name: "op2", arg: 3, scope: !40, file: !13, line: 19, type: !16)
!48 = !DILocalVariable(name: "a_fptr", scope: !40, file: !13, line: 20, type: !33)
!49 = !DILocalVariable(name: "s_fptr", scope: !40, file: !13, line: 21, type: !33)
!50 = !DILocalVariable(name: "t_fptr", scope: !40, file: !13, line: 22, type: !51)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 192, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 3)
!54 = !DILocation(line: 22, column: 11, scope: !40)
!55 = !DILocation(line: 24, column: 9, scope: !56)
!56 = distinct !DILexicalBlock(scope: !40, file: !13, line: 24, column: 9)
!57 = !DILocation(line: 24, column: 11, scope: !56)
!58 = !DILocation(line: 25, column: 8, scope: !59)
!59 = distinct !DILexicalBlock(scope: !56, file: !13, line: 24, column: 19)
!60 = !DILocation(line: 25, column: 18, scope: !59)
!61 = !DILocation(line: 26, column: 5, scope: !59)
!62 = !DILocation(line: 27, column: 14, scope: !63)
!63 = distinct !DILexicalBlock(scope: !56, file: !13, line: 27, column: 14)
!64 = !DILocation(line: 27, column: 16, scope: !63)
!65 = !DILocation(line: 28, column: 8, scope: !66)
!66 = distinct !DILexicalBlock(scope: !63, file: !13, line: 27, column: 24)
!67 = !DILocation(line: 28, column: 18, scope: !66)
!68 = !DILocation(line: 29, column: 5, scope: !66)
!69 = !DILocation(line: 31, column: 40, scope: !40)
!70 = !DILocation(line: 31, column: 23, scope: !40)
!71 = !DILocalVariable(name: "result", scope: !40, file: !13, line: 31, type: !72)
!72 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!73 = !DILocation(line: 32, column: 5, scope: !40)