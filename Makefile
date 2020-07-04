FC = gfortran
CXX = g++
NVCC = /opt/cuda/bin/nvcc

FCFLAGS = -Wall -Wextra -cpp
CCFLAGS = -Wall -Wextra -std=c++17 -I/opt/cuda/include
CUFLAGS = -arch=sm_70 -I/home/milesx/src/cub-1.8.0
LDFLAGS = -lstdc++ -L/opt/cuda/lib64 -lcudart

all: main.x
main.o : reduce.o

%.x : %.o lib_reduce.o interface_capi.o reduce.o reduce_gpu.o gpu_code.o
	${FC} $^ -o $@ ${LDFLAGS}

%.o : %.f90
	${FC} ${FCFLAGS} -c $< -o $@

%.o : %.cpp
	${CXX} ${CCFLAGS} -c $^ -o $@

%.o : %.cu
	${NVCC} ${CUFLAGS} -c $< -o $@

gpu_code.o : reduce_gpu.o
	${NVCC} -arch=sm_70 -dlink reduce_gpu.o -o $@

.PHONY : clean

clean:
	${RM} -rf *.o *.mod test.x