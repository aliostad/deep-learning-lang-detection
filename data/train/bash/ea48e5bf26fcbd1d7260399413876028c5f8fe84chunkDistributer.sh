#!/bin/bash 
#
# BEGIN_COPYRIGHT
#
# This file is part of SciDB.
# Copyright (C) 2008-2014 SciDB, Inc.
#
# SciDB is free software: you can redistribute it and/or modify
# it under the terms of the AFFERO GNU General Public License as published by
# the Free Software Foundation.
#
# SciDB is distributed "AS-IS" AND WITHOUT ANY WARRANTY OF ANY KIND,
# INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,
# NON-INFRINGEMENT, OR FITNESS FOR A PARTICULAR PURPOSE. See
# the AFFERO GNU General Public License for the complete license terms.
#
# You should have received a copy of the AFFERO GNU General Public License
# along with SciDB.  If not, see <http://www.gnu.org/licenses/agpl-3.0.html>
#
# END_COPYRIGHT
#
# Usage ./chunkGenerator config(tiny,small,very_small,normal) numChunk numChunkPerInstance ServerNum
#
for ((i=0; i<$3; i++)); 
do
  chunk=$(($i*$2/$3+$4))
  echo "$4 $chunk"
  ./ssdbgen -n $2 -i $chunk -s -c $1 ./tileData >> bench 
  echo ";" >> bench
done
