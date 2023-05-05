#! /bin/csh
#SBATCH -p Instruction
#SBATCH -J hello_omp_hb_c
#SBATCH -e hello_omp_hb_c.err
#SBATCH -o hello_omp_hb_c.out
#SBATCH -N 1
#SBATCH -c 4
#SBATCH -t 00:05:00

setenv OMP_NUM_THREADS 4
./hello_omp_hb
