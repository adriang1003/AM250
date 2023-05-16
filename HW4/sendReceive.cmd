#! /bin/bash
#SBATCH -p Instruction
#SBATCH -J sendReceive
#SBATCH -e sendReceive.err
#SBATCH -o sendReceive.out
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 00:05:00

mpirun -np 2 sendReceive.ex
