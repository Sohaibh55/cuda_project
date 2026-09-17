#include "header_cpu.h"


int main(int argc,char* argv[]) {

    if(argc < 2) 
    { 
        cerr<<"Usage :"<<argv[0]<<"<file1> [file2] ..\n"; 
        return -1; 
    }


    vector<string> input_files;
    for (int i = 1; i < argc; i++)
        input_files.push_back(string(INPUT_PATH) + "/" + argv[i]);

    

   string output_file = OUTPUT_PATH;
    ofstream out(output_file,ios::trunc);
    if (!out.is_open()) {
        cerr << "Failed to open " << output_file <<'\n';
        return 1;
    }


    out << "N,timesteps,time_us\n";

    for (const auto& file : input_files) {
        
        try {
            const vector<particle> initial = loadParticles(file);
            const BenchResult result = benchmark(initial);
            appendCsv(out,result);
           
        } catch (const exception& e) {
            cerr << "skipping " << file << ": " << e.what() << '\n';
        }
    }

}
