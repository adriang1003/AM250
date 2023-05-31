#!/bin/csh

#SBATCH -p Instruction
#SBATCH -J helloomp
#SBATCH -e helloomp.err
#SBATCH -o helloomp.out
#SBATCH -N 1
#SBATCH -c 4
#SBATCH -t 00:05:00

setenv OMP_NUM_THREADS 4
./helloomp.ex
