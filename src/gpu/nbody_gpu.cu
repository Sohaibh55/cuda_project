
#include "kernel.cuh"

__global__ void calculate_accelerations_kernel(particle* particles , int n ) {
    
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
   
    if( idx < n) {
        // initialise the acceleration
        particles[idx].ax = 0;
        particles[idx].ay = 0;
        particles[idx].az = 0;

        // compute accelaration for all the particules 
        for (int j = 0; j < n; j++)
        {
            if( idx == j) continue;

            float rx = particles[j].x  - particles[idx].x ;
            float ry = particles[j].y - particles[idx].y ;
            float rz = particles[j].z - particles[idx].z ;

            float sft_squard_dis = rx * rx + ry * ry + rz *rz + epsilon * epsilon;

            float inverse_d_3 = float( 1 / (sft_squard_dis * sqrt( sft_squard_dis) ));

            particles[idx].ax += G_CONST * particles[j].mass * rx * inverse_d_3;
            particles[idx].ay += G_CONST * particles[j].mass * ry * inverse_d_3;
            particles[idx].az += G_CONST * particles[j].mass * rz * inverse_d_3;
        }
    }

   
}


__global__ void integrate_kernel(particle* particles , int n ) {

    int idx = blockDim.x * blockIdx.x + threadIdx.x;

    if( idx < n) {
        particles[idx].Vx += particles[idx].ax * DELTA_T;
        particles[idx].Vy += particles[idx].ay * DELTA_T;
        particles[idx].Vz  += particles[idx].az * DELTA_T;
    
        particles[idx].x += particles[idx].Vx * DELTA_T;
        particles[idx].y += particles[idx].Vy * DELTA_T;
        particles[idx].z  += particles[idx].Vz * DELTA_T;
    

    }
}
__global__ void flushKernel(float* buffer ,int n) {
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    if ( idx < n) 
        buffer[idx] = idx * 1.0001f;
}
