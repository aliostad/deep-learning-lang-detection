#/bin/bash
set -e

. `dirname $0`/rdiff_config.sh

export MATLAB_RETURN_FILE=`mktemp -t rDiff.XXXXXXXXXX.tmp` 


if [ "$RDIFF_INTERPRETER" == 'octave' ];
then
	echo exit | ${RDIFF_OCTAVE_BIN_PATH} --no-window-system -q --eval "global SHELL_INTERPRETER_INVOKE; SHELL_INTERPRETER_INVOKE=1; warning('off', 'Octave:shadowed-function'); warning('off', 'Octave:deprecated-function') ; addpath $RDIFF_SRC_PATH;  $1('$2'); exit;" || (echo starting Octave failed; rm -f $MATLAB_RETURN_FILE; exit -1) ;
fi

if [ "$RDIFF_INTERPRETER" == 'matlab' ];
then
	echo exit | ${RDIFF_MATLAB_BIN_PATH} -nodisplay -r "global SHELL_INTERPRETER_INVOKE; SHELL_INTERPRETER_INVOKE=1; addpath $RDIFF_SRC_PATH;  $1('$2'); exit;" || (echo starting Matlab failed; rm -f $MATLAB_RETURN_FILE; exit -1) ;
fi

test -f $MATLAB_RETURN_FILE || exit 0
ret=`cat $MATLAB_RETURN_FILE` ;
rm -f $MATLAB_RETURN_FILE
exit $ret


