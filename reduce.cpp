#include "reduce.hpp"

#include <iostream>
#include <numeric>

#include "reduce_gpu.cuh"

int ReduceWorker::testPrint(int a) const {
  std::cout << "Print in C++, value from Fortran: " << a << std::endl;
  return 0;
}

float ReduceWorker::reduce_std(float *arr, size_t length) const {
  //   return std::reduce<float *>(arr, arr + length);
  return std::accumulate(arr, arr + length, 0.0f);
}

int ReduceWorker::reduce_cuda(int *arr, size_t length) const {
  std::cout << "Reduce using CUDA..." << std::endl;
  return reduce_gpu(arr, length);
}

float ReduceWorker::reduce_cuda_float(float *arr, size_t length) const {
  std::cout << "Reduce using CUB library..." << std::endl;
  return reduce_cub_float(arr, length);
}
