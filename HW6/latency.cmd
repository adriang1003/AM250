#!/bin/bash

#SBATCH -p Instruction
#SBATCH -J latency
#SBATCH -e latency.err
#SBATCH -o latency.out
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 00:05:00

mpirun -np 2 latency.ex
