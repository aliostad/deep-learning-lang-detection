#!/bin/bash -eu
# test setting environment variables

source testenv.sh
source set-vars-from-args.sh -t 10 file:///tmp/foo.git init {1..2}

_testname set variable values
[ "$repo" = "/tmp/foo.git" ] ||
  die "repo is '$repo'"
[ "$initialize_blank_repo" = "true" ] ||
  die "initialize_blank_repo is '$initialize_blank_repo'"
[ "$commits" = "1 2" ] ||
  die "commits are '$commits'"
[ "$clone" = "foo" ] ||
  die "clone is '$clone'"
[ "$readme" = "README.foo" ] ||
  die "readme is '$readme'"
[ "$seconds" = "10" ] ||
  die "seconds are '$seconds'"
