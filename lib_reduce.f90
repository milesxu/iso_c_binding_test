module lib_reduce
    use, intrinsic :: iso_c_binding

    private
    public :: reduce_worker, reduce_f

    include "reduce_worker_cdef.f90"

    type reduce_worker
        private
        type(c_ptr) :: ptr
        contains
#ifdef __GNUC__
        procedure :: delete => delete_reduce_worker_polymorph
#endif
        final :: delete_reduce_worker

        procedure :: test_print => test_print_f
        procedure :: reduce_cpp_float
        procedure :: reduce_cuda_cpp_int
        procedure :: reduce_cuda_cpp_float
    end type

    interface reduce_worker
        procedure create_reduce_worker
    end interface

    contains
        function create_reduce_worker()
            implicit none
            type(reduce_worker) :: create_reduce_worker
            create_reduce_worker%ptr = create_reduce_worker_c()
        end function

        integer function test_print_f(this, c)
            implicit none
            class(reduce_worker), intent(in) :: this
            integer, intent(in) :: c
            test_print_f = test_print_c(this%ptr, c)
        end function

        subroutine delete_reduce_worker_polymorph(this)
            implicit none
            class(reduce_worker) :: this
            call delete_reduce_worker_c(this%ptr)
        end subroutine

        subroutine delete_reduce_worker(this)
            implicit none
            type(reduce_worker) :: this
            call delete_reduce_worker_c(this%ptr)
        end subroutine

        real function reduce_cpp_float(this, X, N)
            implicit none
            class(reduce_worker), intent(in) :: this
            integer(c_size_t), intent(in) :: N
            real, target, dimension(N) :: X
            type(c_ptr) :: arr

            arr = c_loc(X(1))
            reduce_cpp_float = reduce_c(this%ptr, arr, N)
        end function

        integer function reduce_cuda_cpp_int(this, X, N)
            implicit none
            class(reduce_worker), intent(in) :: this
            integer(c_size_t), intent(in) :: N
            integer, target, dimension(N) :: X
            type(c_ptr) :: arr

            arr = c_loc(X(1))
            reduce_cuda_cpp_int = reduce_cuda_c_int(this%ptr, arr, N)
        end function

        real function reduce_cuda_cpp_float(this, X, N)
            implicit none
            class(reduce_worker), intent(in) :: this
            integer(c_size_t), intent(in) :: N
            real, target, dimension(N) :: X
            type(c_ptr) :: arr

            arr = c_loc(X(1))
            reduce_cuda_cpp_float = reduce_cuda_c_float(this%ptr, arr, N)
        end function

        real function reduce_f(X, N)
            implicit none
            integer, intent(in), value :: N
            real, dimension(N), intent(in) :: X
            reduce_f = SUM(X)
        end function
end module