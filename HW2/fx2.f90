! File: fx2.f90
! Author: Adrian Garcia
! Date: 04/15/2023
! Purpose: Defines function x^2
function fx2(x)
    implicit none
    real(kind = kind(0.d0)) :: fx2, x
    fx2 = x**2
end function fx2
