#!/bin/bash

# This one is to run Chunking -> AHF  on Sisu (SLURM)

mpi_chunk=216
mpi_ahf=8

node_chunk=27
node_ahf=4

mpi_per_node_chunk=8
mpi_per_node_ahf=2

openmp_threads_chunk=2
openmp_threads_ahf=8


#mem_need_ahf=60
cubep3m_boxsize=47
cubep3m_mesh=3456
cubep3m_node=6

pid_flag=1
buffer_size=2.0
drho=200
n_chunks_pd=3
n_chunks_total=27
last_chunk=26


alias mpicc="cc"
alias mpif90="ftn"

base_folder="/wrk/pr1uboyd/code/cubepm_131212_6_1728_47Mpc_ext2/"
workspace="$base_folder/AHF_halos/"

particle_folder="/wrk/pr1u3001/cubepm_131212_6_1728_47Mpc_ext2/results/"

ahf_folder="$base_folder/ahf-v1.0-056.SUSSEXBIGRUN/"

ahf_exec="$base_folder/ahf-v1.0-056.SUSSEXBIGRUN/bin/AHF-v1.0-056"

chunk_srcfolder="$base_folder/Chunking/"
chunk_exec="$base_folder/Chunking/chunk"

chunk_folder="/wrk/pr1uboyd/tmp/cubepm_131212_6_1728_47Mpc_ext2/chunked_output/"
ahfoutput_folder="/wrk/pr1uboyd/chunked_halos/cubepm_131212_6_1728_47Mpc_ext2/"

ahf_template="$base_folder/AHF_halos/AHF.input-template"
cubep3minfo="$base_folder/AHF_halos/cubep3m.info"

snaplist="$base_folder/AHF_halos/snaplist"
halofinds="$base_folder/AHF_halos/halofinds"
lastsnap="$base_folder/AHF_halos/lastsnap"


qname="small"

#compile things
cd ${ahf_folder}
make clean
make 
cd ${chunk_srcfolder}
make clean
make 


last_redshift="1000.0"

