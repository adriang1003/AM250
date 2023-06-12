#!/bin/bash
#SBATCH -p Instruction
#SBATCH -J GOLcol
#SBATCH -e GOLcol.err
#SBATCH -o GOLcol.out
#SBATCH -N 1
#SBATCH --ntasks-per-node 4
#SBATCH -t 00:05:00

mpirun -np 4 GOLcol.ex
