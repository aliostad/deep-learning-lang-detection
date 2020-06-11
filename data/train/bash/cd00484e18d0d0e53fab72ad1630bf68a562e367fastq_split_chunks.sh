#!/bin/bash
#######################################################################
#
# Self-submitting Qsub script.
# 
# fastq_split_chunks.sh [-debug|-inline] FASTQ CHUNK_COUNT [CHUNK_INDEX]
#
########################################################################
# libraries to load
. /etc/profile.d/modules.sh          # enable module loading
. ~/uab_ngs/uab_ngs_functions_v2.sh  # load shared run_cmd() & run_step()
#*** QSUB FLAGS ***
#$ -S /bin/bash
#$ -cwd # remember what dir I'm launched in 
#$ -V   # need this for parameter passing from MASTER to SLAVE!
#$ -m beas  #email at:  Begining, End, Abort, Suspend
# *** output logs ***
#$ -j y # merge stderr into stdout
#$ -o jobs/$JOB_NAME.$JOB_ID.out
#*** END QSUB ****
# run time
QSUB_TIME_DRMAA="-l h_rt=119:00:00 -l s_rt=120:55:00 " # 5 days
QSUB_MACH_DRMAA="-l vf=2G -l h_vmem=2G" # 1 CPUs, 2G

QSUB_TASK_NAME=fastq_split
# things we'll parse for
CMD_LINE_PARAM_LIST="FASTQ CHUNK_COUNT"
# things we'll report on 
DERIVED_VAR_LIST="CMD_LINE HOSTNAME PROJECT_DIR " 
export DERIVED_VAR_LIST="$DERIVED_VAR_LIST CHUNK_BYTE_COUNT"

# load needed modules 
#module load ngs-ccts/bwa.0.6.2

#====================================================================== 
# MASTER: submit-self on a head-node
#====================================================================== 
if [[ -z "$JOB_ID" || "$1" == "-inline" ]]; then
    
    # --------------------------
    # parse parameters
    # --------------------------
    parse_params $*
    shift $parse_params_shift_count

    # --------------------------
    # job SETUP
    # --------------------------
    mkdir -p jobs
    export CHUNK_LIST=$1
    if [ -n "$CHUNK_INDEX" ]; then
	# extract the listed chunk
	export CHUNK_LIST=$CHUNK_INDEX
    fi
    if [ -z $CHUNK_LIST ]; then
	# make a list of all chunk indexes
	export PRE_LIST=`echo {1..$CHUNK_COUNT}`
	export CHUNK_LIST=`eval "echo $PRE_LIST"`
    fi

    echo "FASTQ=$FASTQ"
    echo "CHUNK_LIST=$CHUNK_LIST"
    if [ ! -e "$FASTQ" ]; then 
	echo "ERROR: file not found: $FASTQ"
	exit 1 2>&1 >/dev/null
    fi

    export FASTQ_LEN=`wc -c $FASTQ | cut -d " " -f 1`
    echo "FASTQ_LEN=$FASTQ_LEN"

    export READ_LEN=`head -n 4 $FASTQ | wc -c`
    echo "READ_LEN=$READ_LEN"

    export READ_COUNT=$(( FASTQ_LEN / $READ_LEN ))
    echo "READ_COUNT=$READ_COUNT"

    export CHUNK_READ_COUNT=$(( $READ_COUNT / $CHUNK_COUNT ))
    echo "CHUNK_READ_COUNT=$CHUNK_READ_COUNT"

    export CHUNK_BYTE_COUNT=$(( $CHUNK_READ_COUNT * $READ_LEN ))
    echo "CHUNK_BYTE_COUNT=$CHUNK_BYTE_COUNT"

    export OUTBASE=`basename $FASTQ .fastq`
    echo "OUTBASE=$OUTBASE"

    # --------------------------
    # QSUB myself to do the work on a node
    # --------------------------
    for INDEX in $CHUNK_LIST; do

	# INDEX setup
	export CHUNK_INDEX=$INDEX
	export OUTFILE=$OUTBASE.$CHUNK_COUNT.$CHUNK_INDEX.fastq
	export SAMPLE_NAME=$OUTBASE.$CHUNK_COUNT.$CHUNK_INDEX
	export QSUB_NAME=${QSUB_TASK_NAME}-${SAMPLE_NAME}

	if [ -z "$JOB_ID" ]; then
	    echo -n "${QSUB_TASK_NAME}:${SAMPLE_NAME}:QSUB:"
	    if [[ $0 == /* ]]; then JOB_SCRIPT=$0; else JOB_SCRIPT=`pwd`/$0; fi
	    qsub -terse \
		$QSUB_TIME_DRMAA $QSUB_MACH_DRMAA \
		-N $QSUB_NAME \
		-M $USER@uab.edu \
		$JOB_SCRIPT
	    if [ $? != 0 ]; then echo "ERROR: bad return code from QSUB"; qsub_exit 1; fi
	else
	    echo "[debug] skipped qsub: $JOB_ID"
	    export JOB_NAME=$QSUB_NAME
	    $0
	    RC=$?
	    if [ $? != 0 ]; then echo "ERROR: bad return code from slave $0: $RC"; qsub_exit $RC; fi
	fi

    done
    qsub_exit 0
fi

#====================================================================== 
# actual slave work
#====================================================================== 
if [ -n "$JOB_ID"  ]; then
    echo "-- environment --"
    echo "SAMPLE_NAME=$SAMPLE_NAME"
    echo "JOB_NAME=$JOB_NAME"
    echo "JOB_ID=$JOB_ID"
    echo "NSLOTS=$NSLOTS"
    echo "-- cmd line params -- "
    print_cmd_line_params
    echo "-- derived params -- "
    print_derived_params

    echo "I'm a qsub slave: "

    echo "CHUNK_INDEX=$CHUNK_INDEX"
    CHUNK_START=$(( ($CHUNK_INDEX - 1 ) * $CHUNK_BYTE_COUNT ))
    echo "CHUNK_START=$CHUNK_START"

    # STEP: write hello file
    # run_step(SAMPLE_NAME,TARGET,STEP_NAME,STDOUT,cmd...)
    HELLO_OUT=${SAMPLE_NAME}.hello.txt
    run_step $SAMPLE_NAME $OUTFILE "extract_chunk($CHUNK_INDEX)" - \
	dd bs=1 skip=$CHUNK_START count=$CHUNK_BYTE_COUNT if=$FASTQ of=$OUTFILE

    qsub_exit 0
fi

# 




done
