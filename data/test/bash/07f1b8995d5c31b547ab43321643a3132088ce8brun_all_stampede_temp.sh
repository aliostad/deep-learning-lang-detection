#!/bin/bash

# This one is to run Chunking -> AHF  on Sisu (SLURM)

mpi_chunk=216
mpi_ahf=16
total_mpi_ahf=216
ahf_procs=32

node_chunk=27
node_ahf=16
total_node_ahf=108

mpi_per_node_chunk=8
mpi_per_node_ahf=1

openmp_threads_chunk=2
openmp_threads_ahf=16


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


base_folder="/home1/01937/cs390/cubepm_130315_6_1728_47Mpc_ext2/"
workspace="$base_folder/AHF_halos/"

particle_folder="/scratch/00506/ilievit/cubepm_130315_6_1728_47Mpc_ext2/results/"

ahf_folder="$base_folder/ahf-v1.0-056.SUSSEXBIGRUN/"

ahf_exec="$base_folder/ahf-v1.0-056.SUSSEXBIGRUN/bin/AHF-v1.0-056"

chunk_srcfolder="$base_folder/Chunking/"
chunk_exec="$base_folder/Chunking/chunk"

chunk_folder="/scratch/01937/cs390/CHUNKED/cubepm_130315_6_1728_47Mpc_ext2/"
ahfoutput_folder="/scratch/01937/cs390/AHF_halos/cubepm_130315_6_1728_47Mpc_ext2/"

ahf_template="$base_folder/AHF_halos/AHF.input-template"
cubep3minfo="$base_folder/AHF_halos/cubep3m.info"

snaplist="$base_folder/AHF_halos/snaplist"
halofinds="$base_folder/AHF_halos/halofinds"
lastsnap="$base_folder/AHF_halos/lastsnap"


qname="normal"

#compile things
cd ${ahf_folder}
make clean
make 
cd ${chunk_srcfolder}
make clean
make 


last_redshift="1000.0"

echo '' > $snaplist

cd $workspace
mkdir -p log

nsnap=0
nchunk=0
chunk_workspace=$(printf '%s/chunking/' $workspace)
mkdir -p $chunk_workspace
cd $chunk_workspace
cp $cubep3minfo cubep3m.info
while read line
do
    redshift=$(printf '%3.3f' $line)
    echo "redshift = " $redshift
    firstfile=$(printf '%s/%sxv0.dat' $particle_folder $redshift)
    if [ -e $firstfile ] 
    then
	redshift_list[$nsnap]=$redshift
	nsnap=$(($nsnap+1))
	for i in $(seq 0 $last_chunk)
	do
	    this_chunkfolder=$(printf '%s/z_%s/chunk_%d/' $chunk_folder $redshift $i)
	    mkdir -p $this_chunkfolder
	    this_output_prefix=$(printf '%s/z_%s_%d/chunk_%d/' $ahfoutput_folder $redshift $drho $i)
	    mkdir -p $this_output_prefix
	done
	this_chunk_param=$(printf 'chunk_param_%d' $nsnap)
	echo ${redshift} > $this_chunk_param
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
	for i in $(seq 0 $last_chunk)
	do
	    nchunk=$(($nchunk+1))
	    # ahf input file
	    this_ahf_config=$(printf 'ahf_config_%d' $nchunk)
	    cp ${ahf_template} ${this_ahf_config}
	    this_ic_filename=$(printf '%s/z_%s/chunk_%d/%sxv_chunk_%d_' $chunk_folder $redshift $i $redshift $i)
	    this_output_prefix=$(printf '%s/z_%s_%d/chunk_%d/%s' $ahfoutput_folder $redshift $drho $i $redshift)
	    echo 'ic_filename=' $this_ic_filename  >> $this_ahf_config
	    echo 'outfile_prefix=' $this_output_prefix >> $this_ahf_config
	    echo 'NcpuReading= ' $mpi_ahf >> $this_ahf_config

	    #clear the old results
	    #rm -f ${this_output_prefix}*
	done
    fi
    
done < $halofinds
# Chunk cubep3m
this_pbs="chunking_all.pbs"

echo "#!/bin/bash" > $this_pbs
echo "#SBATCH -t 24:00:00" >> $this_pbs
echo "#SBATCH -J chunking_all" >> $this_pbs
echo "#SBATCH -o chunking_all.o%a" >> $this_pbs
echo "#SBATCH -p normal" >> $this_pbs
echo "#SBATCH --array=1-${nsnap}" >> $this_pbs
echo "#SBATCH -N" $node_chunk "-n" $mpi_chunk >> $this_pbs

echo "export OMP_NUM_THREADS=$openmp_threads_chunk" >> $this_pbs
echo "ibrun tacc_affinity"  $chunk_exec 'chunk_param_${SLURM_ARRAY_TASK_ID}'  >> $this_pbs

#chunkjobid=$(sbatch $this_pbs | awk 'END{ print $4 }')

this_pbs="ahf_all.pbs"
echo "#!/bin/bash" > $this_pbs
echo "#SBATCH -t 12:00:00" >> $this_pbs
echo "#SBATCH -J ahf_all" >> $this_pbs
echo "#SBATCH -o ahf_all.o%a" >> $this_pbs
echo "#SBATCH -p normal" >> $this_pbs
echo "#SBATCH --array=1-${nsnap}" >> $this_pbs
echo "#SBATCH -N" $node_ahf "-n" $mpi_ahf >> $this_pbs
#echo "#SBATCH --dependency=afterok:${chunkjobid}" >> $this_pbs

echo "export OMP_NUM_THREADS=$openmp_threads_ahf" >> $this_pbs
echo "n_chunks_total=${n_chunks_total}" >> $this_pbs
echo 'snapid=$(echo "$SLURM_ARRAY_TASK_ID - 1" | bc)' >> $this_pbs
echo 'offset=$(echo "$snapid * $n_chunks_total" | bc)' >> $this_pbs
for j in $(seq 1 $n_chunks_total)
do
    echo 'chunkid=$(($offset+' $j '))' >> $this_pbs
    echo 'echo "doing" $chunkid' >> $this_pbs
    echo "ibrun tacc_affinity" $ahf_exec 'ahf_config_${chunkid}'  >> $this_pbs
done

sbatch $this_pbs