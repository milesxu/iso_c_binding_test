program main
    use lib_reduce
    implicit none
    type(reduce_worker) :: worker
    integer, parameter :: N = 10240
    integer, parameter :: k = 1, l = 50000
    real, Dimension(:), allocatable :: X
    integer, Dimension(:), allocatable :: Y

    worker = reduce_worker(1023, "xb", .TRUE.)
    write(*,*) worker%test_print(1023), " and ", 25

    allocate(X(N))
    call RANDOM_NUMBER(X)
    ! X = .10239
    write(*,*) SUM(X)
    write(*,*) worker%reduce_cpp_float(X, int(N, kind=8))
    write(*,*) worker%reduce_cuda_cpp_float(X, int(N, kind=8))

    allocate(Y(N))
    Y = k + FLOOR((l + k - 1) * X)
    write(*,*) SUM(Y)
    write(*,*) worker%reduce_cuda_cpp_int(Y, int(N, kind=8))

#ifdef __GNUC__
    call worker%delete()
#endif
end program