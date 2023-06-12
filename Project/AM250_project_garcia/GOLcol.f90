! File: GOLcol.f90
! Author: Adrian Garcia
! Date: 06/05/2023
! Purpose: A parallel version of the Game of Life that uses column decomposition
! RULES:
! (1) If exactly 3 neighbors are alive, cell will be alive (if already alive, remains alive
!                                                           if dead, becomes alive)
! (2) If exactly 2 neighbors are alive, no change in cell status
! (3) All other cases, cell is dead
! (4) 1 -> cell is alive; 0 -> cell is dead
program GOLcol
    implicit none
    include 'mpif.h'
    integer :: ierr, myid, numprocs
    integer :: source, left, right, tag1, tag2
    integer :: stat(MPI_STATUS_SIZE)
    integer, dimension(:, :), allocatable :: mat, cols, solCols, perCols, solMat
    integer, dimension(:), allocatable :: rightCol, leftCol
    integer :: m, n, iter, numcols, i
    real(kind = kind(0.d0)) :: start, finish
    call MPI_INIT(ierr)
    !!! MEAT OF THE CODE !!!
    call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
    ! Declaring variables
    source = 0
    left = myid - 1
    right = myid + 1
    tag1 = 1000
    tag2 = 1001
    m = 20
    n = 20
    iter = 80
    if (myid .eq. source) then
        left = numprocs - 1
        allocate(mat(m, n), solMat(m, n))
        ! Initializing matrix
        call initMat(mat, m, n)
        write(*, *) 'Calculated matrix: '
        call printMat(mat, m, n)
        write(*, *) 'Total # of alive cells = ', SUM(mat)
    endif
    if (myid .eq. numprocs - 1) then
        right = source
    endif
    ! Divinding columns by the number of processors for distribution
    if (n .le. numprocs) then
        numcols = 1
    else
        numcols = n/numprocs
        if ((mod(n, numprocs) .ne. 0) .and. (mod(n, numprocs) < n/2)) then
            numcols = numcols + 1
        endif
    endif
    allocate(cols(m, numcols))
    ! Starting the Game of Life
    start = MPI_Wtime()
    ! Scattering column(s) to each processor
    call MPI_SCATTER(mat, m*numcols, MPI_INTEGER, cols, m*numcols, MPI_INTEGER, source, MPI_COMM_WORLD, ierr)
    if ((myid .eq. numprocs - 1) .and. (myid*numcols + 1 .le. n)) then
        numcols = n - (myid*numcols + 1) + 1
    endif
    allocate(perCols(m + 2, numcols + 2), solCols(m, numcols), rightCol(m), leftCol(m))
    do i = 1, iter
        ! Sending/Receiving right column of the left processor to the right processor
        call MPI_SENDRECV(cols(:, numcols), m, MPI_INTEGER, right, tag1, &
    &                     leftCol, m, MPI_INTEGER, left, tag1, &
    &                     MPI_COMM_WORLD, stat, ierr)
        ! Sending/Receiving left column of the right processor to the left processor
        call MPI_SENDRECV(cols(:, 1), m, MPI_INTEGER, left, tag2, &
    &                     rightCol, m, MPI_INTEGER, right, tag2, &
    &                     MPI_COMM_WORLD, stat, ierr)
        ! Initializing periodic matrix (creating ghost cells)
        call periodicMat(cols, m, numcols, leftCol, rightCol, perCols)
        ! Playing GOL for one time step
        call GOL(perCols, m, numcols, solCols)
        ! Waiting until all processors finish
        call MPI_BARRIER(MPI_COMM_WORLD, ierr)
        ! Gathering column(s) from each processor
        call MPI_GATHER(solCols, m*numcols, MPI_INTEGER, solMat, m*numcols, MPI_INTEGER, source, MPI_COMM_WORLD, ierr)
        if ((myid .eq. source) .and. (i .eq. 20 .or. i .eq. 40 .or. i .eq. 80)) then
            ! Print solution matrix and total # of alive cells (after GOL)
            write(*, *) 'Calculated matrix (after GOL): '
            write(*, *) 'Iteration =              ', i
            call printMat(solMat, m, n)
            write(*, *) 'Total # of alive cells = ', SUM(solMat)
        endif
        ! Reassign for next iteration step
        cols = solCols
    enddo
    finish = MPI_Wtime()
    ! Ending the Game of Life
    deallocate(cols, perCols, solCols, rightCol, leftCol)
    if (myid .eq. source) then
        write(*, *) 'Total time:              ', finish - start
        deallocate(mat, solMat)
    endif
    !!! MEAT OF THE CODE !!!
    call MPI_FINALIZE(ierr)
