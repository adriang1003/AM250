! File: pi.f90
! Author: Adrian Garcia
! Date: 05/12/2023
! Purpose: Figures out pi by the "dartboard method" in parallel.
program pi
    implicit none
    include 'mpif.h'
    integer :: ierr, myid, numprocs
    integer :: source, count
    integer :: dartboard, hits, totHits
    integer, parameter :: darts = 1000000
    real(kind = kind(0.d0)), parameter :: truePi = 4*atan(1.d0)
    real(kind = kind(0.d0)) :: apprxPi
    integer :: stat(MPI_STATUS_SIZE)
    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
    !!! MEAT OF THE CODE !!!
    source = 0
    count = 1
    hits = dartboard(darts)
    call MPI_REDUCE(hits, totHits, count, MPI_INTEGER, MPI_SUM, source, MPI_COMM_WORLD, ierr)
    if (myid .eq. source) then
        write(*,*) 'Real value of pi:             ', truePi
        apprxPi = ( 4.0*real(totHits) ) / ( real(darts)*real(numprocs) )
        write(*,*) 'Approximate value of pi:      ', apprxPi
        write(*,*) 'Total number of darts thrown: ', darts*numprocs
    endif
    !!! MEAT OF THE CODE !!!
    call MPI_FINALIZE(ierr)
end program pi
function dartboard(darts)
    implicit none
    integer :: dartboard, darts, hit
    integer :: i
    real(kind = kind(0.d0)) :: x, y
    dartboard = 0
    do i = 1, darts
        call random_number(x)
        call random_number(y)
        if (x**2 + y**2 <= 1.0) then
            hit = 1
        else
            hit = 0
        endif
        dartboard = dartboard + hit
    enddo
end function dartboard
