! File: sendReceive.f90
! Author: Adrian Garcia
! Date: 05/12/2023
! Purpose: Sends some data from one processor to another, using the standard MPI send and receive. 
program sendReceive
    implicit none
    include 'mpif.h'
    integer :: ierr, myid, numprocs
    integer :: source, destination, count, tag
    integer :: stat(MPI_STATUS_SIZE)
    real, dimension(5) :: realData
    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
    !!! MEAT OF THE CODE !!!
    source = 0
    destination = 1
    count = 5
    tag = 1000
    if (myid .eq. source) then
        realData = (/0.0, 1.0, 2.0, 3.0, 4.0/)
        call MPI_SEND(realData, count, MPI_REAL, destination, tag, MPI_COMM_WORLD, ierr)
        write(*,*) 'Processor ', myid, ' sent:     ', realData
    endif
    if (myid .eq. destination) then
        call MPI_RECV(realData, count, MPI_REAL, source, tag, MPI_COMM_WORLD, stat, ierr)
        write(*,*) 'Processor ', myid, ' received: ', realData
    endif
    !!! MEAT OF THE CODE !!!
    call MPI_FINALIZE(ierr)
end program sendReceive
