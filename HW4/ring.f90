! File: ring.f90
! Author: Adrian Garcia
! Date: 05/12/2023
! Purpose: Each processor sends its processor number around a ring of N processors and
! shifts all data to the left and to the right (N times)
program ring
    implicit none
    include 'mpif.h'
    integer :: ierr, myid, numprocs
    integer :: source, left, right, count, tag
    integer :: recvData, buffer, i
    integer, dimension(:), allocatable :: myidList
    integer :: stat(MPI_STATUS_SIZE)
    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
    !!! MEAT OF THE CODE !!!
    allocate(myidList(numprocs))
    myidList = 0
    left = myid - 1
    right = myid + 1
    source = 0
    count = 1
    tag = 1000
    call MPI_ALLGATHER(myid, count, MPI_INTEGER, myidList, count, MPI_INTEGER, MPI_COMM_WORLD, ierr)
    if (myid .eq. source) then
        left = numprocs - 1
        write(*,*) '              Processor ', myid, ' contains list: ', myidList
    endif
    if (myid .eq. numprocs - 1) then
        right = source
    endif
    buffer = myid
    do i = 1, numprocs
        call MPI_SENDRECV(buffer, count, MPI_INTEGER, left, tag, &
    &                     recvData, count, MPI_INTEGER, right, tag, &
    &                     MPI_COMM_WORLD, stat, ierr)
        buffer = recvData
        call MPI_ALLGATHER(buffer, count, MPI_INTEGER, myidList, count, MPI_INTEGER, MPI_COMM_WORLD, ierr)
        if (myid .eq. source) then
            write(*,*) '(LEFT SHIFT)  Processor ', myid, ' contains list: ', myidList
        endif
    enddo
    buffer = myid
    do i = 1, numprocs
        call MPI_SENDRECV(buffer, count, MPI_INTEGER, right, tag, &
    &                     recvData, count, MPI_INTEGER, left, tag, &
    &                     MPI_COMM_WORLD, stat, ierr)
        buffer = recvData
        call MPI_ALLGATHER(buffer, count, MPI_INTEGER, myidList, count, MPI_INTEGER, MPI_COMM_WORLD, ierr)
        if (myid .eq. source) then
            write(*,*) '(RIGHT SHIFT) Processor ', myid, ' contains list: ', myidList
        endif
    enddo
    deallocate(myidList)
    !!! MEAT OF THE CODE !!!
    call MPI_FINALIZE(ierr)
end program ring
