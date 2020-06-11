#!/bin/bash

#   locale
export LC_ALL="C"
export LANG="C"
export LANGUAGe="C"

export SAFE_EXECUTE_VERBOSE=1

#   source
source base_func.sh

root_dir="$(pwd)"
work_dir="${root_dir}/work"

safe_mkdir "${work_dir}"

#   eval bracket
safe_execute "./evalb -p sample/sample.prm sample/sample.gld sample/sample.tst > ${work_dir}/my.rsl"

if diff ${work_dir}/my.rsl sample/sample.revised.rsl > ${work_dir}/diff.txt
then
    echo "passed" 1>&2
else
    echo "diff failed, see ${work_dir}/diff.txt" 1>&2
    exit 1
fi

exit 0

