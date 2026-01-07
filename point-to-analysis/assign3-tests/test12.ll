; ModuleID = './test12.bc'
source_filename = "/home/clr/use-def/assign2-tests/test12.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-generic-linux"

%struct.fptr = type { ptr }

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @plus(i32 noundef %0, i32 noundef %1) #0 !dbg !22 {
    #dbg_value(i32 %0, !24, !DIExpression(), !25)
    #dbg_value(i32 %1, !26, !DIExpression(), !25)
  %3 = add nsw i32 %0, %1, !dbg !27
  ret i32 %3, !dbg !28
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @minus(i32 noundef %0, i32 noundef %1) #0 !dbg !29 {
    #dbg_value(i32 %0, !30, !DIExpression(), !31)
    #dbg_value(i32 %1, !32, !DIExpression(), !31)
  %3 = sub nsw i32 %0, %1, !dbg !33
  ret i32 %3, !dbg !34
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @clever(i32 noundef %0, i32 noundef %1, ptr noundef %2) #0 !dbg !35 {
    #dbg_value(i32 %0, !38, !DIExpression(), !39)
    #dbg_value(i32 %1, !40, !DIExpression(), !39)
    #dbg_value(ptr %2, !41, !DIExpression(), !39)
  %4 = call i32 %2(i32 noundef %0, i32 noundef %1), !dbg !42
  ret i32 %4, !dbg !43
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @moo(i8 noundef signext %0, i32 noundef %1, i32 noundef %2) #0 !dbg !44 {
    #dbg_value(i8 %0, !48, !DIExpression(), !49)
    #dbg_value(i32 %1, !50, !DIExpression(), !49)
    #dbg_value(i32 %2, !51, !DIExpression(), !49)
    #dbg_value(ptr @plus, !52, !DIExpression(), !49)
    #dbg_value(ptr @minus, !53, !DIExpression(), !49)
  %4 = call noalias ptr @malloc(i64 noundef 8) #2, !dbg !54
    #dbg_value(ptr %4, !55, !DIExpression(), !49)
    #dbg_value(ptr @clever, !56, !DIExpression(), !49)
    #dbg_value(i32 0, !58, !DIExpression(), !49)
  %5 = sext i8 %0 to i32, !dbg !60
  %6 = icmp eq i32 %5, 43, !dbg !62
  br i1 %6, label %7, label %9, !dbg !62

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw %struct.fptr, ptr %4, i32 0, i32 0, !dbg !63
  store ptr @plus, ptr %8, align 8, !dbg !65
  br label %11, !dbg !66

9:                                                ; preds = %3
  %10 = getelementptr inbounds nuw %struct.fptr, ptr %4, i32 0, i32 0, !dbg !67
  store ptr @minus, ptr %10, align 8, !dbg !69
  br label %11

11:                                               ; preds = %9, %7
  %12 = getelementptr inbounds nuw %struct.fptr, ptr %4, i32 0, i32 0, !dbg !70
  %13 = load ptr, ptr %12, align 8, !dbg !70
  %14 = call i32 @clever(i32 noundef %1, i32 noundef %2, ptr noundef %13), !dbg !71
    #dbg_value(i32 %14, !58, !DIExpression(), !49)
  ret i32 %14, !dbg !72
}

