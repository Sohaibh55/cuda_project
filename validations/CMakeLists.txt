cmake_minimum_required(VERSION 4.4.3)


project(GPU_VERSION CXX CUDA)


set(CMAKE_CUDA_ARCHITECTURES 89)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CUDA_STANDARD 11)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(CUDAToolkit REQUIRED)

add_executable(valid correctness.cu main_val.cpp ../src/utils.cpp ../src/cpu/nbody_cpu.cpp ../src/gpu/nbody_gpu.cu)


target_link_libraries(valid PRIVATE CUDA::cudart)

target_include_directories(valid PRIVATE ../include ../src/cpu/ ../src/gpu/ )

target_compile_definitions(valid PRIVATE INPUT_PATH="${CMAKE_SOURCE_DIR}/../test/")
