! File: mainTrap.f90
! Author: Adrian Garcia
! Date: 04/15/2023
! Purpose: Driver file for trap.f90
program mainTrap
    implicit none
    integer :: N
    real(kind = kind(0.d0)) :: a, b, sol, fx2, fsinx
    external fx2, fsinx
    write(*,*) 'a = '
    read(*,*) a
    write(*,*) 'b = '
    read(*,*) b
    write(*,*) 'N = '
    read(*,*) N
    ! Function call for x^2
    call trapRule(a, b, fx2, sol, N)
    write(*,*) 'x^2 solution = ', sol
    ! Function call for sin(x)
    call trapRule(a, b, fsinx, sol, N)
    write(*,*) 'sin(x) solution = ', sol
end program mainTrap
