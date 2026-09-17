
#include "kernel.cuh"


BenchResult benchmarking_accelerations(const vector<particle>& particles_cpu) {
    int n = particles_cpu.size();
    size_t size = n * sizeof(particle);
    particle* particles_gpu = nullptr;

    CHECK_CUDA(cudaMalloc(&particles_gpu, size)); 
    CHECK_CUDA(cudaMemcpy(particles_gpu, particles_cpu.data(), size, cudaMemcpyHostToDevice));

    int threads = 256; 
    int blocks = (n + threads - 1) / threads;

    // 72 MB to flush a 48 MB L2 cache
    size_t sizeBuffer = static_cast<size_t>(1024ULL * 1024ULL * 48ULL * 1.5);
    size_t bufferElements = sizeBuffer / sizeof(float);
    float* buffer_gpu = nullptr;
    CHECK_CUDA(cudaMalloc(&buffer_gpu, sizeBuffer));
    CHECK_CUDA(cudaMemset(buffer_gpu, 0, sizeBuffer));

    int flushthreads = 256;
    int flushblocks = (bufferElements + flushthreads - 1) / flushthreads; 

    // Warm-up
    for (int i = 0; i < WARMUP_RUNS; i++) {
        calculate_accelerations_kernel<<<blocks, threads>>>(particles_gpu, n);
    }
    CHECK_CUDA(cudaDeviceSynchronize());

    BenchResult result = { particles_cpu.size(), TIMESTEPS, {} };
    result.times_us.reserve(NUM_RUNS);
    cudaEvent_t start, stop;
    CHECK_CUDA(cudaEventCreate(&start));
    CHECK_CUDA(cudaEventCreate(&stop));

    for (int i = 0; i < NUM_RUNS; i++) {
        flushKernel<<<flushblocks, flushthreads>>>(buffer_gpu, bufferElements);

        CHECK_CUDA(cudaEventRecord(start));
        for(unsigned int t = 0 ; t < TIMESTEPS ; t++) {
        calculate_accelerations_kernel<<<blocks, threads>>>(particles_gpu, n);
        }
        CHECK_CUDA(cudaEventRecord(stop));
        CHECK_CUDA(cudaEventSynchronize(stop));

        float elapsed_time_ms = 0.0f;
        CHECK_CUDA(cudaEventElapsedTime(&elapsed_time_ms, start, stop));
        result.times_us.push_back(elapsed_time_ms); // = elapsed_time_ms * 1000.0f; // ms to us

        

        // Prevent dead-code elimination / ensure completion
        particle first_particle;
        CHECK_CUDA(cudaMemcpy(&first_particle, particles_gpu, sizeof(first_particle), cudaMemcpyDeviceToHost));    

    
    }

    CHECK_CUDA(cudaEventDestroy(start));
    CHECK_CUDA(cudaEventDestroy(stop));
    
    CHECK_CUDA(cudaFree(particles_gpu));
    CHECK_CUDA(cudaFree(buffer_gpu));

    return result;
}
BenchResult benchmarking_accelerations_integration(const vector<particle>& particles_cpu) {
   
    int n = particles_cpu.size();
    size_t size = n * sizeof(particle);
    particle* particles_gpu = nullptr;


    CHECK_CUDA(cudaMalloc(&particles_gpu, size)); 
    CHECK_CUDA(cudaMemcpy(particles_gpu, particles_cpu.data(), size, cudaMemcpyHostToDevice));

    int threads = 256; 
    int blocks = (n + threads - 1) / threads;

    // 72 MB to flush a 48 MB L2 cache
    size_t sizeBuffer = static_cast<size_t>(1024ULL * 1024ULL * 48ULL * 1.5);
    size_t bufferElements = sizeBuffer / sizeof(float);
    float* buffer_gpu = nullptr;
    CHECK_CUDA(cudaMalloc(&buffer_gpu, sizeBuffer));
    CHECK_CUDA(cudaMemset(buffer_gpu, 0, sizeBuffer));

    int flushthreads = 256;
    int flushblocks = (bufferElements + flushthreads - 1) / flushthreads; 

    // Warm-up
    for (int i = 0; i < WARMUP_RUNS; i++) {
        calculate_accelerations_kernel<<<blocks, threads>>>(particles_gpu, n);
    }
    CHECK_CUDA(cudaDeviceSynchronize());

    BenchResult result = { particles_cpu.size(), TIMESTEPS, {} };
    result.times_us.resize(NUM_RUNS);

    cudaEvent_t start, stop;
    CHECK_CUDA(cudaEventCreate(&start));
    CHECK_CUDA(cudaEventCreate(&stop));

    for (int i = 0; i < NUM_RUNS; i++) {
        flushKernel<<<flushblocks, flushthreads>>>(buffer_gpu, bufferElements);

        CHECK_CUDA(cudaEventRecord(start));
        for(unsigned int t = 0 ; t < TIMESTEPS ; t++) {
        calculate_accelerations_kernel<<<blocks, threads>>>(particles_gpu, n);
        integrate_kernel<<<blocks, threads>>>(particles_gpu ,n );
        }
        CHECK_CUDA(cudaEventRecord(stop));
        CHECK_CUDA(cudaEventSynchronize(stop));

        float elapsed_time_ms = 0.0f;
        CHECK_CUDA(cudaEventElapsedTime(&elapsed_time_ms, start, stop));
        result.times_us.push_back(elapsed_time_ms * 1000.0f);  

        

        // Prevent dead-code elimination / ensure completion
        particle first_particle;
        CHECK_CUDA(cudaMemcpy(&first_particle, particles_gpu, sizeof(first_particle), cudaMemcpyDeviceToHost));    

    }

  
    CHECK_CUDA(cudaEventDestroy(start));
    CHECK_CUDA(cudaEventDestroy(stop));
    
    CHECK_CUDA(cudaFree(particles_gpu));
    CHECK_CUDA(cudaFree(buffer_gpu));

    return result;
}

