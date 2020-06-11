##############################################################
# change this path according to machine
server_cur_dir=/root/major

##############################################################

if [ $# -ne 1 ]
then
    echo "Invalid Params!"
    exit 2
fi

inputfile=$1

server_chunk_dir=${server_cur_dir}/chunk
server_metadata_dir=${server_cur_dir}/metadata
server_metadata_dir_files=${server_metadata_dir}/files
server_temp_metadata_dir=${server_cur_dir}/temp_metadata
server_temp_metadata_chunk=${server_temp_metadata_dir}/chunk


inputfile_hashlist=${server_metadata_dir_files}/${inputfile}

while read chunkName
do
  cp ${server_chunk_dir}/${chunkName} ${server_temp_metadata_chunk}/${chunkName}

done < $inputfile_hashlist
