#include "header.h"
#include <chrono>



vector<particle> loadParticles(const string& filename) {
    ifstream in(filename);
    if (!in) throw runtime_error("could not open " + filename);
   
    vector<particle> particles;
    readParticles(in, particles);
    return particles;
}



BenchResult benchmark(const vector<particle>& initial) {
    BenchResult result{initial.size(), TIMESTEPS, {}};
    result.times_us.reserve(NUM_RUNS);

    for (int run = 0; run < NUM_RUNS; run++) {
        vector<particle> particles = initial;
        auto start = chrono::steady_clock::now();
        for (size_t step = 0; step < TIMESTEPS; step++) {
            calculate_accelerations(G_CONST, particles);
            integrate(DELTA_T, particles);
        }
        auto end = chrono::steady_clock::now();
        result.times_us.push_back(
            chrono::duration_cast<chrono::milliseconds>(end - start).count());
    }
    return result;
}



void appendCsv(ofstream& out, const BenchResult& res) {
    for (long long t : res.times_us)
        out << res.n_particles << ',' << res.timesteps << ',' << t << '\n';
}
