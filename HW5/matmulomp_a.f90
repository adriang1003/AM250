! File: matmulomp_a.f90
! Author: Adrian Garcia
! Date: 5/30/2023
! Purpose: Uses do loops and OpenMP PARALLEL DO to do matrix multiplication
program matmulomp_a
    implicit none
    integer, parameter  :: N = 100
    real(kind = kind(0.d0)), dimension(N, N) :: A, B, C
    real(kind = kind(0.d0)) :: r, start_time, end_time, forloop_time 
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
    do i = 1, N
        do j = 1, N
            do k = 1, N
                C(i, j) = C(i, j) + A(i, k)*B(k, j)
            enddo
        enddo
    enddo
    end_time = OMP_GET_WTIME()
    forloop_time = end_time - start_time
    write(*,*) 'Do Loop Performance: ', forloop_time, ' sec'
    start_time = OMP_GET_WTIME()
    !$OMP PARALLEL DO PRIVATE(i, j, k) SHARED(A, B, C)
    do i = 1, N
        do j = 1, N
            do k = 1, N
                C(i, j) = C(i, j) + A(i, k)*B(k, j)
            enddo
        enddo
    enddo
    !$OMP END PARALLEL DO
    end_time = OMP_GET_WTIME()
    forloop_time = end_time - start_time
    write(*,*) 'OMP Do Performance:  ', forloop_time, ' sec'
end program matmulomp_a
