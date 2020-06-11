#! /lusr/bin/tcsh -f

# Were the correct number of arguments passed?
if ($#argv != 3) then

    echo $0 \<page image trace\> \
	    \<fix endianness\?\> \
	    \<pages per chunk\>
    exit

endif

# Give useful names to the arguments.
set pageImageTrace = $1
set fixEndianness = $2
set pagesPerChunk = $3

# Some useful variables.
set pageSize = 4096
set enableMicrotiming = /usr/proc/bin/ptime
set beNice = "nice +15"
set timingUtility = ${HOME}/oops/Page-Compress/utilities/${HOSTTYPE}/test-compression

# Begin timing.
echo Creating compressibility trace...
${beNice} ${enableMicrotiming} ${timingUtility} ${pageImageTrace} ${pageSize} ${fixEndianness} 0 ${pagesPerChunk}
echo done with compressibility trace.
