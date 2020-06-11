#!/bin/bash

#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Written (W) 2009-2010 Regina Bohnert, Gunnar Raetsch
# Copyright (C) 2009-2010 Max Planck Society
#

set -e

. `dirname $0`/rquant_config.sh

export MATLAB_RETURN_FILE=`tempfile`

if [ "$INTERPRETER" == 'octave' ];
then
	echo exit | ${OCTAVE_BIN_PATH} --eval "global SHELL_INTERPRETER_INVOKE; SHELL_INTERPRETER_INVOKE=1; addpath $RQUANT_SRC_PATH; rquant_config; $1($2); exit;" || (echo starting Octave failed; rm -f $MATLAB_RETURN_FILE; exit -1) ;
fi

if [ "$INTERPRETER" == 'matlab' ];
then
	echo exit | ${MATLAB_BIN_PATH} -nodisplay -r "global SHELL_INTERPRETER_INVOKE; SHELL_INTERPRETER_INVOKE=1; addpath $RQUANT_SRC_PATH; rquant_config; $1($2); exit;" || (echo starting Matlab failed; rm -f $MATLAB_RETURN_FILE; exit -1) ;
fi

test -f $MATLAB_RETURN_FILE || exit 0
ret=`cat $MATLAB_RETURN_FILE` ;
rm -f $MATLAB_RETURN_FILE
exit $ret


