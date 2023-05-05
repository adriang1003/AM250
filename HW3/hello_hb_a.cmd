#! /bin/bash
#SBATCH -p Instruction
#SBATCH -J hello_mpi_hb_a
#SBATCH -e hello_mpi_hb_a.err
#SBATCH -o hello_mpi_hb_a.out
#SBATCH -N 1
#SBATCH -n 4
#SBATCH -t 00:05:00

mpirun -np 4 hello_mpi_hb
