; ModuleID = './test20.bc'
source_filename = "/home/clr/use-def/assign2-tests/test20.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-generic-linux"

%struct.fsptr = type { ptr }
%struct.fptr = type { ptr }

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
    #dbg_value(i32 %0, !41, !DIExpression(), !42)
    #dbg_value(i32 %1, !43, !DIExpression(), !42)
    #dbg_value(ptr %2, !44, !DIExpression(), !42)
    #dbg_value(ptr %3, !45, !DIExpression(), !42)
  %5 = getelementptr inbounds nuw %struct.fsptr, ptr %2, i32 0, i32 0, !dbg !46
  %6 = load ptr, ptr %5, align 8, !dbg !46
  ret ptr %6, !dbg !47
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @clever(i32 noundef %0, i32 noundef %1, ptr noundef %2, ptr noundef %3) #0 !dbg !48 {
    #dbg_value(i32 %0, !49, !DIExpression(), !50)
    #dbg_value(i32 %1, !51, !DIExpression(), !50)
    #dbg_value(ptr %2, !52, !DIExpression(), !50)
    #dbg_value(ptr %3, !53, !DIExpression(), !50)
  %5 = getelementptr inbounds nuw %struct.fsptr, ptr %3, i32 0, i32 0, !dbg !54
  %6 = load ptr, ptr %5, align 8, !dbg !54
  ret ptr %6, !dbg !55
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @moo(i8 noundef signext %0, i32 noundef %1, i32 noundef %2) #0 !dbg !56 {
  %4 = alloca %struct.fptr, align 8
  %5 = alloca %struct.fptr, align 8
  %6 = alloca %struct.fsptr, align 8
  %7 = alloca %struct.fsptr, align 8
    #dbg_value(i8 %0, !60, !DIExpression(), !61)
    #dbg_value(i32 %1, !62, !DIExpression(), !61)
    #dbg_value(i32 %2, !63, !DIExpression(), !61)
    #dbg_declare(ptr %4, !64, !DIExpression(), !65)
  %8 = getelementptr inbounds nuw %struct.fptr, ptr %4, i32 0, i32 0, !dbg !66
  store ptr @plus, ptr %8, align 8, !dbg !67
    #dbg_declare(ptr %5, !68, !DIExpression(), !69)
  %9 = getelementptr inbounds nuw %struct.fptr, ptr %5, i32 0, i32 0, !dbg !70
  store ptr @minus, ptr %9, align 8, !dbg !71
    #dbg_declare(ptr %6, !72, !DIExpression(), !73)
  %10 = getelementptr inbounds nuw %struct.fsptr, ptr %6, i32 0, i32 0, !dbg !74
  store ptr %4, ptr %10, align 8, !dbg !75
    #dbg_declare(ptr %7, !76, !DIExpression(), !77)
  %11 = getelementptr inbounds nuw %struct.fsptr, ptr %7, i32 0, i32 0, !dbg !78
  store ptr %5, ptr %11, align 8, !dbg !79
    #dbg_value(ptr null, !80, !DIExpression(), !61)
  %12 = sext i8 %0 to i32, !dbg !81
  %13 = icmp eq i32 %12, 43, !dbg !83
  br i1 %13, label %14, label %15, !dbg !83

14:                                               ; preds = %3
    #dbg_value(ptr @foo, !84, !DIExpression(), !61)
  br label %20, !dbg !86

15:                                               ; preds = %3
  %16 = sext i8 %0 to i32, !dbg !88
  %17 = icmp eq i32 %16, 45, !dbg !90
  br i1 %17, label %18, label %19, !dbg !90

18:                                               ; preds = %15
    #dbg_value(ptr @clever, !84, !DIExpression(), !61)
  br label %19, !dbg !91

19:                                               ; preds = %18, %15
    #dbg_value(ptr @clever, !84, !DIExpression(), !61)
  br label %20

