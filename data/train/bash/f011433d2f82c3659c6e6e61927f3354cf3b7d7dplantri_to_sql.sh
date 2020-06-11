#!/bin/bash
# Converts plantri output into sql INSERT statements
# Arguments of the script are passed to 'find'.
# Resulting INSERT statements insert at most CHUNK_SIZE rows at once.
# Example usage:
#	plantri_to_sql.sh ! -iname "*.*"
#	(converts every file without an extension)

CHUNK_SIZE=50000

for file in `find "$@"`; do
	echo "Processing $file..."
	sed \
		-e "s/\([0-9]\+\) \(.*\)/(\1, '\2'),/g" \
		-e "1~$CHUNK_SIZE iINSERT INTO graph (nvertices, ascii_code) VALUES" \
		-e "$CHUNK_SIZE~$CHUNK_SIZE s/),/);/" \
		-e "$ s/),/);/" $file > $file.sql
done

echo "Done."
