#include <cub/cub.cuh>
#include <cuda_runtime.h>
#include <stdio.h>

const int warp_size = 32;
const unsigned int full_mask = 0xffffffff;

__inline__ __device__ int warpReduce(int val) {
  for (int i = warp_size / 2; i > 0; i /= 2) {
    val += __shfl_down_sync(full_mask, val, i);
  }
  return val;
}

__inline__ __device__ int threadSum(int *d_arr, size_t length,
                                    size_t start_offset, size_t stride) {
  int sum = 0;
  for (size_t i = start_offset; i < length; i += stride) {
    sum += d_arr[i];
  }
  return sum;
}

__global__ void reduce_with_buffer(int *array, size_t length, int *buffer) {
  __shared__ int temp[warp_size];
  const size_t global_id = blockIdx.x * blockDim.x + threadIdx.x;
  const size_t global_dim = blockDim.x * gridDim.x;

  int thread_sum = threadSum(array, length, global_id, global_dim);
  thread_sum = warpReduce(thread_sum);
  const int lane_id = threadIdx.x & 31;
  if (lane_id == 0) {
    const int warp_id = threadIdx.x / warp_size;
    temp[warp_id] = thread_sum;
  }
  // __syncthreads();
  __threadfence_block();

  const int numWarps = blockDim.x / warp_size;
  if (threadIdx.x < warp_size) {
    // thread_sum = threadIdx.x < numWarps ? temp[threadIdx.x] : 0.0f;
    thread_sum = threadSum(temp, numWarps, threadIdx.x, warp_size);
    thread_sum = warpReduce(thread_sum);
    if (threadIdx.x == 0) {
      buffer[blockIdx.x] = thread_sum;
    }
  }
  __syncthreads();

  if (blockIdx.x == 0 && threadIdx.x < warp_size) {
    thread_sum = threadSum(buffer, gridDim.x, threadIdx.x, warp_size);
    thread_sum = warpReduce(thread_sum);
    if (threadIdx.x == 0) {
      buffer[0] = thread_sum;
    }
  }
}

int reduce_gpu(int *arr, size_t length) {
  int *d_arr, *d_buffer;
  cudaMalloc(&d_arr, sizeof(int) * length);
  cudaMemcpyAsync(d_arr, arr, length * sizeof(int), cudaMemcpyDefault);
  const int numBlocks = 32;
  const int numThreads = 128;
  cudaMalloc(&d_buffer, sizeof(int) * numBlocks);
  reduce_with_buffer<<<numBlocks, numThreads>>>(d_arr, length, d_buffer);
  cudaStreamSynchronize(0);
  int result = 0;
  cudaMemcpy(&result, d_buffer, sizeof(int), cudaMemcpyDefault);
  cudaFree(d_arr);
  cudaFree(d_buffer);
  return result;
}

float reduce_cub_float(float *arr, size_t length) {
  float *d_temp{nullptr}, *d_in, *d_out;
  size_t temp_bytes = 0;
  cudaMalloc(&d_in, sizeof(float) * length);
  cudaMalloc(&d_out, sizeof(float));
  cudaMemcpyAsync(d_in, arr, sizeof(float) * length, cudaMemcpyDefault);
  cub::DeviceReduce::Sum(d_temp, temp_bytes, d_in, d_out, length);
  cudaMalloc(&d_temp, temp_bytes);
  cub::DeviceReduce::Sum(d_temp, temp_bytes, d_in, d_out, length);
  float out;
  cudaMemcpy(&out, d_out, sizeof(float), cudaMemcpyDefault);
  cudaFree(d_temp);
  cudaFree(d_in);
  cudaFree(d_out);
  return out;
}