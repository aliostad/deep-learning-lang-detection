#!/bin/bash

#!/bin/bash
# Argument = -r root -g grid -d dq2-client -p panda

usage()
{
cat << EOF
usage: $0 options

This script setups ATLAS using CVMFS

OPTIONS:
   -h Show this message
   -r load the ROOT environment
   -g load grid
   -d load the dq2 client
   -p load the panda scripts
EOF
}

loadRoot=false
loadGrid=false
loadDQ2=false
loadPanda=false
loadATLAS=false

while getopts h:r:g:d:p OPTION
do
     case "$OPTION" in
         h)
             usage
             ;;
         r)
	     echo "-Parameter: $OPTARG" >&2
#            loadRoot=$OPTARG
	     loadRoot=true
             loadATLAS=true
             ;;
         g)
             loadGrid=true
             loadATLAS=true
	     ;;
         d)
             loadDQ2=true
             loadATLAS=true
             ;;
         p)
             loadPanda=true
             loadATLAS=true
             ;;
         \?)
	    echo "Invalid option: -$OPTARG" >&2          
	    usage
             ;;
     esac
done

if $loadATLAS; then

	hostname -vi

	shopt -s expand_aliases

	export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
	setupfile=${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh
	alias setupATLAS='source $setupfile'

	type setupATLAS

	setupATLAS --quiet
fi

if $loadRoot; then
    localSetupROOT --quiet
fi

if $loadPanda; then
    localSetupPandaClient --noAthenaCheck
    voms-proxy-init -voms atlas -valid 120:00
fi

if $loadDQ2; then
    localSetupDQ2Client
    voms-proxy-init -voms atlas
fi

if $loadGrid; then
    localSetupPandaClient --noAthenaCheck
    localSetupDQ2Client
    voms-proxy-init -voms atlas -valid 120:00
fi

#trap 'setupATLAS --quiet; exit $?' INT TERM EXIT

#trap 'localSetupROOT --quiet; exit $?' INT TERM EXIT



#localSetupPython --pythonVersion=2.6.5p1-x86_64-slc5-gcc43 

#localSetupROOT --quiet 

#which root
#which python
#which gcc
