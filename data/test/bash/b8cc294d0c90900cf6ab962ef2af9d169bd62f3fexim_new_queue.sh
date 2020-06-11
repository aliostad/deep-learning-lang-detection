#!/bin/bash

BASE=/var/spool/exim
DEEP="msglog input"
SHALLOW="db"

die() { echo "$*" >&2 ; exit 1 ; }

set -e

[[ -d $BASE ]] || die "Directory $BASE doesn't exist"

I=1
while [[ -e $BASE.$I ]]; do I=$(( $I + 1 )); done
SAVE="$BASE.$I"
mkdir -p "$SAVE"

cd "$BASE"
for D in $DEEP; do
	SAVED="$SAVE/$D"
	mkdir -p "$SAVED"	
	cd "$BASE/$D"
	for E in *; do
		[[ -d $E ]] || continue
		mv "$E" "$SAVED/$E"
		mkdir "$E"
		chown --ref "$SAVED/$E" "$E"
		chmod --ref "$SAVED/$E" "$E"
	done
done

cd "$BASE"
for D in $SHALLOW; do
	mv $D "$SAVE/$D"
	mkdir -p "$D"
	chown --ref "$SAVE/$D" "$D"
	chmod --ref "$SAVE/$D" "$D"	
done

