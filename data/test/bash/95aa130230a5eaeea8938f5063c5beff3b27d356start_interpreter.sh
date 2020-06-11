#/bin/bash
# Copyright (C) 2010-2012 Max Planck Society

set -e

. `dirname $0`/deseq_config.sh

export MATLAB_RETURN_FILE=`mktemp`

if [ "$INTERPRETER" == 'octave' ];
then
	echo exit | ${OCTAVE_BIN_PATH} --no-window-system --silent --eval "global SHELL_INTERPRETER_INVOKE; SHELL_INTERPRETER_INVOKE=1; addpath $DESEQ_SRC_PATH; deseq_config; $1($2); exit;" || (echo starting Octave failed; rm -f $MATLAB_RETURN_FILE; exit -1) ;
fi

if [ "$INTERPRETER" == 'matlab' ];
then
	echo exit | ${MATLAB_BIN_PATH} -nodisplay -r "global SHELL_INTERPRETER_INVOKE; SHELL_INTERPRETER_INVOKE=1; addpath $DESEQ_SRC_PATH; deseq_config; $1($2); exit;" || (echo starting Matlab failed; rm -f $MATLAB_RETURN_FILE; exit -1) ;
fi

test -f $MATLAB_RETURN_FILE || exit 0
ret=`cat $MATLAB_RETURN_FILE` ;
rm -f $MATLAB_RETURN_FILE
exit $ret

