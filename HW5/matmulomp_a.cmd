#!/bin/csh

#SBATCH -p Instruction
#SBATCH -J matmulomp_a
#SBATCH -e matmulomp_a.err
#SBATCH -o matmulomp_a.out
#SBATCH -N 1
#SBATCH -c 4
#SBATCH -t 00:05:00

setenv OMP_NUM_THREADS 4
./matmulomp_a.ex
