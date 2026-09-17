#include <utils.hpp>


void readParticles(istream& in,vector<particle>& Particles) {
    
    string line;
 
    while (getline(in, line)) {
        if (line.empty()) continue;
 
        istringstream iss(line);
        particle p{};
        p.ax = 0.0f;
        p.ay = 0.0f;
        p.az = 0.0f;
 
        if (iss >> p.x >> p.y >> p.z >> p.Vx >> p.Vy >> p.Vz >> p.mass) {
            Particles.push_back(p);
        } else {
            cerr << "Skipping malformed line: " << line << "\n";
        }
    }
}
 
vector<particle> loadParticles(const string& filename) {
    ifstream in(filename);
    if (!in) throw runtime_error("could not open " + filename);
   
    vector<particle> particles;
    readParticles(in, particles);
    return particles;
}

void appendCsv(ofstream& out,const BenchResult& res) {
    for (const float& t : res.times_us)
        out << res.n_particles << ',' << res.timesteps << ',' << t << '\n';
}




// remove when i finish the project incha allah 
void display(const vector<particle>& P) {

    int i=0;
    for (particle p : P) {
        cout<<"Particle "<<i<<": "<<"pos("<<p.x<<","<<p.y<<","<<p.z<<") vel("<<p.Vx<<","<< p.Vy<<","<< p.Vz<<") mass="<<p.mass<<endl;
        i++;
    }

}


