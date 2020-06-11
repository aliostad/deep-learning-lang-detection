#!/bin/bash

# functions
function show_usage() {
	echo -e "USAGE:\n\t./make_sample_data_file.sh <number_of_chunks> <chunk_file> <output_file>
e.g.: \t./make_sample_data_file.sh 100000 data/small_sample.txt data/big_sample.txt
\t\tnumber_of_chunks : the number of chunks in the output file where every chunk is equal to the contents of the chunk_file 
\t\tchunk_file	 : the chunk file that contains a small sample of the input data e.g. data/CHUNK.txt
\t\toutput_file	 : the output file where you expect the data to be created"
	exit 1
}

function validate_sample_file() {
	CHUNK_FILE=$1
	if [ ! -e "$CHUNK_FILE" ]
	then
		return 1
	fi
	#TODO loop on sample file and check every record
	#TODO check that there are at least 2 classes
	#TODO check that there are 10 features at least
	#TODO check that every record has a class and at least 1 feature
}

function show_info(){
	NUM_OF_CHUNKS=$1
	CHUNK_FILE=$2
	OUTPUTFILE_PATH=$3

	
	NUM_OF_RECORDS_IN_CHUNK=$(echo $CHUNK | wc -l)
	NUM_OF_RECORDS=$(($NUM_OF_RECORDS_IN_CHUNK * $NUM_OF_CHUNKS))

	echo "Creating output file '$OUTPUTFILE_PATH' with $NUM_OF_RECORDS"
}

function validate_inputs(){
	NUM_OF_CHUNKS=$1
	CHUNK_FILE=$2
	OUTPUTFILE_PATH=$3
	
	if [ -z "$NUM_OF_CHUNKS" ] || [ -z "$CHUNK_FILE" ] || [ -z "$OUTPUTFILE_PATH" ]; then
		show_usage
	fi
	
	#TODO validate if output directory exists
	#TODO validate if number of chunks is a number and greater than 0
 
	validate_sample_file "$CHUNK_FILE"
	if [ $? -ne 0 ]
	then
		show_usage
	fi 
}

function remove_file_if_exists(){
	if [ -e "$1" ]; then
		rm -f $1
	fi
}

function create_output_file() {
	NUM_OF_CHUNKS=$1
	CHUNK_FILE=$2
	OUTPUTFILE_PATH=$3
	
	# Decide optimal buffer size according to number of chunks
	BUF_SIZE=$(echo "scale=0; sqrt ( $NUM_OF_CHUNKS )" | bc -l)
	echo "Buffer Size = $BUF_SIZE"

	# truncate output file if it exists or create it if it does not exist
	echo -n "" > "$OUTPUTFILE_PATH"
	remove_file_if_exists "$OUTPUTFILE_PATH.temp"
	i=0	
	while true
	do
		if [[ $i -ge $NUM_OF_CHUNKS ]]; then break; fi
		# buffer to make things extra fast
		if [ $i -lt $(($NUM_OF_CHUNKS-$BUF_SIZE)) ]
		then
			if [ ! -e "$OUTPUTFILE_PATH.temp" ]
			then
				echo -n "" > "$OUTPUTFILE_PATH.temp"
				# create a temp file
				for j in `seq 1 $BUF_SIZE`
				do
					cat $CHUNK_FILE >> "$OUTPUTFILE_PATH.temp"
				done
			fi
			cat "$OUTPUTFILE_PATH.temp" >> $OUTPUTFILE_PATH
			i=$(($i+$BUF_SIZE))
		else
			cat $CHUNK_FILE >> $OUTPUTFILE_PATH
			i=$(($i+1))
		fi
		echo -e -n "\r"$i
	done
	remove_file_if_exists "$OUTPUTFILE_PATH.temp"
	echo -e "\nFinished Successfully"
}

# Input variables
NUM_OF_CHUNKS=$1
CHUNK_FILE=$2
OUTPUTFILE_PATH=$3

# doing the real stuff
validate_inputs "$NUM_OF_CHUNKS" "$CHUNK_FILE" "$OUTPUTFILE_PATH"
show_info "$NUM_OF_CHUNKS" "$CHUNK_FILE" "$OUTPUTFILE_PATH"
create_output_file "$NUM_OF_CHUNKS" "$CHUNK_FILE" "$OUTPUTFILE_PATH"


