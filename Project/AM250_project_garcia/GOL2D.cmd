#!/bin/bash
#SBATCH -p Instruction
#SBATCH -J GOL2D
#SBATCH -e GOL2D.err
#SBATCH -o GOL2D.out
#SBATCH -N 1
#SBATCH --ntasks-per-node 4
#SBATCH -t 00:05:00

mpirun -np 4 GOL2D.ex
