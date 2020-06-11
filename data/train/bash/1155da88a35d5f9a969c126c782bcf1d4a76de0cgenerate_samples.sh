#!/bin/sh
#
# This file is part of sp-rtrace package.
#
# Copyright (C) 2010 by Nokia Corporation
#
# Contact: Eero Tamminen <eero.tamminen@nokia.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public License
# as published by the Free Software Foundation; either version 2 of
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02r10-1301 USA
#

#
# This script regenerates sample files used for postproc testcase in
# the case the output format was changed.
#

#
# Sample output
#

TARGET=../bin/shmseg_test

if [ ! -f $TARGET ]; then
	echo "The test application $TARGET is not present"
	exit 1
fi

sp-rtrace -s -e shmsysv -x $TARGET

LOG_RAW=$(ls *.rtrace)
if [ -z "$LOG_RAW" ]; then
	echo "Failed to generate binary log file."
	exit 1
fi

LOG_RAW=$(ls *.rtrace)
LOG_SAMPLE="sample.txt"

sp-rtrace-postproc -i $LOG_RAW > $LOG_SAMPLE
rm $LOG_RAW

sp-rtrace-postproc -i $LOG_SAMPLE > $LOG_SAMPLE.
sp-rtrace-postproc -i $LOG_SAMPLE -r > $LOG_SAMPLE.r
sp-rtrace-postproc -i $LOG_SAMPLE -lc > $LOG_SAMPLE.lc
sp-rtrace-postproc -i $LOG_SAMPLE -lcr > $LOG_SAMPLE.lcr

sp-rtrace-postproc -i $LOG_SAMPLE. > $LOG_SAMPLE..
sp-rtrace-postproc -i $LOG_SAMPLE. -r > $LOG_SAMPLE..r
sp-rtrace-postproc -i $LOG_SAMPLE. -lc > $LOG_SAMPLE..lc
sp-rtrace-postproc -i $LOG_SAMPLE. -lcr > $LOG_SAMPLE..lcr

sp-rtrace-postproc -i $LOG_SAMPLE.r > $LOG_SAMPLE.r.
sp-rtrace-postproc -i $LOG_SAMPLE.r -r > $LOG_SAMPLE.r.r
sp-rtrace-postproc -i $LOG_SAMPLE.r -lc > $LOG_SAMPLE.r.lc
sp-rtrace-postproc -i $LOG_SAMPLE.r -lcr > $LOG_SAMPLE.r.lcr

sp-rtrace-postproc -i $LOG_SAMPLE.lc > $LOG_SAMPLE.lc.
sp-rtrace-postproc -i $LOG_SAMPLE.lc -r > $LOG_SAMPLE.lc.r
sp-rtrace-postproc -i $LOG_SAMPLE.lc -lc > $LOG_SAMPLE.lc.lc
sp-rtrace-postproc -i $LOG_SAMPLE.lc -lcr > $LOG_SAMPLE.lc.lcr

sp-rtrace-postproc -i $LOG_SAMPLE.lcr > $LOG_SAMPLE.lcr.
sp-rtrace-postproc -i $LOG_SAMPLE.lcr -r > $LOG_SAMPLE.lcr.r
sp-rtrace-postproc -i $LOG_SAMPLE.lcr -lc > $LOG_SAMPLE.lcr.lc
sp-rtrace-postproc -i $LOG_SAMPLE.lcr -lcr > $LOG_SAMPLE.lcr.lcr


#
# context samples
#
TARGET=../bin/alloc_context_test

if [ ! -f $TARGET ]; then
	echo "The test application $TARGET is not present"
	exit 1
fi

sp-rtrace -s -e memory -x $TARGET

LOG_RAW=$(ls *.rtrace)
if [ -z "$LOG_RAW" ]; then
	echo "Failed to generate binary log file."
	exit 1
fi

LOG_RAW=$(ls *.rtrace)
LOG_SAMPLE="context.txt"

sp-rtrace-postproc -i $LOG_RAW > $LOG_SAMPLE
rm $LOG_RAW

sp-rtrace-postproc  -i $LOG_SAMPLE > $LOG_SAMPLE..
sp-rtrace-postproc -C0 -i $LOG_SAMPLE > $LOG_SAMPLE.C0.
sp-rtrace-postproc -C1 -i $LOG_SAMPLE > $LOG_SAMPLE.C1.
sp-rtrace-postproc -C2 -i $LOG_SAMPLE > $LOG_SAMPLE.C2.
sp-rtrace-postproc -C3 -i $LOG_SAMPLE > $LOG_SAMPLE.C3.
sp-rtrace-postproc -C4 -i $LOG_SAMPLE > $LOG_SAMPLE.C4.

sp-rtrace-postproc  -lci $LOG_SAMPLE > $LOG_SAMPLE..lc
sp-rtrace-postproc -C0 -lci $LOG_SAMPLE > $LOG_SAMPLE.C0.lc
sp-rtrace-postproc -C1 -lci $LOG_SAMPLE > $LOG_SAMPLE.C1.lc
sp-rtrace-postproc -C2 -lci $LOG_SAMPLE > $LOG_SAMPLE.C2.lc
sp-rtrace-postproc -C3 -lci $LOG_SAMPLE > $LOG_SAMPLE.C3.lc
sp-rtrace-postproc -C4 -lci $LOG_SAMPLE > $LOG_SAMPLE.C4.lc

#~ sp-rtrace-postproc  -lcri $LOG_SAMPLE > $LOG_SAMPLE..lcr
#~ sp-rtrace-postproc -C1 -lcri $LOG_SAMPLE > $LOG_SAMPLE.C1.lcr
#~ sp-rtrace-postproc -C2 -lcri $LOG_SAMPLE > $LOG_SAMPLE.C2.lcr
#~ sp-rtrace-postproc -C3 -lcri $LOG_SAMPLE > $LOG_SAMPLE.C3.lcr
#~ sp-rtrace-postproc -C4 -lcri $LOG_SAMPLE > $LOG_SAMPLE.C4.lcr

#
# resource filtering samples
#
#
TARGET=../bin/shmseg_test

if [ ! -f $TARGET ]; then
	echo "The test application $TARGET is not present"
	exit 1
fi

sp-rtrace -s -e shmsysv -x $TARGET

LOG_RAW=$(ls *.rtrace)
if [ -z "$LOG_RAW" ]; then
	echo "Failed to generate binary log file."
	exit 1
fi

#LOG_RAW=$(ls *.rtrace)
#LOG_SAMPLE="resource.txt"

#sp-rtrace-postproc -i $LOG_RAW > $LOG_SAMPLE
#rm $LOG_RAW

#sp-rtrace-postproc  -i $LOG_SAMPLE > $LOG_SAMPLE..
#sp-rtrace-postproc -R1 -i $LOG_SAMPLE > $LOG_SAMPLE.R1.
#sp-rtrace-postproc -R2 -i $LOG_SAMPLE > $LOG_SAMPLE.R2.
#sp-rtrace-postproc -R3 -i $LOG_SAMPLE > $LOG_SAMPLE.R3.

#sp-rtrace-postproc  -lci $LOG_SAMPLE > $LOG_SAMPLE..lc
#sp-rtrace-postproc -R1 -lci $LOG_SAMPLE > $LOG_SAMPLE.R1.lc
#sp-rtrace-postproc -R2 -lci $LOG_SAMPLE > $LOG_SAMPLE.R2.lc
#sp-rtrace-postproc -R3 -lci $LOG_SAMPLE > $LOG_SAMPLE.R3.lc

