#!/usr/bin/env bash -e

function oneTimeSetUp() {
	source $DOTSPLAT_FN_SRC
}

function testGenerateCastle() {
	$DOTSPLAT_FN --batch generate my_repo > /dev/null
	local repo_path="$DOTSPLAT/repos/my_repo"
	assertSame "\`generate' did not exit with status 0" 0 $?
	assertTrue "\`generate' did not create the repo \`my_repo'" "[ -d \"$repo_path\" ]"
	rm -rf "$repo_path"
}

function testGenerateCastleWithSpaces() {
	$DOTSPLAT_FN --batch generate my\ repo > /dev/null
	local repo_path="$DOTSPLAT/repos/my repo"
	assertSame "\`generate' did not exit with status 0" 0 $?
	assertTrue "\`generate' did not create the repo \`my repo'" "[ -d \"$repo_path\" ]"
	rm -rf "$repo_path"
}

source $SHUNIT2
