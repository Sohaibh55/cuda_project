#include "header.h"







int main() {
    const vector<string> files = {
        "/home/SH/cuda/test/data_100.txt",
        "/home/SH/cuda/test/data_500.txt",
        "/home/SH/cuda/test/data_1000.txt",
        "/home/SH/cuda/test/data_2000.txt"
    };

    string output_file = "/home/SH/cuda/benchmarks/result.csv";

    ofstream csv(output_file, ios::trunc);
    csv << "N,timesteps,time_us\n";


    for (const auto& file : files) {
        
        try {
            const auto initial = loadParticles(file);
            const auto result = benchmark(initial);
            appendCsv(csv, result);
           
        } catch (const exception& e) {
            cerr << "skipping " << file << ": " << e.what() << '\n';
        }
    }

}
