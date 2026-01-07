cmake_minimum_required(VERSION 3.10.0)
project(HomeworkLLVM VERSION 0.1.0)

find_package(LLVM REQUIRED CONFIG)
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

include(CTest)
enable_testing()

include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})
separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
add_definitions(${LLVM_DEFINITIONS_LIST})
llvm_map_components_to_libnames(llvm_libs support core irreader bitwriter passes)

if(NOT LLVM_ENABLE_RTTI)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
endif()

add_executable(HomeworkLLVM main.cpp HomeworkLLVMPass.cpp)
target_compile_features(HomeworkLLVM PRIVATE cxx_std_17)
target_link_libraries(HomeworkLLVM "$<$<PLATFORM_ID:Darwin>:-undefined dynamic_lookup>" ${llvm_libs})


# =============================
#  扫描 assign2-tests/*.c
# =============================
file(GLOB TEST_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/assign2-tests/*.c")

set(BC_OUTPUTS "")  # 存储所有生成的 .bc 文件名字

foreach(TEST_FILE ${TEST_SOURCES})
    get_filename_component(TEST_NAME ${TEST_FILE} NAME_WE)

    set(BC_FILE "${CMAKE_CURRENT_BINARY_DIR}/${TEST_NAME}.bc")
    list(APPEND BC_OUTPUTS ${BC_FILE})

    add_custom_command(
        OUTPUT ${BC_FILE}
        COMMAND clang -O0 -g3 -flto -emit-llvm -c ${TEST_FILE} -o ${BC_FILE}
        DEPENDS ${TEST_FILE}
        COMMENT "Generating ${BC_FILE}"
        VERBATIM
    )
endforeach()

# 创建一个 target，执行 make testcases 就会生成所有 .bc
add_custom_target(testcases ALL DEPENDS ${BC_OUTPUTS})

# 让 ctest 执行 HomeworkLLVM 处理所有 .bc
foreach(BC ${BC_OUTPUTS})
    get_filename_component(TEST_NAME ${BC} NAME_WE)
    add_test(
        NAME run_${TEST_NAME}
        COMMAND "${CMAKE_CURRENT_BINARY_DIR}/HomeworkLLVM" "${BC}"
    )
endforeach()

message(WARNING "ctest通过仅代表你的程序可以正常退出，使用ctest -V查看你的程序输出")
    add_test(
        NAME please-use-v-argument-for-ctest
        COMMAND false "这个测试永远失败，请忽略"
    )

install(TARGETS HomeworkLLVM DESTINATION "${CMAKE_INSTALL_PREFIX}/bin")

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)