contains
    ! Input(s): Matrix A, dimensions of A (m rows, n columns)
    ! Output(s): None
    ! Purpose: Prints matrix A and its dimensions in human-readable format
    subroutine printMat(A, m, n)
        implicit none
        integer, intent(in) :: m, n
        integer, dimension(m, n), intent(in) :: A
        integer :: i, j
        write(*, 1) m,n
        1 format(2i4)
        do i = 1, m
            write(*, *) (A(i, j) , j = 1, n)
        end do
        write(*, *)
    end subroutine printMat
    ! Input(s): Matrix A, dimensions of A (m rows, n columns)
    ! Output(s): Matrix A
    ! Purpose: Generates a starting matrix A
    subroutine initMat(A, m, n)
        implicit none
        integer, intent(in) :: m, n
        integer, dimension(m, n), intent(inout) :: A
        ! Creating "Glider"
        A = 0
        A(1, 3) = 1
        A(2, 1) = 1
        A(2, 3) = 1
        A(3, 2) = 1
        A(3, 3) = 1
    endsubroutine initMat
    ! Input(s): Matrix A, dimensions of A (m rows, n columns)
    ! Output(s): Periodic matrix perMat
    ! Purpose: Generates a periodic matrix from matrix A
    subroutine periodicMat(A, m, n, leftCol, rightCol, perMat)
    implicit none
    integer, intent(in) :: m, n
    integer, dimension(m, n), intent(in) :: A
    integer, dimension(m) :: leftCol, rightCol
    integer, dimension(m + 2, n + 2), intent(out) :: perMat
        ! Initializing periodic matrix (creating ghost cells)
        perMat(2:m + 1, 2:n + 1) = A ! Copy matrix to the inner portion
        perMat(2:m + 1, 1) = leftCol ! Add the left column to the left side
        perMat(2:m + 1, n + 2) = rightCol ! Add the right column to the right side
        perMat(1, :) = perMat(m + 1, :) ! Copy the last row of periodic matrix to the first row
        perMat(m + 2, :) = perMat(2, :) ! Copy the first row of periodic matrix to the last row
    end subroutine periodicMat
    ! Input(s): Matrix mat, dimensions of mat (m rows, n columns), periodic matrix perMat
    ! Output(s): Solution matrix solMat
    ! Purpose: Generates the next time step matrix of the GOL by using the specified rules
    subroutine GOL(perMat, m, n, solMat)
    implicit none
    integer, intent(in) :: m, n
    integer, dimension(m + 2, n + 2), intent(out) :: perMat
    integer, dimension(m, n), intent(out) :: solMat
    integer :: i, j, num
    do i = 2, m + 1
        do j = 2, n + 1
            ! Checking periodic matrix for neighboring 1's
            num = perMat(i - 1, j - 1) + perMat(i - 1, j) + &
                & perMat(i - 1, j + 1) + perMat(i, j + 1) + &
                & perMat(i + 1, j + 1) + perMat(i + 1, j) + &
                & perMat(i + 1, j - 1) + perMat(i, j - 1)
            if (num .eq. 3) then ! If exactly 3 neighbors are 1's, then solMat(i,j) is assigned a 1
                solMat(i - 1, j - 1) = 1
            else if (num .eq. 2) then ! If exactly 2 neighbors are 1's, then solMat(i,j) is unchanged
                solMat(i - 1, j - 1) = perMat(i, j)
            else ! All other cases, solMat(i,j) is assigned a 0
                solMat(i - 1, j - 1) = 0
            endif
            ! Reset num for next cell
            num = 0
        enddo
    enddo
    end subroutine GOL
end program GOLcol