; Function Attrs: nounwind allocsize(0)
declare noalias ptr @malloc(i64 noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18, !19, !20}
!llvm.ident = !{!21}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 20.1.8", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/clr/use-def/assign2-tests/test12.c", directory: "/home/clr/use-def/build", checksumkind: CSK_MD5, checksum: "de006e1b97388f711602a500fbfef65a")
!2 = !{!3}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!4 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "fptr", file: !5, line: 13, size: 64, elements: !6)
!5 = !DIFile(filename: "assign2-tests/test12.c", directory: "/home/clr/use-def", checksumkind: CSK_MD5, checksum: "de006e1b97388f711602a500fbfef65a")
!6 = !{!7}
!7 = !DIDerivedType(tag: DW_TAG_member, name: "p_fptr", scope: !4, file: !5, line: 15, baseType: !8, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DISubroutineType(types: !10)
!10 = !{!11, !11, !11}
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !{i32 7, !"Dwarf Version", i32 5}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{i32 8, !"PIC Level", i32 2}
!16 = !{i32 7, !"PIE Level", i32 2}
!17 = !{i32 7, !"uwtable", i32 2}
!18 = !{i32 7, !"frame-pointer", i32 2}
!19 = !{i32 1, !"ThinLTO", i32 0}
!20 = !{i32 1, !"EnableSplitLTOUnit", i32 1}
!21 = !{!"clang version 20.1.8"}
!22 = distinct !DISubprogram(name: "plus", scope: !5, file: !5, line: 2, type: !9, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !23)
!23 = !{}
!24 = !DILocalVariable(name: "a", arg: 1, scope: !22, file: !5, line: 2, type: !11)
!25 = !DILocation(line: 0, scope: !22)
!26 = !DILocalVariable(name: "b", arg: 2, scope: !22, file: !5, line: 2, type: !11)
!27 = !DILocation(line: 3, column: 12, scope: !22)
!28 = !DILocation(line: 3, column: 4, scope: !22)
!29 = distinct !DISubprogram(name: "minus", scope: !5, file: !5, line: 6, type: !9, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !23)
!30 = !DILocalVariable(name: "a", arg: 1, scope: !29, file: !5, line: 6, type: !11)
!31 = !DILocation(line: 0, scope: !29)
!32 = !DILocalVariable(name: "b", arg: 2, scope: !29, file: !5, line: 6, type: !11)
!33 = !DILocation(line: 7, column: 12, scope: !29)
!34 = !DILocation(line: 7, column: 4, scope: !29)
!35 = distinct !DISubprogram(name: "clever", scope: !5, file: !5, line: 10, type: !36, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !23)
!36 = !DISubroutineType(types: !37)
!37 = !{!11, !11, !11, !8}
!38 = !DILocalVariable(name: "a", arg: 1, scope: !35, file: !5, line: 10, type: !11)
!39 = !DILocation(line: 0, scope: !35)
!40 = !DILocalVariable(name: "b", arg: 2, scope: !35, file: !5, line: 10, type: !11)
!41 = !DILocalVariable(name: "a_fptr", arg: 3, scope: !35, file: !5, line: 10, type: !8)
!42 = !DILocation(line: 11, column: 12, scope: !35)
!43 = !DILocation(line: 11, column: 5, scope: !35)
!44 = distinct !DISubprogram(name: "moo", scope: !5, file: !5, line: 18, type: !45, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !23)
!45 = !DISubroutineType(types: !46)
!46 = !{!11, !47, !11, !11}
!47 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!48 = !DILocalVariable(name: "x", arg: 1, scope: !44, file: !5, line: 18, type: !47)
!49 = !DILocation(line: 0, scope: !44)
!50 = !DILocalVariable(name: "op1", arg: 2, scope: !44, file: !5, line: 18, type: !11)
!51 = !DILocalVariable(name: "op2", arg: 3, scope: !44, file: !5, line: 18, type: !11)
!52 = !DILocalVariable(name: "a_fptr", scope: !44, file: !5, line: 19, type: !8)
!53 = !DILocalVariable(name: "s_fptr", scope: !44, file: !5, line: 20, type: !8)
!54 = !DILocation(line: 21, column: 41, scope: !44)
!55 = !DILocalVariable(name: "t_fptr", scope: !44, file: !5, line: 21, type: !3)
!56 = !DILocalVariable(name: "af_ptr", scope: !44, file: !5, line: 22, type: !57)
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!58 = !DILocalVariable(name: "result", scope: !44, file: !5, line: 23, type: !59)
!59 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!60 = !DILocation(line: 24, column: 9, scope: !61)
!61 = distinct !DILexicalBlock(scope: !44, file: !5, line: 24, column: 9)
!62 = !DILocation(line: 24, column: 11, scope: !61)
!63 = !DILocation(line: 25, column: 16, scope: !64)
!64 = distinct !DILexicalBlock(scope: !61, file: !5, line: 24, column: 19)
!65 = !DILocation(line: 25, column: 23, scope: !64)
!66 = !DILocation(line: 26, column: 5, scope: !64)
!67 = !DILocation(line: 28, column: 16, scope: !68)
!68 = distinct !DILexicalBlock(scope: !61, file: !5, line: 27, column: 5)
!69 = !DILocation(line: 28, column: 23, scope: !68)
!70 = !DILocation(line: 30, column: 38, scope: !44)
!71 = !DILocation(line: 30, column: 13, scope: !44)
!72 = !DILocation(line: 31, column: 5, scope: !44)