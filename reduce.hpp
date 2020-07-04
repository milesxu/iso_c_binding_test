#include <cstddef>

class ReduceWorker {
public:
  ReduceWorker() {}
  ~ReduceWorker() {}

  int testPrint(int c) const;
  float reduce_std(float *arr, size_t length) const;
  int reduce_cuda(int *arr, size_t length) const;
  float reduce_cuda_float(float *arr, size_t length) const;
};