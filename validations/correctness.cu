#include "correctness.cuh"

// Error compare(const vector<particle>& particle_cpu, const vector<particle>& particle_gpu) {
//     Error err = {0.0f, 0.0f, 0.0f};

//     for (size_t i = 0; i < particle_cpu.size(); i++) {
//         float dx = fabs(particle_cpu[i].x - particle_gpu[i].x);
//         float dy = fabs(particle_cpu[i].y - particle_gpu[i].y);
//         float dz = fabs(particle_cpu[i].z - particle_gpu[i].z);

//         err.x = max(err.x, dx);
//         err.y = max(err.y, dy);
//         err.z = max(err.z, dz);
//     }

//     return err;
// }

// Error check_correctness(vector<particle> particle_cpu) {
//     int n = particle_cpu.size();
//     size_t size = n * sizeof(particle);

//     vector<particle> particle_gpu_result(n);
//     particle* particle_gpu;

//     CHECK_CUDA(cudaMalloc(&particle_gpu, size));
//     // Copy must happen before the host mutates particle_cpu below
//     CHECK_CUDA(cudaMemcpy(particle_gpu, particle_cpu.data(), size, cudaMemcpyHostToDevice));

//     int threads = 256;
//     int blocks = (n + threads - 1) / threads;
    
//     for (int i = 0; i < TIMESTEPS; i++)
//     {
//         calculate_accelerations_kernel<<<blocks, threads>>>(particle_gpu, n);
//         integrate_kernel<<<blocks, threads>>>(particle_gpu, n);
//         CHECK_CUDA(cudaGetLastError());
//     }
    
    
//     CHECK_CUDA(cudaGetLastError());
//     CHECK_CUDA(cudaDeviceSynchronize());

//     CHECK_CUDA(cudaMemcpy(particle_gpu_result.data(), particle_gpu, size, cudaMemcpyDeviceToHost));
//     cudaFree(particle_gpu);

//     // CPU reference computation (mutates particle_cpu, safe now that the copy is done)
//     for (int i = 0; i < TIMESTEPS; i++)
//     {
//         calculate_accelerations(particle_cpu);
//         integrate(particle_cpu);
//     }
    
    

//     Error err = compare(particle_cpu, particle_gpu_result);
//     return err;
// }

Error compare(const vector<particle>& particle_cpu,
              const vector<particle>& particle_gpu)
{
    Error err = {0.0f, 0.0f, 0.0f};

    for (size_t i = 0; i < particle_cpu.size(); i++) {
        float dx = fabs(particle_cpu[i].x - particle_gpu[i].x);
        float dy = fabs(particle_cpu[i].y - particle_gpu[i].y);
        float dz = fabs(particle_cpu[i].z - particle_gpu[i].z);

        err.x = max(err.x, dx);
        err.y = max(err.y, dy);
        err.z = max(err.z, dz);
    }

    return err;
}


Error check_correctness(vector<particle> particle_cpu) {

    int n = particle_cpu.size();
    size_t size = n * sizeof(particle);

    vector<particle> particle_gpu_result(n);
    particle* particle_gpu = nullptr;

    CHECK_CUDA(cudaMalloc(&particle_gpu, size));

    CHECK_CUDA(cudaMemcpy(
        particle_gpu,
        particle_cpu.data(),
        size,
        cudaMemcpyHostToDevice
    ));

    int threads = 256;
    int blocks = (n + threads - 1) / threads;

    Error err{};

    for (int i = 0; i < TIMESTEPS; i++)
    {
        // ---------------- GPU ----------------

        calculate_accelerations_kernel<<<blocks, threads>>>(
            particle_gpu, n
        );

        integrate_kernel<<<blocks, threads>>>(
            particle_gpu, n
        );

        CHECK_CUDA(cudaGetLastError());
        CHECK_CUDA(cudaDeviceSynchronize());

        CHECK_CUDA(cudaMemcpy(
            particle_gpu_result.data(),
            particle_gpu,
            size,
            cudaMemcpyDeviceToHost
        ));

        // ---------------- CPU ----------------

        calculate_accelerations(particle_cpu);
        integrate(particle_cpu);

        // ---------------- Compare ----------------

        err = compare(
            particle_cpu,
            particle_gpu_result
        );

        cout << "Timestep " << i + 1
             << " : "
             << "x = " << err.x
             << ", y = " << err.y
             << ", z = " << err.z
             << '\n';
    }

    CHECK_CUDA(cudaFree(particle_gpu));

    return err;
}