#!/bin/sh

PROLOG="swipl -L0 -G0"
PROLOG="swipl"
RUBY="/usr/bin/ruby"

function help {
cat << ENDHELP
 Train a HMM on a particular input sequence
 The program expects following arguments:
 1: A HMM definition file 
 2: An input data file
 3: User constraints file
 4: An output file for saving the trained HMM 
 5: The chunk size to use
 6: History size (optional, default=0)
 7: Future window (optional, default=0)
ENDHELP
}

# Arguments parsing
if [ $# -lt 5 ]; then
	echo "To few arguments!"
	echo $@
	help
	exit -1
fi 

HMM_DEF_FILE=$1
INPUT_DATA_FILE=$2
USER_CONSTRAINT_FILE=$3
OUTPUT_FILE=$4
CHUNK_SIZE=$5

if [ x$6 = x ]; then
	HISTORY_SIZE=1
else
	HISTORY_SIZE=$6
fi

if [ x$7 = x ]; then
	FUTURE_SIZE=0
else
	FUTURE_SIZE=$7
fi


# Remove old configuration file
if [ -f configuration.pl ]; then
	rm -f configuration.sh
fi

# Create temporary file for running chunk split goals 
#cat <<EOF > chunksplit.pl
#chunk_size($CHUNK_SIZE).
#:- ['util.pl'].
#:- chunksplit_data_file('$INPUT_DATA_FILE').
#:- halt.
#EOF

# Remove any previous datachunk files
rm -f datachunk*
rm -f datachunk_meta.pl

# Chunk input file into the 
echo "Splitting file $INPUT_DATA_FILE into chunks of $CHUNK_SIZE atoms"
#$PROLOG -s chunksplit.pl
#rm -f chunksplit.pl
$RUBY chunk.rb $INPUT_DATA_FILE $CHUNK_SIZE

# Find number and sequence of chunks
total_chunks=`cat datachunk_metadata.pl |grep "chunks_total"|cut -f 2 -d "("|cut -f 1 -d ")"`
chunk_sequence=""
from=1
while [ $from -le $total_chunks ]
do
	chunk_sequence="$chunk_sequence $from"
	from=$[$from+1]
done

function chunk_training_program {
	echo ":- ['datachunk_metadata.pl']."
	echo ":- ['train.pl']." 
	echo ":- ['$USER_CONSTRAINT_FILE']."
	echo ":- ['current_chunkfile.pl']."
	echo ":- train_chunk('$HMM_DEF_FILE','$OUTPUT_FILE',$1,$HISTORY_SIZE,$FUTURE_SIZE)."
}

echo "future size: $FUTURE_SIZE"

# Train for each chunk
for i in $chunk_sequence
do
	# Prepare chunk: Add future window if possible
	chunkfile="datachunk$i.pl"
	cp $chunkfile current_chunkfile.pl
	next=$[$i+1]
	nextchunkfile="datachunk$next.pl"
	if [ $FUTURE_SIZE -gt 0 ]; then
		if [ -f $nextchunkfile ]; then
			head -n $FUTURE_SIZE $nextchunkfile >> current_chunkfile.pl
		fi
	fi
	echo "Preparated chunk $i"
	
	# Train chunk
	chunk_training_program $i > tmp_train.pl
	#cat tmp_train.pl
	$PROLOG -s tmp_train.pl
done

# Cleanup
rm -f current_chunkfile.pl
rm -f datachunk*
rm -f tmp_train.pl