echo '' > $snaplist
while read line
do
    redshift=$(printf '%3.3f' $line)
    echo "redshift = " $redshift
    firstfile=$(printf '%s/%sxv0.dat' $particle_folder $redshift)
    #make folder prepared for chunking
    this_workspace=$(printf '%s/z_%s_%d/' $workspace $redshift $drho)
    mkdir -p $this_workspace
    for i in $(seq 0 $last_chunk)
    do
	this_chunkfolder=$(printf '%s/z_%s/chunk_%d/' $chunk_folder $redshift $i)
	mkdir -p $this_chunkfolder
	this_output_prefix=$(printf '%s/z_%s_%d/chunk_%d/' $ahfoutput_folder $redshift $drho $i)
	mkdir -p $this_output_prefix
	rm -rf $this_output_prefix/*
    done
 
    cd ${this_workspace}
    rm -rf *
    this_chunk_param=$(printf 'chunk_param_%s' $redshift)

    echo ${redshift} > ${this_chunk_param}
    echo "dummy" >>  $this_chunk_param
    echo $particle_folder >> $this_chunk_param
    echo $chunk_folder >> $this_chunk_param
    echo $cubep3m_boxsize >> $this_chunk_param
    echo $cubep3m_node >> $this_chunk_param
    echo $cubep3m_mesh >> $this_chunk_param
    echo $pid_flag >> $this_chunk_param
    echo $buffer_size >> $this_chunk_param
    echo $n_chunks_pd >> $this_chunk_param
    echo $n_chunks_pd >> $this_chunk_param
    echo $n_chunks_pd >> $this_chunk_param
    if [ -e $firstfile ] 
    then
	# Chunk cubep3m
	this_pbs=$(printf 'chunking_%s.pbs' $redshift)
	chunk_job_name=$(printf 'chunking_%s' $redshift)
	this_ic_filename=$(printf '%s/z_%s/' $chunk_folder $redshift)

	echo "#!/bin/bash" > $this_pbs
	echo "#SBATCH -t 03:00:00" >> $this_pbs
	echo "#SBATCH -J" $chunk_job_name >> $this_pbs
	echo "#SBATCH -o ${chunk_job_name}.o%j" >> $this_pbs
	echo "#SBATCH -e ${chunk_job_name}.e%j" >> $this_pbs
	echo "#SBATCH -p small" >> $this_pbs
	echo "#SBATCH -N" $node_chunk >> $this_pbs
	echo "#SBATCH --ntasks-per-node=16" >> $this_pbs
	echo "#SBATCH --no-requeue" >> $this_pbs

	echo "module load PrgEnv-intel" >> $this_pbs
	echo "export OMP_NUM_THREADS=$openmp_threads_chunk" >> $this_pbs
	echo "rm -rf" $this_ic_filename >> $this_pbs
	echo "aprun -n $mpi_chunk -d $openmp_threads_chunk -N $mpi_per_node_chunk -S 4 -ss -cc cpu"  $chunk_exec $this_chunk_param >> $this_pbs
	#cat $this_pbs
	#chunkjobid=$(sbatch $this_pbs | awk '{ print $4 }')
	# run AHF on every chunks
	# cubep3m
	this_cubep3m_info="cubep3m.info"
	cp $cubep3minfo $this_cubep3m_info
	

	for i in $(seq 0 $last_chunk)
	do
	    cd $this_workspace
	    this_pbs=$(printf 'ahf_chunk_%d' $i)
	    this_ahf_config=$(printf 'ahf_config_%d' $i)
	    
	    # ahf input file
	    cp ${ahf_template} ${this_ahf_config}
	    this_ic_filename=$(printf '%s/z_%s/chunk_%d/%sxv_chunk_%d_' $chunk_folder $redshift $i $redshift $i)
	    this_output_prefix=$(printf '%s/z_%s_%d/chunk_%d/ahf' $ahfoutput_folder $redshift $drho $i $redshift)
	    echo 'ic_filename=' $this_ic_filename  >> $this_ahf_config
	    echo 'outfile_prefix=' $this_output_prefix >> $this_ahf_config
	    echo 'NcpuReading=' $mpi_ahf >> $this_ahf_config
	    # pbs file
	    this_pbs=$(printf 'ahf_%s_%d.pbs' $redshift $i)
	    ahf_job_name=$(printf 'ahf_%s_%d' $redshift $i)

	    echo "#!/bin/bash" > $this_pbs
	    echo "#SBATCH -t 03:00:00"  >> $this_pbs
	    echo "#SBATCH -J" $ahf_job_name >> $this_pbs
	    echo "#SBATCH -o $ahf_job_name.o%j" >> $this_pbs
	    echo "#SBATCH -e $ahf_job_name.e%j" >> $this_pbs
	    echo "#SBATCH -p small" >> $this_pbs
	    echo "#SBATCH -N" $node_ahf >> $this_pbs
	    #echo "#SBATCH --dependency=afterok:${chunkjobid}" >> $this_pbs
	    echo "#SBATCH --ntasks-per-node=16" >> $this_pbs
	    echo "#SBATCH --no-requeue" >> $this_pbs

	    echo "module load PrgEnv-intel" >> $this_pbs
	    echo "export OMP_NUM_THREADS=$openmp_threads_ahf" >> $this_pbs
	    echo "rm -f ${this_output_prefix}*" >> $this_pbs
	    echo "aprun -n $mpi_ahf -d $openmp_threads_ahf -N $mpi_per_node_ahf -S 1 -ss -cc cpu"  $ahf_exec $this_ahf_config >> $this_pbs
	 
	    #echo "rm -rf ${chunk_folder}/z_${redshift}/chunk_$i/*" >> $this_pbs
	    
	    echo "echo $redshift $i >> $snaplist" >> $this_pbs
	    echo "echo $line > $lastsnap" >> $this_pbs
	    #cat $this_pbs
	    sbatch $this_pbs
	   
	done
	
    fi
done < $halofinds
##mpirun -np 8 ../bin/AHF-v1.0-056 AHF.input-template2
