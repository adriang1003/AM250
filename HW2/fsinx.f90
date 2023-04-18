! File: fsinx.f90
! Author: Adrian Garcia
! Date: 04/15/2023
! Purpose: Defines function sin(x)
function fsinx(x)
    implicit none
    real(kind = kind(0.d0)) :: fsinx,x
    fsinx = sin(x)
end function fsinx
