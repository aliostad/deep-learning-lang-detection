#!/bin/sh

# Set env var
export RSSS_DATA_DIR=/scratch/fh293/data/RSSS
# export RSSS_MMSEQ_DIR=/scratch/fh293/privateapps/mmseq/0.11.2a
export RSSS_MMSEQ_DIR=/scratch/fh293/privateapps/mmseq

loadModules () {
    # Load modules
    module load use.own
    # module load bowtie/0.12.8
    # module load mmseq-new/1.0.7
    # module load mmseq-old
    # module load boost/1.55
    # module load cufflinks/1.3.0
    # module load tophat/1.4.1
    ## module load samtools/1.0
 
    module load bowtie/1.1.0
    module load zlib
    module load armadillo
    module load boost
    module load mmseq/1.0.8a
    module load cufflinks/2.2.1
    module load tophat/2.0.12

    module load samtools/0.1.19
    module load oases/0.2.08
    module load velvet/1.2.10
    module load python/2.7.3
    module load NumPY/1.7.1
    module load rpy2/2.3.8
    module load biopython/1.62
}

runCoveragePipeline () {
    loadModules
    python ./coverage/coverage.py
}

runSensSpecPipeline () {
    loadModules
    python ./sens_prec/sens_prec.py
}

runTestPipeline () {
    loadModules
    python ./test_pipeline/test_pipeline.py
}

runUnitTests () {
    loadModules
    python ./test_pipeline/unittests.py
}


usage() { 
	echo "Usage: $0 [-h] [-c] [-s] [-t] [-u]
where:
       -h: show this help text
       -c: run coverage pipeline  
       -s: run sens_spec pipeline
       -t: run test pipeline
       -u: run unit tests"

     1>&2
     exit 1 
 }

#--------------------

while getopts "cst" o; do
    case "${o}" in
        c)
        runCoveragePipeline
        ;;
	    s)
	    runSensSpecPipeline
	    ;;
        t)
	    runTestPipeline
  	    ;;
        u)
        runUnitTests
        ;;
        ?) 
            usage
            ;;	
    esac
done
shift $((OPTIND-1))

if [ "$1" != -* ]; then
    usage
fi