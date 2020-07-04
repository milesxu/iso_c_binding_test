interface
    function create_reduce_worker_c() bind(C, name="create_reduce_worker")
        use, intrinsic :: iso_c_binding
        implicit none
        type(c_ptr) :: create_reduce_worker_c
    end function

    subroutine delete_reduce_worker_c(worker) &
        bind(C, name="delete_reduce_worker")
        use, intrinsic :: iso_c_binding
        implicit none
        type(c_ptr), value :: worker
    end subroutine

    function test_print_c(worker, c) bind(C, name="test_print")
        use, intrinsic :: iso_c_binding
        implicit none
        type(c_ptr), intent(in), value :: worker
        integer(c_int), value :: c
        integer(c_int) :: test_print_c
    end function

    function reduce_c(worker, arr, N) bind(C, name="reduce_c")
        use, intrinsic :: iso_c_binding
        implicit none
        type(c_ptr), intent(in), value :: worker, arr
        integer(c_size_t), intent(in), value :: N
        real(c_float) :: reduce_c
    end function

    function reduce_cuda_c_int(worker, arr, N) bind(C, name="reduce_cuda_int")
        use, intrinsic :: iso_c_binding
        implicit none
        type(c_ptr), intent(in), value :: worker, arr
        integer(c_size_t), intent(in), value :: N
        integer(c_int) :: reduce_cuda_c_int
    end function

    function reduce_cuda_c_float(worker, arr, N) &
        bind(C, name="reduce_cuda_float")
        use, intrinsic :: iso_c_binding
        implicit none
        type(c_ptr), intent(in), value :: worker, arr
        integer(c_size_t), intent(in), value :: N
        real(c_float) :: reduce_cuda_c_float
    end function
end interface