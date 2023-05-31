! File: matmulomp_b.f90
! Author: Adrian Garcia
! Date: 5/30/2023
! Purpose: Uses matmul and OpenMP workshare to do matrix multiplication
program matmulomp_b
    implicit none
    integer, parameter  :: N = 100
    real(kind = kind(0.d0)), dimension(N, N) :: A, B, C
    real(kind = kind(0.d0)) :: r, start_time, end_time, matmul_time 
    real(kind = kind(0.d0)) :: OMP_GET_WTIME
    integer :: i, j, k
    A = 0
    B = 0
    C = 0
    do i = 1, N
        do j = 1, N
            call random_number(r)
            A(i, j) = r
            B(i, j) = r**2
        enddo
    enddo
    start_time = OMP_GET_WTIME()
    C = matmul(A, B)
    end_time = OMP_GET_WTIME()
    matmul_time = end_time - start_time
    write(*,*) 'MATMUL Performance:         ', matmul_time, ' sec'
    start_time = OMP_GET_WTIME()
    !$OMP PARALLEL WORKSHARE
    C = matmul(A, B)
    !$OMP END PARALLEL WORKSHARE
    end_time = OMP_GET_WTIME()
    matmul_time = end_time - start_time
    write(*,*) 'OMP WORKSHARE Performance:  ', matmul_time, ' sec'
end program matmulomp_b
