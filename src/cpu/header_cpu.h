#pragma once

#include <types.hpp>
#include <utils.hpp>

// bench.cpp
BenchResult benchmark(const vector<particle>& initial);

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



