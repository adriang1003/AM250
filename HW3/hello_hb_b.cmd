#! /bin/bash
#SBATCH -p Instruction
#SBATCH -J hello_mpi_hb_b
#SBATCH -e hello_mpi_hb_b.err
#SBATCH -o hello_mpi_hb_b.out
#SBATCH -N 2
#SBATCH --ntasks-per-node 4
#SBATCH -t 00:05:00

mpirun -np 8 hello_mpi_hb
