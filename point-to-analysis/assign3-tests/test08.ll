; ModuleID = './test08.bc'
source_filename = "/home/clr/use-def/assign2-tests/test08.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-generic-linux"

%struct.fptr = type { ptr }
%struct.fsptr = type { ptr }

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
define dso_local void @foo(i32 noundef %0) #0 !dbg !29 {
  %2 = alloca %struct.fptr, align 8
  %3 = alloca %struct.fsptr, align 8
    #dbg_value(i32 %0, !32, !DIExpression(), !33)
    #dbg_declare(ptr %2, !34, !DIExpression(), !39)
    #dbg_declare(ptr %3, !40, !DIExpression(), !45)
  %4 = getelementptr inbounds nuw %struct.fsptr, ptr %3, i32 0, i32 0, !dbg !46
  store ptr %2, ptr %4, align 8, !dbg !47
  %5 = icmp sgt i32 %0, 1, !dbg !48
  br i1 %5, label %6, label %14, !dbg !48

6:                                                ; preds = %1
  %7 = getelementptr inbounds nuw %struct.fptr, ptr %2, i32 0, i32 0, !dbg !50
  store ptr @plus, ptr %7, align 8, !dbg !52
  %8 = getelementptr inbounds nuw %struct.fsptr, ptr %3, i32 0, i32 0, !dbg !53
  %9 = load ptr, ptr %8, align 8, !dbg !53
  %10 = getelementptr inbounds nuw %struct.fptr, ptr %9, i32 0, i32 0, !dbg !54
  %11 = load ptr, ptr %10, align 8, !dbg !54
  %12 = call i32 %11(i32 noundef 1, i32 noundef %0), !dbg !55
    #dbg_value(i32 %12, !32, !DIExpression(), !33)
  %13 = getelementptr inbounds nuw %struct.fptr, ptr %2, i32 0, i32 0, !dbg !56
  store ptr @minus, ptr %13, align 8, !dbg !57
  br label %18, !dbg !58

14:                                               ; preds = %1
  %15 = getelementptr inbounds nuw %struct.fsptr, ptr %3, i32 0, i32 0, !dbg !59
  %16 = load ptr, ptr %15, align 8, !dbg !59
  %17 = getelementptr inbounds nuw %struct.fptr, ptr %16, i32 0, i32 0, !dbg !61
  store ptr @minus, ptr %17, align 8, !dbg !62
  br label %18

18:                                               ; preds = %14, %6
  %.0 = phi i32 [ %12, %6 ], [ %0, %14 ]
    #dbg_value(i32 %.0, !32, !DIExpression(), !33)
  %19 = getelementptr inbounds nuw %struct.fptr, ptr %2, i32 0, i32 0, !dbg !63
  %20 = load ptr, ptr %19, align 8, !dbg !63
  %21 = call i32 %20(i32 noundef 1, i32 noundef %.0), !dbg !64
    #dbg_value(i32 %21, !32, !DIExpression(), !33)
  ret void, !dbg !65
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8, !9, !10}
!llvm.ident = !{!11}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 20.1.8", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/clr/use-def/assign2-tests/test08.c", directory: "/home/clr/use-def/build", checksumkind: CSK_MD5, checksum: "8313b38f694d67152b7ad85ba1a94df9")
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
!12 = distinct !DISubprogram(name: "plus", scope: !13, file: !13, line: 10, type: !14, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!13 = !DIFile(filename: "assign2-tests/test08.c", directory: "/home/clr/use-def", checksumkind: CSK_MD5, checksum: "8313b38f694d67152b7ad85ba1a94df9")
!14 = !DISubroutineType(types: !15)
!15 = !{!16, !16, !16}
!16 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!17 = !{}
!18 = !DILocalVariable(name: "a", arg: 1, scope: !12, file: !13, line: 10, type: !16)
!19 = !DILocation(line: 0, scope: !12)
!20 = !DILocalVariable(name: "b", arg: 2, scope: !12, file: !13, line: 10, type: !16)
!21 = !DILocation(line: 11, column: 12, scope: !12)
!22 = !DILocation(line: 11, column: 4, scope: !12)
!23 = distinct !DISubprogram(name: "minus", scope: !13, file: !13, line: 14, type: !14, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!24 = !DILocalVariable(name: "a", arg: 1, scope: !23, file: !13, line: 14, type: !16)
!25 = !DILocation(line: 0, scope: !23)
!26 = !DILocalVariable(name: "b", arg: 2, scope: !23, file: !13, line: 14, type: !16)
!27 = !DILocation(line: 15, column: 12, scope: !23)
!28 = !DILocation(line: 15, column: 4, scope: !23)
!29 = distinct !DISubprogram(name: "foo", scope: !13, file: !13, line: 17, type: !30, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!30 = !DISubroutineType(types: !31)
!31 = !{null, !16}
!32 = !DILocalVariable(name: "x", arg: 1, scope: !29, file: !13, line: 17, type: !16)
!33 = !DILocation(line: 0, scope: !29)
!34 = !DILocalVariable(name: "a_fptr", scope: !29, file: !13, line: 19, type: !35)
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "fptr", file: !13, line: 2, size: 64, elements: !36)
!36 = !{!37}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "p_fptr", scope: !35, file: !13, line: 4, baseType: !38, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!39 = !DILocation(line: 19, column: 14, scope: !29)
!40 = !DILocalVariable(name: "s_fptr", scope: !29, file: !13, line: 20, type: !41)
!41 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "fsptr", file: !13, line: 6, size: 64, elements: !42)
!42 = !{!43}
!43 = !DIDerivedType(tag: DW_TAG_member, name: "sptr", scope: !41, file: !13, line: 8, baseType: !44, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!45 = !DILocation(line: 20, column: 15, scope: !29)
!46 = !DILocation(line: 21, column: 9, scope: !29)
!47 = !DILocation(line: 21, column: 13, scope: !29)
!48 = !DILocation(line: 22, column: 6, scope: !49)
!49 = distinct !DILexicalBlock(scope: !29, file: !13, line: 22, column: 5)
!50 = !DILocation(line: 24, column: 11, scope: !51)
!51 = distinct !DILexicalBlock(scope: !49, file: !13, line: 23, column: 2)
!52 = !DILocation(line: 24, column: 17, scope: !51)
!53 = !DILocation(line: 25, column: 13, scope: !51)
!54 = !DILocation(line: 25, column: 19, scope: !51)
!55 = !DILocation(line: 25, column: 6, scope: !51)
!56 = !DILocation(line: 26, column: 11, scope: !51)
!57 = !DILocation(line: 26, column: 17, scope: !51)
!58 = !DILocation(line: 27, column: 2, scope: !51)
!59 = !DILocation(line: 29, column: 10, scope: !60)
!60 = distinct !DILexicalBlock(scope: !49, file: !13, line: 28, column: 2)
!61 = !DILocation(line: 29, column: 16, scope: !60)
!62 = !DILocation(line: 29, column: 22, scope: !60)
!63 = !DILocation(line: 31, column: 11, scope: !29)
!64 = !DILocation(line: 31, column: 4, scope: !29)
!65 = !DILocation(line: 32, column: 1, scope: !29)