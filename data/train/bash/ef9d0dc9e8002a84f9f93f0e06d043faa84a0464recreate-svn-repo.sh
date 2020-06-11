#!/bin/bash

loadRevision () {

	REV=$1
	bzcat sample-r$1.dump.bz2 | svnadmin load ./sample-repo

}

rm -rf sample-repo && svnadmin create sample-repo


loadRevision 0
loadRevision 1
loadRevision 2
loadRevision 3
loadRevision 4
loadRevision 5
loadRevision 6
loadRevision 7
loadRevision 8
loadRevision 9
loadRevision 10
loadRevision 11
loadRevision 12
loadRevision 13
loadRevision 14
loadRevision 15
loadRevision 16
loadRevision 17
loadRevision 18
loadRevision 19
loadRevision 20
loadRevision 21
loadRevision 22
loadRevision 23
loadRevision 24
loadRevision 25
loadRevision 26
loadRevision 27

