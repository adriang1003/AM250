! File: trap.f90
! Author: Adrian Garcia
! Date: 04/15/2023
! Input(s): Starting point a, ending point b, arbitrary function, number of steps
! Output(s): Numerical integration of func from a to b
! Purpose: Implements Trapezoidal rule to numerically integrate an arbitrary function between points a and b
subroutine trapRule(a, b, func, sol, N)
    implicit none
    integer :: N
    real(kind = kind(0.d0)) :: a, b, func, sol
    real(kind = kind(0.d0)), dimension(N + 1) :: x
    integer :: i, k
    real(kind = kind(0.d0)) :: dx, val
    external func
    ! Find step size
    dx = (b - a)/N
    ! Initialize x
    do i = 0, N
        x(i + 1) = a + dx*i
    enddo
    ! Initialize val
    val = 0.0
    do k = 2, N + 1
        val = val + func(x(k - 1)) + func(x(k))
    enddo
    ! Implement Trapezoidal rule (uniform grid version)
    sol = val*(dx/2)
end subroutine trapRule
