#include "interface.h"
#include "reduce.hpp"

ReduceWorker_t *create_reduce_worker() { return new ReduceWorker(); }

void delete_reduce_worker(ReduceWorker_t *worker) { delete worker; }

int test_print(const ReduceWorker_t *worker, int c) {
  return worker->testPrint(c);
}

float reduce_c(const ReduceWorker_t *worker, float *arr, size_t length) {
  return worker->reduce_std(arr, length);
}

int reduce_cuda_int(const ReduceWorker_t *worker, int *arr, size_t length) {
  return worker->reduce_cuda(arr, length);
}

float reduce_cuda_float(const ReduceWorker_t *worker, float *arr,
                        size_t length) {
  return worker->reduce_cuda_float(arr, length);
}