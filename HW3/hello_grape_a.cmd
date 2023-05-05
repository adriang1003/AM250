#PBS -S /bin/tcsh
#PBS -N hello_mpi_grape_a
#PBS -l nodes=1:ppn=4
#PBS -l walltime=00:05:00
#PBS -q newest

cd $PBS_O_WORKDIR
mpirun -np 4 hello_mpi_grape
