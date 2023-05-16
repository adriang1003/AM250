#! /bin/bash
#SBATCH -p Instruction
#SBATCH -J pingPong
#SBATCH -e pingPong.err
#SBATCH -o pingPong.out
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 00:05:00

mpirun -np 2 pingPong.ex
