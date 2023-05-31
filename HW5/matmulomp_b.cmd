#!/bin/csh

#SBATCH -p Instruction
#SBATCH -J matmulomp_b
#SBATCH -e matmulomp_b.err
#SBATCH -o matmulomp_b.out
#SBATCH -N 1
#SBATCH -c 4
#SBATCH -t 00:05:00

setenv OMP_NUM_THREADS 4
./matmulomp_b.ex
