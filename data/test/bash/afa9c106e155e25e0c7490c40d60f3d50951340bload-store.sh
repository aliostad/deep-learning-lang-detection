#!/bin/bash

test "${#}" -eq 1 || exit 1

. ./sh/tools.sh || exit 1

load ()
{
	test "${#}" -eq 2 || fail
	info "Loading database [./store/bdb/${2}] <- [./dumps/${1}.${2}.bz2]..."
	bzip2 --decompress <"./dumps/${1}.${2}.bz2" | exe1 db_load -h ./store/bdb "${2}" || fail
	return 0
}

./sh/clear-store.sh || fail

load "${1}" documents || fail
load "${1}" document-titles || fail
load "${1}" document-contents || fail
load "${1}" document-stems || fail
load "${1}" document-vectors || fail
load "${1}" document-to-sha512 || fail
load "${1}" sha512-to-document || fail
load "${1}" blobs || fail

succeed
