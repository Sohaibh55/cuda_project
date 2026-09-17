
#pragma once

#include <cuda_runtime.h>
#include <utils.hpp>
#include <types.hpp>

constexpr int WARMUP_RUNS = 30 ;

#define CHECK_CUDA(call) do { \
    cudaError_t err = call; \
    if (err != cudaSuccess) { \
    fprintf(stderr, "Erreur CUDA %s:%d: %s\n", \
    __FILE__, __LINE__, cudaGetErrorString(err)); \
    exit(EXIT_FAILURE); \
    } \
} while(0)




__global__ void calculate_accelerations_kernel(particle* particles , int n );
__global__ void integrate_kernel(particle* particles , int n );
__global__ void flushKernel(float* buffer ,int n);
BenchResult benchmarking_accelerations(const vector<particle>& particles_cpu);
BenchResult benchmarking_accelerations_integration(const vector<particle>& particles_cpu);

