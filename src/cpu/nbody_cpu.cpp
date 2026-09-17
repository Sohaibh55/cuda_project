

#include "header_cpu.h"


void initial_acceleration(particle& A) {
    A.ax = 0;
    A.ay = 0;
    A.az = 0;
}

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

void acceleration(float* r_vector, particle& A,particle& B){

    
    r(A,B,r_vector);

    float d_2 = softned_squared_dis(r_vector);
    float inv_d_3 = inverse_d_3(d_2);

    A.ax += G_CONST * B.mass * r_vector[0] * inv_d_3; 
    A.ay += G_CONST * B.mass * r_vector[1] * inv_d_3; 
    A.az += G_CONST * B.mass * r_vector[2] * inv_d_3; 

}
    
void update_velocity(particle& A ) {

    A.Vx += A.ax * DELTA_T ;
    A.Vy += A.ay * DELTA_T ;
    A.Vz += A.az * DELTA_T ;
}

void update_position(particle& A) {
    A.x += A.Vx * DELTA_T;
    A.y += A.Vy * DELTA_T;
    A.z += A.Vz * DELTA_T;
}

void integrate(vector<particle>&  particles ) {

    size_t N = particles.size();

    for(size_t i = 0 ; i < N; i++) 
        update_velocity(particles[i]);
    for(size_t i = 0 ; i < N; i++) 
        update_position(particles[i]);   
}

void calculate_accelerations(vector<particle>& particles){
    
    size_t N = particles.size();
    float r_vector[3];
    for(size_t i = 0 ; i < N; i++) {

       
        initial_acceleration(particles[i]);

        for(size_t j = 0 ; j < N ; j++) {
         
            if(i == j) continue;

            acceleration( r_vector , particles[i], particles[j]);   
        }
    }    
}





