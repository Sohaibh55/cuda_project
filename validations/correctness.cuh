#pragma once


#include <header_cpu.h>
#include <kernel.cuh>
#include <limits.h>


struct Error {
    float x;
    float y;
    float z;
};


Error compare(const vector<particle>& particle_cpu, const vector<particle>& particle_gpu);
Error check_correctness(vector<particle> particle_cpu);