20:                                               ; preds = %19, %14
  %.1 = phi ptr [ @foo, %14 ], [ @clever, %19 ], !dbg !93
    #dbg_value(ptr %.1, !84, !DIExpression(), !61)
  %21 = call ptr %.1(i32 noundef %1, i32 noundef %2, ptr noundef %6, ptr noundef %7), !dbg !94
    #dbg_value(ptr %21, !80, !DIExpression(), !61)
  %22 = getelementptr inbounds nuw %struct.fptr, ptr %21, i32 0, i32 0, !dbg !95
  %23 = load ptr, ptr %22, align 8, !dbg !95
  %24 = call i32 %23(i32 noundef %1, i32 noundef %2), !dbg !96
  ret i32 0, !dbg !97
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8, !9, !10}
!llvm.ident = !{!11}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 20.1.8", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/clr/use-def/assign2-tests/test20.c", directory: "/home/clr/use-def/build", checksumkind: CSK_MD5, checksum: "66ae09a22f7bc7e69d2f5f9e1da79ce7")
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
!13 = !DIFile(filename: "assign2-tests/test20.c", directory: "/home/clr/use-def", checksumkind: CSK_MD5, checksum: "66ae09a22f7bc7e69d2f5f9e1da79ce7")
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
!29 = distinct !DISubprogram(name: "foo", scope: !13, file: !13, line: 18, type: !30, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!30 = !DISubroutineType(types: !31)
!31 = !{!32, !16, !16, !37, !37}
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "fptr", file: !13, line: 2, size: 64, elements: !34)
!34 = !{!35}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "p_fptr", scope: !33, file: !13, line: 4, baseType: !36, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "fsptr", file: !13, line: 6, size: 64, elements: !39)
!39 = !{!40}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "sptr", scope: !38, file: !13, line: 8, baseType: !32, size: 64)
!41 = !DILocalVariable(name: "a", arg: 1, scope: !29, file: !13, line: 18, type: !16)
!42 = !DILocation(line: 0, scope: !29)
!43 = !DILocalVariable(name: "b", arg: 2, scope: !29, file: !13, line: 18, type: !16)
!44 = !DILocalVariable(name: "a_fptr", arg: 3, scope: !29, file: !13, line: 18, type: !37)
!45 = !DILocalVariable(name: "b_fptr", arg: 4, scope: !29, file: !13, line: 18, type: !37)
!46 = !DILocation(line: 19, column: 19, scope: !29)
!47 = !DILocation(line: 19, column: 4, scope: !29)
!48 = distinct !DISubprogram(name: "clever", scope: !13, file: !13, line: 22, type: !30, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!49 = !DILocalVariable(name: "a", arg: 1, scope: !48, file: !13, line: 22, type: !16)
!50 = !DILocation(line: 0, scope: !48)
!51 = !DILocalVariable(name: "b", arg: 2, scope: !48, file: !13, line: 22, type: !16)
!52 = !DILocalVariable(name: "a_fptr", arg: 3, scope: !48, file: !13, line: 22, type: !37)
!53 = !DILocalVariable(name: "b_fptr", arg: 4, scope: !48, file: !13, line: 22, type: !37)
!54 = !DILocation(line: 23, column: 19, scope: !48)
!55 = !DILocation(line: 23, column: 4, scope: !48)
!56 = distinct !DISubprogram(name: "moo", scope: !13, file: !13, line: 26, type: !57, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!57 = !DISubroutineType(types: !58)
!58 = !{!16, !59, !16, !16}
!59 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!60 = !DILocalVariable(name: "x", arg: 1, scope: !56, file: !13, line: 26, type: !59)
!61 = !DILocation(line: 0, scope: !56)
!62 = !DILocalVariable(name: "op1", arg: 2, scope: !56, file: !13, line: 26, type: !16)
!63 = !DILocalVariable(name: "op2", arg: 3, scope: !56, file: !13, line: 26, type: !16)
!64 = !DILocalVariable(name: "a_fptr", scope: !56, file: !13, line: 27, type: !33)
!65 = !DILocation(line: 27, column: 17, scope: !56)
!66 = !DILocation(line: 28, column: 12, scope: !56)
!67 = !DILocation(line: 28, column: 18, scope: !56)
!68 = !DILocalVariable(name: "s_fptr", scope: !56, file: !13, line: 29, type: !33)
!69 = !DILocation(line: 29, column: 17, scope: !56)
!70 = !DILocation(line: 30, column: 12, scope: !56)
!71 = !DILocation(line: 30, column: 18, scope: !56)
!72 = !DILocalVariable(name: "m_fptr", scope: !56, file: !13, line: 31, type: !38)
!73 = !DILocation(line: 31, column: 18, scope: !56)
!74 = !DILocation(line: 32, column: 12, scope: !56)
!75 = !DILocation(line: 32, column: 16, scope: !56)
!76 = !DILocalVariable(name: "n_fptr", scope: !56, file: !13, line: 33, type: !38)
!77 = !DILocation(line: 33, column: 18, scope: !56)
!78 = !DILocation(line: 34, column: 12, scope: !56)
!79 = !DILocation(line: 34, column: 16, scope: !56)
!80 = !DILocalVariable(name: "t_fptr", scope: !56, file: !13, line: 37, type: !32)
!81 = !DILocation(line: 39, column: 9, scope: !82)
!82 = distinct !DILexicalBlock(scope: !56, file: !13, line: 39, column: 9)
!83 = !DILocation(line: 39, column: 11, scope: !82)
!84 = !DILocalVariable(name: "goo_ptr", scope: !56, file: !13, line: 36, type: !85)
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!86 = !DILocation(line: 41, column: 5, scope: !87)
!87 = distinct !DILexicalBlock(scope: !82, file: !13, line: 39, column: 19)
!88 = !DILocation(line: 42, column: 14, scope: !89)
!89 = distinct !DILexicalBlock(scope: !82, file: !13, line: 42, column: 14)
!90 = !DILocation(line: 42, column: 16, scope: !89)
!91 = !DILocation(line: 45, column: 5, scope: !92)
!92 = distinct !DILexicalBlock(scope: !89, file: !13, line: 42, column: 24)
!93 = !DILocation(line: 0, scope: !82)
!94 = !DILocation(line: 47, column: 14, scope: !56)
!95 = !DILocation(line: 48, column: 13, scope: !56)
!96 = !DILocation(line: 48, column: 5, scope: !56)
!97 = !DILocation(line: 50, column: 5, scope: !56)