cmake_minimum_required(VERSION 4.4.3)

project(GPU_VERSION CXX CUDA)

set(CMAKE_CUDA_ARCHITECTURES 89)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CUDA_STANDARD 11)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(main bench_gpu.cu nbody_gpu.cu main_gpu.cu ../utils.cpp)

target_include_directories(main PRIVATE ../../include)

target_compile_definitions(main PRIVATE OUTPUT_PATH="${CMAKE_SOURCE_DIR}/../../benchmarks/result_gpu.csv")
target_compile_definitions(main PRIVATE INPUT_PATH="${CMAKE_SOURCE_DIR}/../../test/")