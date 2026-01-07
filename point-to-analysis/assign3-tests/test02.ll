; ModuleID = './build/test02.bc'
source_filename = "/home/clr/use-def/assign2-tests/test02.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-generic-linux"

%struct.fptr = type { ptr }

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @plus(i32 noundef %0, i32 noundef %1) #0 !dbg !14 {
    #dbg_value(i32 %0, !20, !DIExpression(), !21)
    #dbg_value(i32 %1, !22, !DIExpression(), !21)
  %3 = add nsw i32 %0, %1, !dbg !23
  ret i32 %3, !dbg !24
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @minus(i32 noundef %0, i32 noundef %1) #0 !dbg !25 {
    #dbg_value(i32 %0, !26, !DIExpression(), !27)
    #dbg_value(i32 %1, !28, !DIExpression(), !27)
  %3 = sub nsw i32 %0, %1, !dbg !29
  ret i32 %3, !dbg !30
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @clever(i32 noundef %0) #0 !dbg !31 {
  %2 = alloca %struct.fptr, align 8
    #dbg_value(i32 %0, !34, !DIExpression(), !35)
    #dbg_value(ptr @plus, !36, !DIExpression(), !35)
    #dbg_value(ptr @minus, !38, !DIExpression(), !35)
    #dbg_declare(ptr %2, !39, !DIExpression(), !43)
  call void @llvm.memset.p0.i64(ptr align 8 %2, i8 0, i64 8, i1 false), !dbg !43
    #dbg_value(i32 1, !44, !DIExpression(), !35)
    #dbg_value(i32 2, !45, !DIExpression(), !35)
  %3 = icmp eq i32 %0, 3, !dbg !46
  br i1 %3, label %4, label %6, !dbg !46

4:                                                ; preds = %1
  %5 = getelementptr inbounds nuw %struct.fptr, ptr %2, i32 0, i32 0, !dbg !48
  store ptr @plus, ptr %5, align 8, !dbg !50
  br label %8, !dbg !51

6:                                                ; preds = %1
  %7 = getelementptr inbounds nuw %struct.fptr, ptr %2, i32 0, i32 0, !dbg !52
  store ptr @minus, ptr %7, align 8, !dbg !54
  br label %8

8:                                                ; preds = %6, %4
  %9 = getelementptr inbounds nuw %struct.fptr, ptr %2, i32 0, i32 0, !dbg !55
  %10 = load ptr, ptr %9, align 8, !dbg !55
  %11 = icmp ne ptr %10, null, !dbg !57
  br i1 %11, label %12, label %16, !dbg !57

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw %struct.fptr, ptr %2, i32 0, i32 0, !dbg !58
  %14 = load ptr, ptr %13, align 8, !dbg !58
  %15 = call i32 %14(i32 noundef 1, i32 noundef 2), !dbg !60
    #dbg_value(i32 %15, !61, !DIExpression(), !63)
  br label %16, !dbg !64

16:                                               ; preds = %12, %8
  ret i32 0, !dbg !65
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: write) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!4, !5, !6, !7, !8, !9, !10, !11, !12}
!llvm.ident = !{!13}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 20.1.8", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/clr/use-def/assign2-tests/test02.c", directory: "/home/clr/use-def/build", checksumkind: CSK_MD5, checksum: "b3fb63b34288eeec945ca55d04299726")
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
!14 = distinct !DISubprogram(name: "plus", scope: !15, file: !15, line: 6, type: !16, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!15 = !DIFile(filename: "assign2-tests/test02.c", directory: "/home/clr/use-def", checksumkind: CSK_MD5, checksum: "b3fb63b34288eeec945ca55d04299726")
!16 = !DISubroutineType(types: !17)
!17 = !{!18, !18, !18}
!18 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!19 = !{}
!20 = !DILocalVariable(name: "a", arg: 1, scope: !14, file: !15, line: 6, type: !18)
!21 = !DILocation(line: 0, scope: !14)
!22 = !DILocalVariable(name: "b", arg: 2, scope: !14, file: !15, line: 6, type: !18)
!23 = !DILocation(line: 7, column: 12, scope: !14)
!24 = !DILocation(line: 7, column: 4, scope: !14)
!25 = distinct !DISubprogram(name: "minus", scope: !15, file: !15, line: 10, type: !16, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!26 = !DILocalVariable(name: "a", arg: 1, scope: !25, file: !15, line: 10, type: !18)
!27 = !DILocation(line: 0, scope: !25)
!28 = !DILocalVariable(name: "b", arg: 2, scope: !25, file: !15, line: 10, type: !18)
!29 = !DILocation(line: 11, column: 12, scope: !25)
!30 = !DILocation(line: 11, column: 4, scope: !25)
!31 = distinct !DISubprogram(name: "clever", scope: !15, file: !15, line: 14, type: !32, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!32 = !DISubroutineType(types: !33)
!33 = !{!18, !18}
!34 = !DILocalVariable(name: "x", arg: 1, scope: !31, file: !15, line: 14, type: !18)
!35 = !DILocation(line: 0, scope: !31)
!36 = !DILocalVariable(name: "a_fptr", scope: !31, file: !15, line: 15, type: !37)
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!38 = !DILocalVariable(name: "s_fptr", scope: !31, file: !15, line: 16, type: !37)
!39 = !DILocalVariable(name: "t_fptr", scope: !31, file: !15, line: 17, type: !40)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "fptr", file: !15, line: 2, size: 64, elements: !41)
!41 = !{!42}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "p_fptr", scope: !40, file: !15, line: 4, baseType: !37, size: 64)
!43 = !DILocation(line: 17, column: 17, scope: !31)
!44 = !DILocalVariable(name: "op1", scope: !31, file: !15, line: 19, type: !18)
!45 = !DILocalVariable(name: "op2", scope: !31, file: !15, line: 19, type: !18)
!46 = !DILocation(line: 21, column: 11, scope: !47)
!47 = distinct !DILexicalBlock(scope: !31, file: !15, line: 21, column: 9)
!48 = !DILocation(line: 22, column: 15, scope: !49)
!49 = distinct !DILexicalBlock(scope: !47, file: !15, line: 21, column: 17)
!50 = !DILocation(line: 22, column: 22, scope: !49)
!51 = !DILocation(line: 23, column: 5, scope: !49)
!52 = !DILocation(line: 24, column: 15, scope: !53)
!53 = distinct !DILexicalBlock(scope: !47, file: !15, line: 23, column: 12)
!54 = !DILocation(line: 24, column: 22, scope: !53)
!55 = !DILocation(line: 27, column: 16, scope: !56)
!56 = distinct !DILexicalBlock(scope: !31, file: !15, line: 27, column: 9)
!57 = !DILocation(line: 27, column: 23, scope: !56)
!58 = !DILocation(line: 28, column: 33, scope: !59)
!59 = distinct !DILexicalBlock(scope: !56, file: !15, line: 27, column: 32)
!60 = !DILocation(line: 28, column: 26, scope: !59)
!61 = !DILocalVariable(name: "result", scope: !59, file: !15, line: 28, type: !62)
!62 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!63 = !DILocation(line: 0, scope: !59)
!64 = !DILocation(line: 29, column: 5, scope: !59)
!65 = !DILocation(line: 30, column: 4, scope: !31)