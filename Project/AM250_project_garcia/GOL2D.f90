! File: GOL2D.f90
! Author: Adrian Garcia
! Date: 06/10/2023
! Purpose: A parallel version of the Game of Life that uses 2D decomposition
! RULES:
! (1) If exactly 3 neighbors are alive, cell will be alive (if already alive, remains alive
!                                                           if dead, becomes alive)
! (2) If exactly 2 neighbors are alive, no change in cell status
! (3) All other cases, cell is dead
! (4) 1 -> cell is alive; 0 -> cell is dead
program GOL2D
    implicit none
    include 'mpif.h'
    integer :: ierr, myid, numprocs
    integer :: source, left, right, top, bottom
    integer :: tag1, tag2, tag3, tag4
    integer :: stat(MPI_STATUS_SIZE)
    integer, dimension(:, :), allocatable :: mat, subMat, solSub, perSub, solMat
    integer, dimension(:), allocatable :: rightCol, leftCol, topRow, bottomRow, counts, displs
    integer :: m, n, i, iter
    integer :: grid, numrows, numcols
    integer :: dim, newtype, intsize, resizedtype, col, row
    integer, dimension(2) :: sizes, subsizes, starts
    integer(kind = MPI_ADDRESS_KIND) :: extent
    real(kind = kind(0.d0)) :: start, finish
    call MPI_INIT(ierr)
    !!! MEAT OF THE CODE !!!
    call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
    ! Declaring variables
    source = 0
    tag1 = 1000
    tag2 = 1001
    tag3 = 1002
    tag4 = 1003
    m = 20
    n = 20
    iter = 80
    if (myid .eq. source) then
        allocate(mat(m, n), solMat(m, n))
        ! Initializing matrix
        call initMat(mat, m, n)
        write(*, *) 'Calculated matrix: '
        call printMat(mat, m, n)
    endif
    ! Divinding columns and rows by the number of processors for distribution
    grid = sqrt(real(numprocs))
    numcols = n/grid
    numrows = m/grid
    ! Checking run conditions
    if (grid**2 - numprocs .ne. 0) then
        if (myid .eq. source) then
            write(*, *) 'ERROR: Number of processors do not create a square grid'
        endif
        call MPI_FINALIZE(ierr)
        stop
    elseif ((numcols*grid .ne. n) .or. (numrows*grid .ne. m)) then
        if (myid .eq. source) then
            write(*, *) 'ERROR: Calculated matrix does not divide evenly'
        endif
        call MPI_FINALIZE(ierr)
        stop
    endif
    ! Configuring processor space
    if (myid + grid .ge. grid**2) then
        left  = mod(myid + grid, grid)
        right = mod(myid + grid, grid)
    else
        left = myid + grid
        right = myid + grid
    endif
    if (mod(myid, grid) .eq. 0) then
        top = myid + 1
        bottom = myid + 1
    else
        top = myid - 1
        bottom = myid - 1
    endif
    ! Denoting sub matrices
    dim = 2
    starts = (/0, 0/)
    sizes = (/m, n/)
    subsizes = (/numrows, numcols/)
    call MPI_Type_create_subarray(dim, sizes, subsizes, starts, MPI_ORDER_FORTRAN, MPI_INTEGER, newtype, ierr) 
    call MPI_Type_size(MPI_INTEGER, intsize, ierr)
    extent = numrows*intsize 
    call MPI_Type_create_resized(newtype, 0, extent, resizedtype, ierr) 
    call MPI_Type_commit(resizedtype, ierr)
    allocate(counts(numprocs), displs(numprocs))
    counts = 1
    forall(col = 1:grid, row = 1:grid)
        displs(1 + (row - 1) + grid*(col - 1)) = (row - 1) + numrows*grid*(col - 1)
    endforall
    allocate(subMat(numrows, numcols))
    ! Starting the Game of Life
    start = MPI_Wtime()
    ! Scattering subgrids to each processor
    call MPI_SCATTERV(mat, counts, displs, resizedtype, subMat, numrows*numcols, MPI_INTEGER, source, MPI_COMM_WORLD, ierr)
    allocate(perSub(numrows + 2, numcols + 2), solSub(numrows, numcols))
    allocate(leftCol(numrows), rightCol(numrows), topRow(numcols), bottomRow(numcols))
    do i = 1, iter
        ! Sending/Receiving right column of the left processor to the right processor
        call MPI_SENDRECV(subMat(:, numcols), numrows, MPI_INTEGER, right, tag1, &
    &                     leftCol, numrows, MPI_INTEGER, left, tag1, &
    &                     MPI_COMM_WORLD, stat, ierr)
        ! Sending/Receiving left column of the right processor to the left processor
        call MPI_SENDRECV(subMat(:, 1), numrows, MPI_INTEGER, left, tag2, &
    &                     rightCol, numrows, MPI_INTEGER, right, tag2, &
    &                     MPI_COMM_WORLD, stat, ierr)
        ! Sending/Receiving top row of the bottom processor to the top processor
        call MPI_SENDRECV(subMat(1, :), numcols, MPI_INTEGER, top, tag3, &
    &                     bottomRow, numcols, MPI_INTEGER, bottom, tag3, &
    &                     MPI_COMM_WORLD, stat, ierr)
        ! Sending/Receiving bottom row of the top processor to the bottom processor
        call MPI_SENDRECV(subMat(numrows, :), numcols, MPI_INTEGER, bottom, tag4, &
    &                     topRow, numcols, MPI_INTEGER, top, tag4, &
    &                     MPI_COMM_WORLD, stat, ierr)
        ! Waiting until all processors finish
        call MPI_BARRIER(MPI_COMM_WORLD, ierr)
        ! Initializing periodic matrix (creating ghost cells)
        call periodicMat(subMat, numrows, numcols, leftCol, rightCol, topRow, bottomRow, perSub)
        ! Playing GOL for one time step
        call GOL(perSub, numrows, numcols, solSub)
        ! Waiting until all processors finish
        call MPI_BARRIER(MPI_COMM_WORLD, ierr)
        ! Gathering subgrids from each processor
        call MPI_GATHERV(solSub, numrows*numcols, MPI_INTEGER, solMat, counts, displs, resizedtype, source, MPI_COMM_WORLD, ierr)
        if ((myid .eq. source) .and. (i .eq. 20 .or. i .eq. 40 .or. i .eq. 80)) then
            ! Print solution matrix and total # of alive cells (after GOL)
            write(*, *) 'Calculated matrix (after GOL): '
            write(*, *) 'Iteration =              ', i
            call printMat(solMat, m, n)
            write(*, *) 'Total # of alive cells = ', SUM(solMat)
        endif
        ! Reassign for next iteration step
        subMat = solSub
    enddo
    finish = MPI_Wtime()
    ! Ending the Game of Life
    deallocate(counts, displs, subMat, perSub, solSub, rightCol, leftCol, topRow, bottomRow)
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
    subroutine periodicMat(A, m, n, leftCol, rightCol, topRow, bottomRow, perMat)
    implicit none
    integer, intent(in) :: m, n
    integer, dimension(m, n), intent(in) :: A
    integer, dimension(m), intent(in) :: leftCol, rightCol
    integer, dimension(n), intent(in) :: topRow, bottomRow
    integer, dimension(m + 2, n + 2), intent(out) :: perMat
        ! Initializing periodic matrix (creating ghost cells)
        perMat(2:m + 1, 2:n + 1) = A ! Copy matrix to the inner portion
        perMat(2:m + 1, 1) = leftCol ! Add the left column to the left side
        perMat(2:m + 1, n + 2) = rightCol ! Add the right column to the right side
        perMat(1, 2:n + 1) = topRow ! Add the top row to the top
        perMat(m + 2, 2:n + 1) = bottomRow ! Add the bottom row to the bottom
        perMat(1, 1) = topRow(n) ! Copy the end of the top row to the start of top row
        perMat(1, n + 2) = topRow(1) ! Copy the start of the top row to the end of top row
        perMat(m + 2, 1) = bottomRow(n) ! Copy the end of the bottom row to the start of the bottom row
        perMat(m + 2, n + 2) = bottomRow(1) ! Copy the start of the bottom row to the end of the bottom row
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
end program GOL2D
