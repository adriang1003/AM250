#! /bin/bash
#SBATCH -p Instruction
#SBATCH -J ring
#SBATCH -e ring.err
#SBATCH -o ring.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 00:05:00

mpirun -np 8 ring.ex
