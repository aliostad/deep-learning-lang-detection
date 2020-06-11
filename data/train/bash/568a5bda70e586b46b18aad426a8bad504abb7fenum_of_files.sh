#!/bin/bash

#this is a script that adds jobs in variable batches
#first find all file names
#split filenames into batches
#chunk -> 1 job -> 40 jobs at a time
#for each batch, generate a script that has the fimo command for each file (a job)

#for each job, have a wait time every 40 jobs.

chunk_size=20
counter=0
#get all files
search=GATA1_01_1_100000
all_filenames=($(find /projects/p20519/jia_output/FIMO/GATA1_01/$search.* -type f))
output_folder="GATA1_output"

#i need to call 1.. chunk. chunk +1 ... chunk + chunk... etc
#while loop A to check if all files are processed.
#inner loop B to generate command
#while loop A also submits the job
#while loop A also waits 10 minutes between each job submission after 40.

#nbatch should start at 1
nbatch=1
nfiles=${#all_filenames[@]}
max_batch=$(($(($nfiles+$chunk_size-1))/$chunk_size))

generate_pipe () {
  #echo "file name is $1"
  #echo "base file name is $2"
  #echo "counter is $3"
  local cmd_filename=$1
  local cmd_base_filename=$2
  local cmd_counter=$3

  pipe_command="mkfifo /projects/p20519/jia_output/FIMO/${output_folder}/${cmd_base_filename}_job${cmd_counter}.txt" # in bash, all variables declared inside the function is shared with the# calling environment
}


generate_command () {
  #echo "file name is $1"
  #echo "base file name is $2"
  #echo "counter is $3"
  local cmd_filename=$1
  local cmd_base_filename=$2
  local cmd_counter=$3

  command="fimo --max-stored-scores 500000000 --thresh 0.0001  --max-seq-length 250000000 --text /projects/p20519/jia_output/TRANSFAC2FIMO_3242014.txt $cmd_filename >> /projects/p20519/jia_output/FIMO/${output_folder}/${cmd_base_filename}_job${cmd_counter}.txt &" # in bash, all variables declared inside the function is shared with the calling environment
}

generate_compress_command () {
  #echo "file name is $1"
  #echo "base file name is $2"
  #echo "counter is $3"
  local cmd_filename=$1
  local cmd_base_filename=$2
  local cmd_counter=$3

  compress_command="cat /projects/p20519/jia_output/FIMO/${output_folder}/${cmd_base_filename}_job${cmd_counter}.txt | python /home/jjw036/SequenceGenerator/scripts/FimoEvaluator_P53.py" 
}


echo "Processing ${nfiles} files in ${max_batch} batches "

counter=$(($nbatch*$chunk_size))
end_index=0
file_batch=()
