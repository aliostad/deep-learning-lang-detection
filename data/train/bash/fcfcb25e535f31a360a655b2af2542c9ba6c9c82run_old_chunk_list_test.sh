#!/bin/sh

##
## This file is part of the Score-P software (http://www.score-p.org)
##
## Copyright (c) 2009-2013,
## Technische Universitaet Dresden, Germany
##
## This software may be modified and distributed under the terms of
## a BSD-style license.  See the COPYING file in the package base
## directory for details.
##

## file       test/OTF2_Old_Chunk_List_test/run_old_chunk_list_test.sh

set -e

cleanup()
{
    rm -rf OTF2_OLD_CHUNK_LIST_TEST_PATH
}
trap cleanup EXIT

cleanup
$VALGRIND ./OTF2_Old_Chunk_List_test
