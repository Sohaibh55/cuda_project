#include "kernel.cuh"




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
            const auto initial = loadParticles(file);
            
            const auto result_acc_int = benchmarking_accelerations_integration(initial);
            appendCsv(out, result_acc_int);

            // const auto result_acc = benchmarking_accelerations(initial);
            // appendCsv(csv, result_acc_int);
           
        } catch (const exception& e) {
            cerr << "skipping " << file << ": " << e.what() << '\n';
        }
      
    }
}
