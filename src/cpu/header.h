
#pragma once

#include <vector>
#include <string>
#include <fstream>
#include <sstream>
#include <iostream>
#include <cmath>
#include <stdexcept>
#include <numeric>
#include <chrono>

using namespace std;

struct particle {
    float x, y, z, Vx, Vy, Vz, ax, ay, az, mass;
};
constexpr float epsilon = 1e-3f; 

// benchmarking
constexpr int    NUM_RUNS  = 20;
constexpr size_t TIMESTEPS = 100;
constexpr float  G_CONST   = 1.0f;
constexpr float  DELTA_T   = 0.01f;

struct BenchResult {
    size_t n_particles;
    size_t timesteps;
    vector<long long> times_us;
};


// bench.cpp
vector<particle> loadParticles(const string& filename);
BenchResult benchmark(const vector<particle>& initial);
void appendCsv(ofstream& out, const BenchResult& res);




// nbody.cpp
void r(particle A,particle B,float *r_vector);

float softned_squared_dis(const float *r_vector);

float inverse_d_3(const float& d_2);

void initial_acceleration(particle& A);

void acceleration(float* r_vector, particle& A,particle& B);
    
void update_velocity(particle& A);

void update_position(particle& A);

void integrate(vector<particle>&  particles );

void calculate_accelerations( vector<particle>& particles);

void display(const vector<particle>& P);

void readParticles(istream& in,vector<particle>& Particles);



