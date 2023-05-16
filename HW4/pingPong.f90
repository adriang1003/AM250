! File: pingPong.f90
! Author: Adrian Garcia
! Date: 05/12/2023
! Purpose: Sends data backwards and forwards between two processors. 
program pingPong
    implicit none
    include 'mpif.h'
    integer :: ierr, myid, numprocs
    integer :: source, destination, count, tag1, tag2
    integer :: stat(MPI_STATUS_SIZE)
    integer :: sendData, recvData
    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
    !!! MEAT OF THE CODE !!!
    source = 0
    destination = 1
    count = 1
    tag1 = 1000
    tag2 = 1001
    if (myid .eq. source) then
        sendData = 1111
        call MPI_SEND(sendData, count, MPI_INTEGER, destination, tag1, MPI_COMM_WORLD, ierr)
        write(*,*) 'Processor ', myid, ' sent:     ', sendData
        call MPI_RECV(recvData, count, MPI_INTEGER, destination, tag2, MPI_COMM_WORLD, stat, ierr)
        write(*,*) 'Processor ', myid, ' received: ', recvData
    endif
    if (myid .eq. destination) then
        call MPI_RECV(sendData, count, MPI_INTEGER, source, tag1, MPI_COMM_WORLD, stat, ierr)
        recvData = sendData
        write(*,*) 'Processor ', myid, ' received: ', recvData
        call MPI_SEND(recvData, count, MPI_INTEGER, source, tag2, MPI_COMM_WORLD, ierr)
        write(*,*) 'Processor ', myid, ' sent:     ', recvData
    endif
    !!! MEAT OF THE CODE !!!
    call MPI_FINALIZE(ierr)
end program pingPong
