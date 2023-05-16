#! /bin/bash
#SBATCH -p Instruction
#SBATCH -J pi
#SBATCH -e pi.err
#SBATCH -o pi.out
#SBATCH -N 1
#SBATCH -n 10
#SBATCH -t 00:05:00

mpirun -np 10 pi.ex
