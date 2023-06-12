`Run command`: Type `gfortran GOLseq.f90 -o GOLseq.ex`, `mpif90 GOLcol.f90 -o GOLcol.ex`, and 
`mpif90 GOL2D.f90 -o GOL2D.ex` to create executables `GOLseq.ex`, `GOLcol.ex`, and `GOL2D.ex` which are 
the sequential, parallel (column decomp), and parallel (2D decomp) versions of the Game of Life, respectively.

Type `./GOLseq.ex`, `sbatch GOLcol.cmd`, and `sbatch GOL2D.cmd` to run executables.

See all `*.out` files for sample outputs of each parallel executable and `output.txt` for the sequential executable.

To change rows (`m`), columns (`n`), and iterations (`iter`), change the first few lines of code on each fortran file.

To change the number of processors, see all `*.cmd` files.

Note: I created this code on UCSC's `Hummingbird` supercomputer, not UCSC's `grape` supercomputer.
Type `mpirun -np 4 GOLcol.ex` and `mpirun -np 4 GOL2D.ex` to run executables on `grape`.
