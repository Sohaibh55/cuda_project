
#pragma once

#include <vector>
#include <string>
#include <sstream>
#include <iostream>
#include <cmath>
#include <stdexcept>
#include <numeric>
#include <chrono>
#include <string>
#include <fstream>

using namespace std;

struct particle {
    float x, y, z, Vx, Vy, Vz, ax, ay, az, mass;
};
constexpr float epsilon = 1e-3f; 

// benchmarking
constexpr unsigned int    NUM_RUNS  = 20;
constexpr unsigned int TIMESTEPS = 100;
constexpr float  G_CONST   = 1.0f;
constexpr float  DELTA_T   = 0.01f;

struct BenchResult {
    size_t n_particles;
    size_t timesteps;
    vector<float> times_us;
};
