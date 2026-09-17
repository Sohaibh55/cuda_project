
#include "header_cpu.h"

BenchResult benchmark(const vector<particle>& initial) {
    BenchResult result{initial.size(), TIMESTEPS, {}};
    result.times_us.reserve(NUM_RUNS);

    for (int run = 0; run < NUM_RUNS; run++) {
        vector<particle> particles = initial;
        auto start = chrono::steady_clock::now();
        for (size_t step = 0; step < TIMESTEPS; step++) {
            calculate_accelerations( particles);
            integrate(particles);
        }
        auto end = chrono::steady_clock::now();
        result.times_us.push_back(
            chrono::duration_cast<chrono::microseconds>(end - start).count());
    }
    return result;
}



