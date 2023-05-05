#PBS -S /bin/tcsh
#PBS -N hello_omp_grape_c
#PBS -l nodes=1:ppn=4
#PBS -l walltime=00:05:00
#PBS -q newest

cd $PBS_O_WORKDIR
setenv OMP_NUM_THREADS 4
./hello_omp_grape
