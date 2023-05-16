! File: ring.f90
! Author: Adrian Garcia
! Date: 05/12/2023
! Purpose: Each processor sends its processor number around a ring of N processors and
! shifts all data to the left (N times)
program ring
    implicit none
    include 'mpif.h'
    integer :: ierr, myid, numprocs
    integer :: left, right, count, tag
    integer :: recvData
    integer :: stat(MPI_STATUS_SIZE)
    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
    !!! MEAT OF THE CODE !!!
    left = myid - 1
    right = myid + 1
    count = 1
    tag = 1000
    if (myid .eq. 0) then
        left = numprocs - 1
    endif
    if (myid .eq. numprocs - 1) then
        right = 0
    endif
    call MPI_SENDRECV(myid, count, MPI_INTEGER, left, tag, &
&                     recvData, count, MPI_INTEGER, right, tag, &
&                     MPI_COMM_WORLD, stat, ierr)
    write(*,*) 'Processor ', myid, ' received: ', recvData
    !!! MEAT OF THE CODE !!!
    call MPI_FINALIZE(ierr)
end program ring
