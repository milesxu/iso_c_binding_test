#include <stddef.h>
#ifdef __cplusplus
extern "C" {
class ReduceWorker;
typedef ReduceWorker ReduceWorker_t;
#else
typedef struct ReduceWorker_t ReduceWorker_t;
#endif

// constructor
ReduceWorker_t *create_reduce_worker();

// destructor
void delete_reduce_worker(ReduceWorker_t *worker);

int test_print(const ReduceWorker_t *worker, int c);

float reduce_c(const ReduceWorker_t *worker, float *arr, size_t length);

int reduce_cuda_int(const ReduceWorker_t *worker, int *arr, size_t length);

float reduce_cuda_float(const ReduceWorker_t *worker, float *arr,
                        size_t length);

#ifdef __cplusplus
}
#endif