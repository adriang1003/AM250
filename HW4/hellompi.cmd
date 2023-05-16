#! /bin/bash
#SBATCH -p Instruction
#SBATCH -J hellompi
#SBATCH -e hellompi.err
#SBATCH -o hellompi.out
#SBATCH -N 2
#SBATCH --ntasks-per-node 4
#SBATCH -t 00:05:00

mpirun -np 8 hellompi.ex
