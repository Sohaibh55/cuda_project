
#pragma once
#include "types.hpp"



void readParticles(istream& in,vector<particle>& Particles);
void display(const std::vector<particle>& particles);
void appendCsv(ofstream& out,const BenchResult& res);
vector<particle> loadParticles(const std::string& filename);
