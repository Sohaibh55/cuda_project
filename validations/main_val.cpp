
#include "correctness.cuh"


int main(int argc, char* argv[]){


   if(argc < 2) 
    { 
        cerr<<"Usage :"<<argv[0]<<"<file1> [file2] ..\n"; 
        return -1; 
    }


    vector<string> input_files;
    for (int i = 1; i < argc; i++)
        input_files.push_back(string(INPUT_PATH) + "/" + argv[i]);

    
    for (const auto& file : input_files) {
        
        try {
            const auto particle_cpu = loadParticles(file);    
            Error err = check_correctness(particle_cpu);

            cout<<"The merge err for x is :"<<err.x<<endl; 
            cout<<"The merge err for y is :"<<err.y<<endl; 
            cout<<"The merge err for z is :"<<err.z<<endl; 
            
        } catch (const exception& e) {
            cerr << "skipping " << file << ": " << e.what() << '\n';
        }
    }
}