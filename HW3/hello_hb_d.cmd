#! /bin/csh
#SBATCH -p Instruction
#SBATCH -J hello_omp_hb_d
#SBATCH -e hello_omp_hb_d.err
#SBATCH -o hello_omp_hb_d.out
#SBATCH -N 1
#SBATCH -c 8
#SBATCH -t 00:05:00

setenv OMP_NUM_THREADS 8
./hello_omp_hb
