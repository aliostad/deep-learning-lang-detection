#!/bin/bash

if [ $# != 3 ]
	then
		echo "Fetch all key-value pairs of a file."
		echo "Usage: $0 db_file sample_path filename"
		exit 1
fi

DBPATH=$1
SAMPLE_PATH=$2
FILENAME=$3

sqlite3 $DBPATH "SELECT key, value FROM sample_metadata \
	INNER JOIN keys ON sample_metadata.key_id=keys.key_id \
	INNER JOIN values_table ON sample_metadata.value_id=values_table.value_id \
	WHERE file_id IN ( \
		SELECT file_id FROM sample_files WHERE filename='$FILENAME' \
	) AND path_id IN ( \
		SELECT path_id FROM paths WHERE path='$SAMPLE_PATH' \
	);"

