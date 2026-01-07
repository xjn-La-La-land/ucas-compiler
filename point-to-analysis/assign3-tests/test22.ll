; ModuleID = './test22.bc'
source_filename = "/home/clr/use-def/assign2-tests/test22.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-generic-linux"

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
define dso_local i32 @foo(i32 noundef %0, i32 noundef %1, ptr %2) #0 !dbg !29 {
  %4 = alloca %struct.fptr, align 8
  %5 = getelementptr inbounds nuw %struct.fptr, ptr %4, i32 0, i32 0
  store ptr %2, ptr %5, align 8
    #dbg_value(i32 %0, !36, !DIExpression(), !37)
    #dbg_value(i32 %1, !38, !DIExpression(), !37)
    #dbg_declare(ptr %4, !39, !DIExpression(), !40)
  %6 = getelementptr inbounds nuw %struct.fptr, ptr %4, i32 0, i32 0, !dbg !41
  %7 = load ptr, ptr %6, align 8, !dbg !41
  %8 = call i32 %7(i32 noundef %0, i32 noundef %1), !dbg !42
  ret i32 %8, !dbg !43
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @make_simple_alias(ptr noundef %0, ptr noundef %1) #0 !dbg !44 {
    #dbg_value(ptr %0, !48, !DIExpression(), !49)
    #dbg_value(ptr %1, !50, !DIExpression(), !49)
  %3 = getelementptr inbounds nuw %struct.fptr, ptr %1, i32 0, i32 0, !dbg !51
  %4 = load ptr, ptr %3, align 8, !dbg !51
  %5 = getelementptr inbounds nuw %struct.fptr, ptr %0, i32 0, i32 0, !dbg !52
  store ptr %4, ptr %5, align 8, !dbg !53
  ret void, !dbg !54
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @clever() #0 !dbg !55 {
  %1 = alloca %struct.fptr, align 8
  %2 = alloca %struct.fptr, align 8
    #dbg_value(ptr null, !58, !DIExpression(), !60)
    #dbg_declare(ptr %1, !61, !DIExpression(), !62)
  call void @llvm.memset.p0.i64(ptr align 8 %1, i8 0, i64 8, i1 false), !dbg !62
    #dbg_declare(ptr %2, !63, !DIExpression(), !64)
  call void @llvm.memset.p0.i64(ptr align 8 %2, i8 0, i64 8, i1 false), !dbg !64
  %3 = getelementptr inbounds nuw %struct.fptr, ptr %1, i32 0, i32 0, !dbg !65
  store ptr @minus, ptr %3, align 8, !dbg !66
  %4 = getelementptr inbounds nuw %struct.fptr, ptr %2, i32 0, i32 0, !dbg !67
  store ptr @plus, ptr %4, align 8, !dbg !68
    #dbg_value(ptr @foo, !58, !DIExpression(), !60)
  call void @make_simple_alias(ptr noundef %1, ptr noundef %2), !dbg !69
  %5 = getelementptr inbounds nuw %struct.fptr, ptr %1, i32 0, i32 0, !dbg !70
  %6 = load ptr, ptr %5, align 8, !dbg !70
  %7 = call i32 @foo(i32 noundef 1, i32 noundef 2, ptr %6), !dbg !70
    #dbg_value(i32 %7, !71, !DIExpression(), !60)
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
!1 = !DIFile(filename: "/home/clr/use-def/assign2-tests/test22.c", directory: "/home/clr/use-def/build", checksumkind: CSK_MD5, checksum: "e228fe80b0def948f36ade89badfdd60")
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
!13 = !DIFile(filename: "assign2-tests/test22.c", directory: "/home/clr/use-def", checksumkind: CSK_MD5, checksum: "e228fe80b0def948f36ade89badfdd60")
!14 = !DISubroutineType(types: !15)
!15 = !{!16, !16, !16}
!16 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!17 = !{}
!18 = !DILocalVariable(name: "a", arg: 1, scope: !12, file: !13, line: 6, type: !16)
!19 = !DILocation(line: 0, scope: !12)
!20 = !DILocalVariable(name: "b", arg: 2, scope: !12, file: !13, line: 6, type: !16)
!21 = !DILocation(line: 7, column: 12, scope: !12)
!22 = !DILocation(line: 7, column: 4, scope: !12)
!23 = distinct !DISubprogram(name: "minus", scope: !13, file: !13, line: 10, type: !14, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!24 = !DILocalVariable(name: "a", arg: 1, scope: !23, file: !13, line: 10, type: !16)
!25 = !DILocation(line: 0, scope: !23)
!26 = !DILocalVariable(name: "b", arg: 2, scope: !23, file: !13, line: 10, type: !16)
!27 = !DILocation(line: 12, column: 13, scope: !23)
!28 = !DILocation(line: 12, column: 5, scope: !23)
!29 = distinct !DISubprogram(name: "foo", scope: !13, file: !13, line: 15, type: !30, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!30 = !DISubroutineType(types: !31)
!31 = !{!16, !16, !16, !32}
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "fptr", file: !13, line: 2, size: 64, elements: !33)
!33 = !{!34}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "p_fptr", scope: !32, file: !13, line: 4, baseType: !35, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!36 = !DILocalVariable(name: "a", arg: 1, scope: !29, file: !13, line: 15, type: !16)
!37 = !DILocation(line: 0, scope: !29)
!38 = !DILocalVariable(name: "b", arg: 2, scope: !29, file: !13, line: 15, type: !16)
!39 = !DILocalVariable(name: "af_ptr", arg: 3, scope: !29, file: !13, line: 15, type: !32)
!40 = !DILocation(line: 15, column: 33, scope: !29)
!41 = !DILocation(line: 17, column: 19, scope: !29)
!42 = !DILocation(line: 17, column: 12, scope: !29)
!43 = !DILocation(line: 17, column: 5, scope: !29)
!44 = distinct !DISubprogram(name: "make_simple_alias", scope: !13, file: !13, line: 19, type: !45, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!45 = !DISubroutineType(types: !46)
!46 = !{null, !47, !47}
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!48 = !DILocalVariable(name: "a", arg: 1, scope: !44, file: !13, line: 19, type: !47)
!49 = !DILocation(line: 0, scope: !44)
!50 = !DILocalVariable(name: "b", arg: 2, scope: !44, file: !13, line: 19, type: !47)
!51 = !DILocation(line: 21, column: 18, scope: !44)
!52 = !DILocation(line: 21, column: 8, scope: !44)
!53 = !DILocation(line: 21, column: 14, scope: !44)
!54 = !DILocation(line: 22, column: 1, scope: !44)
!55 = distinct !DISubprogram(name: "clever", scope: !13, file: !13, line: 23, type: !56, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!56 = !DISubroutineType(types: !57)
!57 = !{!16}
!58 = !DILocalVariable(name: "af_ptr", scope: !55, file: !13, line: 25, type: !59)
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!60 = !DILocation(line: 0, scope: !55)
!61 = !DILocalVariable(name: "tf_ptr", scope: !55, file: !13, line: 26, type: !32)
!62 = !DILocation(line: 26, column: 17, scope: !55)
!63 = !DILocalVariable(name: "sf_ptr", scope: !55, file: !13, line: 27, type: !32)
!64 = !DILocation(line: 27, column: 17, scope: !55)
!65 = !DILocation(line: 28, column: 12, scope: !55)
!66 = !DILocation(line: 28, column: 18, scope: !55)
!67 = !DILocation(line: 29, column: 12, scope: !55)
!68 = !DILocation(line: 29, column: 18, scope: !55)
!69 = !DILocation(line: 31, column: 5, scope: !55)
!70 = !DILocation(line: 32, column: 23, scope: !55)
!71 = !DILocalVariable(name: "result", scope: !55, file: !13, line: 32, type: !72)
!72 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!73 = !DILocation(line: 33, column: 5, scope: !55)