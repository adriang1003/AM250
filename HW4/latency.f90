! File: latency.f90
! Author: Adrian Garcia
! Date: 05/12/2023
! Purpose: To time message transfers to figure out what the constants are for
! the formula T_{comm} = t_{startup} + t_{perdata}L.
program latency
    implicit none
    include 'mpif.h'
    integer :: ierr, myid, numprocs
    integer :: source, destination, count, tag1, tag2
    integer :: stat(MPI_STATUS_SIZE)
    integer :: sendData, recvData, i
    integer, parameter :: iter = 100
    real(kind = kind(0.d0)) :: t1, t2, T_comm, t_startup, t_perdata
    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
    !!! MEAT OF THE CODE !!!
    source = 0
    destination = 1
    count = 1
    tag1 = 1000
    tag2 = 1001
    t_startup = 0.0
    do i = 1,iter
        t1 = MPI_Wtime()
        t2 = MPI_Wtime()
        t_startup = t_startup + (t2 - t1)
    enddo
    t_startup = t_startup/iter
    if (myid .eq. source) then
        sendData = 1111
        t_perdata = 0.0
        do i = 1,iter
            call MPI_Barrier(MPI_COMM_WORLD, ierr)
            t1 = MPI_Wtime()
            call MPI_SEND(sendData, count, MPI_INTEGER, destination, tag1, MPI_COMM_WORLD, ierr)
            call MPI_RECV(recvData, count, MPI_INTEGER, destination, tag2, MPI_COMM_WORLD, stat, ierr)
            t2 = MPI_Wtime()
            t_perdata = t_perdata + (t2 - t1)
        enddo
        t_perdata = t_perdata/iter
        write(*,*) 'L =           ', count
        write(*,*) 't_{startup} = ', t_startup
        write(*,*) 't_{perdata} = ', t_perdata
        T_comm = t_startup + t_perdata*count
        write(*,*) 'T_comm =      ', T_comm
    endif
    if (myid .eq. destination) then
        do i = 1,iter
            call MPI_Barrier(MPI_COMM_WORLD, ierr)
            call MPI_RECV(sendData, count, MPI_INTEGER, source, tag1, MPI_COMM_WORLD, stat, ierr)
            recvData = sendData
            call MPI_SEND(recvData, count, MPI_INTEGER, source, tag2, MPI_COMM_WORLD, ierr)
        enddo
    endif
    !!! MEAT OF THE CODE !!!
    call MPI_FINALIZE(ierr)
end program latency
