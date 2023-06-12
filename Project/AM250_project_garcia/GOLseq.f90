! File: GOLseq.f90
! Author: Adrian Garcia
! Date: 06/01/2023
! Purpose: A serial version of the Game of Life that will be used to check the correctness
! of the parallel version.
! RULES: 
! (1) If exactly 3 neighbors are alive, cell will be alive (if already alive, remains alive; 
!                                                           if dead, becomes alive)
! (2) If exactly 2 neighbors are alive, no change in cell status
! (3) All other cases, cell is dead
! (4) 1 -> cell is alive; 0 -> cell is dead
program GOLseq
    implicit none
    integer, dimension(:, :), allocatable :: mat, solMat, perMat
    integer :: m, n, iter, i
    real(kind = kind(0.d0)) :: start, finish
    ! Declaring variables
    m = 20
    n = 20
    iter = 80
    allocate(mat(m, n), solMat(m, n), perMat(m + 2, n + 2))
    ! Initializing matrix
    call initMat(mat, m, n)
    write(*, *) 'Calculated matrix: '
    call printMat(mat, m, n)
    write(*, *) 'Total # of alive cells = ', SUM(mat)
    ! Starting the Game of Life
    call cpu_time(start)
    do i = 1, iter
        ! Initializing periodic matrix (creating ghost cells)
        call periodicMat(mat, m, n, perMat)
        ! Playing GOL for one time step
        call GOL(perMat, m, n, solMat)
        if (i .eq. 20 .or. i .eq. 40 .or. i .eq. 80) then
            ! Print solution matrix and total # of alive cells (after GOL)
            write(*, *) 'Calculated matrix (after GOL): '
            write(*, *) 'Iteration =              ', i
            call printMat(solMat, m, n)
            write(*, *) 'Total # of alive cells = ', SUM(solMat)
        endif
        ! Reassign for next iteration step
        mat = solMat
    enddo
    call cpu_time(finish)
    ! Ending the Game of Life
    write(*, *) 'Total time:              ', finish - start
    deallocate(mat, solMat, perMat)
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
    subroutine periodicMat(A, m, n, perMat)
    implicit none
    integer, intent(in) :: m, n
    integer, dimension(m, n), intent(in) :: A
    integer, dimension(m + 2, n + 2), intent(out) :: perMat
    ! Initializing periodic matrix (creating ghost cells)
        perMat(2:m + 1, 2:n + 1) = A ! Copy matrix to the inner portion
        perMat(2:m + 1, 1) = A(:, n) ! Copy the last column of OG matrix to the first column
        perMat(2:m + 1, n + 2) = A(:, 1) ! Copy the first column of OG matrix to the last column
        perMat(1, 2:n + 1) = A(m, :) ! Copy the last row of OG matrix to the first row
        perMat(m + 2, 2:n + 1) = A(1, :) ! Copy the first row of OG matrix to the last row
        perMat(1, 1) = A(m, n) ! Copy bottom-right of OG matrix to the top-left
        perMat(1, n + 2) = A(m, 1) ! Copy bottom-left of OG matrix to the top-right
        perMat(m + 2, 1) = A(1, n) ! Copy top-right of OG matrix to the bottom-left
        perMat(m + 2, n + 2) = A(1, 1) ! Copy top-left of OG matrix to the bottom-right
    end subroutine periodicMat
    ! Input(s): Periodic matrix perMat, dimensions of mat (m rows, n columns)
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
end program GOLseq
