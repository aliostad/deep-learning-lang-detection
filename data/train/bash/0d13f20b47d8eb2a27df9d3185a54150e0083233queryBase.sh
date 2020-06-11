#!/bin/bash
# HDF Set Query

source `dirname $0`/../conf/express-env.sh;
CLASS=express.hdd.HDFSetQuery;

pureQuery() {
	local DataSize=$1;
	local PartitionOffset=$2;
	local PartitionRecordLength=$3;
	local PartitionSize=$4;
	local ChunkOffsets=$5;
	local ChunkLengths=$6;
	local InputDirectory=$7;
	local OutputDirectory=$8;

	echo "pureQuery $@";
	$EXEC jar $JAR $CLASS ${DataSize} ${PartitionOffset} ${PartitionRecordLength} ${PartitionSize} "${ChunkOffsets}" "${ChunkLengths}" ${InputDirectory} ${OutputDirectory} 'true';
}

eval "$@";
