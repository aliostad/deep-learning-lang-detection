#!/usr/bin/env bash

# pngchunkextract.sh
# This script extracts data hidden in file with pngchunkinsert.sh.
# pngchunkinsert.sh © deterenkelt 2014

# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 3 of the License,
# or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but without any warranty; without even the implied warranty
# of merchantability or fitness for a particular purpose.
# See the GNU General Public License for more details.

# See pngchunkinsert.sh for details on PNG file structure.

# Requires:
# GNU bash-4.2 or higher
# GNU grep-2.9 or higher
# GNU sed-4.2.1 or higher
# xdg-mime (usually found in xdg-utils)

show_usage() {
cat <<EOF
Usage:
./pngchunkextract.sh <file> <chunk_name> [output_file_name]
EOF
}

[ "$#" -eq 1 ] && [ "$1" = '-h' -o "$1" = '--help' ] || [ "$#" -eq 0 ] && show_usage && exit 0

source_file="$1"
chunk_name="$2"
output_file="$3"

[ -r "$source_file" ] || { echo "Can’t read file: “$source_file”." >&2; exit 1; }
[[ "$chunk_name" =~ ^[a-zA-Z]{4}$ ]] || {
	echo "Invalid chunk name: “$chunk_name”." >&2
	exit 2
}
[ "$output_file" ] || output_file=ext_`date +%s | sed -r 's/.*(.{5})$/\1/'`

possible_offsets=`grep --text --byte-offset --only-matching \
                       "$chunk_name" "$source_file" \
                  | sed -r 's/^([0-9]+):.*/\1/g'`

while read offset; do
	hex_size="`od -j $((offset-4)) -N 4 -A n -t x1 "$source_file" | sed 's/\s//g'`"
	[[ "$hex_size" =~ ^[0-9abcdef]{8}$ ]] || {
		echo 'Couldn’t compute hexadecimal value of the chunk length.' >&2
		exit 3
	}
	dec_size=$((16#$hex_size))
	# 4 bytes for chunk name, 4 for chunk CRC and 12 for IEND chunk.
	[ "$((`stat --format %s "$source_file"` - offset - 20 ))" -eq "$dec_size" ] \
		&& chunk_is_found=t && echo "Found chunk at offset $offset of size $dec_size." && break
done <<<"$possible_offsets"

[ -v chunk_is_found ] && {
	dd bs=1 count=$dec_size if="$source_file" of="$output_file" skip=$((offset+4))
	file -L "$output_file"
	read -p 'Would you like to open it? [Y/n] > '
	[[ "$REPLY" =~ ^[Nn]$ ]] || $(xdg-mime query default \
		$(xdg-mime query filetype "$output_file") \
		| sed -r 's/^(.*)\.desktop$/\1/') "$output_file"
	[ 1 -eq 1 ]
} || echo 'No appropriate chunk was found.' >&2


