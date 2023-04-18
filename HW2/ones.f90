! File: ones.f90
! Author: Adrian Garcia
! Date: 04/15/2023
! Purpose: Dynamically creates a square array of a size input by the user at runtime then assigns certain values of the array to be 1 at random and 0 for the rest.
! It then calculates another array that contains a 1 at any location if exactly 3 of the 8 surrounding neighboring locations in the original array contain 1's.
program ones
    implicit none
    integer :: m, i, j, num
    integer, dimension(:, :), allocatable :: mat, solMat, perMat
    real(kind = kind(0.d0)) :: r
    write(*, *) 'm = '
    read(*, *) m
    allocate(mat(m, m), solMat(m, m), perMat(m + 2, m + 2))
    ! Initialize square matrix
    mat = 0
    do i = 1, m
        do j = 1, m
            call random_number(r)
            if (r .ge. 0.65) then ! Assinging 1's at random
                mat(i, j) = 1
            endif
        enddo
    enddo
    ! Print generated matrix
    write(*, *) 'Generated matrix:'
    call printMat(mat, m, m)
    ! Initialize periodic matrix
    perMat(2:m + 1, 2:m + 1) = mat ! Copy matrix to the inner portion
    perMat(2:m + 1, 1) = mat(:, m) ! Copy the last column of OG matrix to the first column
    perMat(2:m + 1, m + 2) = mat(:, 1) ! Copy the first column of OG matrix to the last column
    perMat(1, 2:m + 1) = mat(m, :) ! Copy the last row of OG matrix to the first row
    perMat(m + 2, 2:m + 1) = mat(1, :) ! Copy the first row of OG matrix to the last row
    perMat(1, 1) = mat(m, m) ! Copy bottom-right of OG matrix to the top-left
    perMat(1, m + 2) = mat(m, 1) ! Copy bottom-left of OG matrix to the top-right
    perMat(m + 2, 1) = mat(1, m) ! Copy top-right of OG matrix to the bottom-left
    perMat(m + 2, m + 2) = mat(1, 1) ! Copy top-left of OG matrix to the bottom-right
    ! Print periodic matrix
    write(*, *) 'Periodic matrix:'
    call printMat(perMat, m + 2, m + 2)
    ! Initialize solution matrix
    solMat = 0
    num = 0
    do i = 2, m + 1
        do j = 2, m + 1
            ! Check periodic matrix for neighboring 1's (clockwise)
            if (perMat(i - 1, j - 1) .eq. 1) then ! Checks top-left for a 1
                num = num + 1
            endif
            if (perMat(i - 1, j) .eq. 1) then ! Checks directly above for a 1
                num = num + 1
            endif
            if (perMat(i - 1, j + 1) .eq. 1) then ! Checks top-right for a 1
                num = num + 1
            endif
            if (perMat(i, j + 1) .eq. 1) then ! Checks right for a 1
                num = num + 1
            endif
            if (perMat(i + 1, j + 1) .eq. 1) then ! Checks bottom-right for a 1
                num = num + 1
            endif
            if (perMat(i + 1, j) .eq. 1) then ! Checks directly bottom for a 1
                num = num + 1
            endif
            if (perMat(i + 1, j - 1) .eq. 1) then ! Checks bottom-left for a 1
                num = num + 1
            endif
            if (perMat(i, j - 1) .eq. 1) then ! Checks left for a  1
                num = num + 1
            endif
            if (num .ge. 3) then ! If 3 or more neighbors are 1's, then solMat(i,j) is assigned a 1 
                solMat(i - 1,j - 1) = 1
            endif
            ! Reset num for next cell
            num = 0
        enddo
    enddo
    ! Print solution matrix
    write(*,*) 'Calculated matrix:'
    call printMat(solMat,m,m)
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
        write(*, 1) m, n
        1 format(2i4)
        do i = 1, m
            write(*, *) (A(i, j) , j = 1, n)
        end do
        write(*, *)
    end subroutine printMat 
end program ones
