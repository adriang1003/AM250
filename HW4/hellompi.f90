! File: hellompi.f90
! Author: Adrian Garcia
! Date: 05/12/2023
! Purpose: Starts MPI running on a number of processors, and then writes out "Hello" from each processor, 
! stating the processor rank and the size of the comm world.
program hellompi
    implicit none
    include 'mpif.h'
    integer :: ierr, myid, numprocs
    call MPI_INIT(ierr)
    !!! MEAT OF THE CODE !!!
    call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
    write(*,*) 'Hello from processor ', myid, ' out of ', numprocs
    !!! MEAT OF THE CODE !!!
    call MPI_FINALIZE(ierr)
end program hellompi
