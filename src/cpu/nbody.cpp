

#include "header.h"

void r(particle A,particle B,float *r_vector) {
      
        r_vector[0] = B.x - A.x;
        r_vector[1] = B.y - A.y;
        r_vector[2] = B.z - A.z;
}
float softned_squared_dis(const float *r_vector) {

    return r_vector[0] * r_vector[0] + r_vector[1] *r_vector[1] + r_vector[2] * r_vector[2] + epsilon * epsilon;
}

float inverse_d_3(const float& d_2) {
    return float( 1 / (d_2 * sqrt(d_2)) );
}

void initial_acceleration(particle& A) {
    A.ax = 0;
    A.ay = 0;
    A.az = 0;
}

void acceleration(const float &G ,float* r_vector, particle& A,particle& B){

    
    r(A,B,r_vector);

    float d_2 = softned_squared_dis(r_vector);
    float inv_d_3 = inverse_d_3(d_2);

    A.ax += G * B.mass * r_vector[0] * inv_d_3; 
    A.ay += G * B.mass * r_vector[1] * inv_d_3; 
    A.az += G * B.mass * r_vector[2] * inv_d_3; 

}
    
void update_velocity(particle& A ,const float& delta_t) {

    A.Vx += A.ax * delta_t ;
    A.Vy += A.ay * delta_t ;
    A.Vz += A.az * delta_t ;
}

void update_position(particle& A ,const float& delta_t) {
    A.x += A.Vx * delta_t;
    A.y += A.Vy * delta_t;
    A.z += A.Vz * delta_t;
}

void integrate(const float& delta_t,vector<particle>&  particles ) {

    size_t N = particles.size();

    for(size_t i = 0 ; i < N; i++) 
        update_velocity(particles[i],delta_t);
    for(size_t i = 0 ; i < N; i++) 
        update_position(particles[i],delta_t);   
}

void calculate_accelerations(const float &G, vector<particle>& particles){
    
    size_t N = particles.size();
    float r_vector[3];
    for(size_t i = 0 ; i < N; i++) {

       
        initial_acceleration(particles[i]);

        for(size_t j = 0 ; j < N ; j++) {
         
            if(i == j) continue;

            acceleration(G, r_vector , particles[i], particles[j]);   
        }
    }    
}



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
 
void display(const vector<particle>& P) {

    int i=0;
    for (particle p : P) {
        cout<<"Particle "<<i<<": "<<"pos("<<p.x<<","<<p.y<<","<<p.z<<") vel("<<p.Vx<<","<< p.Vy<<","<< p.Vz<<") mass="<<p.mass<<endl;
        i++;
    }

}

