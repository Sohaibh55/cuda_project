cmake_minimum_required(VERSION 4.4.3)

project(CPU_VERSION CXX)



set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED on)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


add_executable(main bench_cpu.cpp nbody_cpu.cpp main_cpu.cpp ../utils.cpp)

target_include_directories(main PRIVATE ../../include) 

target_compile_definitions(main PRIVATE OUTPUT_PATH="${CMAKE_SOURCE_DIR}/../../benchmarks/result_cpu.csv")
target_compile_definitions(main PRIVATE INPUT_PATH="${CMAKE_SOURCE_DIR}/../../test/")