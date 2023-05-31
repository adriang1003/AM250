! File: helloomp.f90
! Author: Adrian Garcia
! Date: 05/30/2023
! Purpose: Starts OpenMP running on a number of threads, and then writes out "Hello World" from each thread,
! stating the thread id and the total thread number.
program helloomp
    implicit none
    integer NTHREADS, TID, OMP_GET_NUM_THREADS, OMP_GET_THREAD_NUM
!$OMP PARALLEL PRIVATE(NTHREADS, TID)
    TID = OMP_GET_THREAD_NUM()
    write(*,*) 'Hello World from thread = ', TID
    if (TID .eq. 0) then
        NTHREADS = OMP_GET_NUM_THREADS()
        write(*,*) 'Number of threads =       ', NTHREADS
    endif
!$OMP END PARALLEL
end program helloomp
