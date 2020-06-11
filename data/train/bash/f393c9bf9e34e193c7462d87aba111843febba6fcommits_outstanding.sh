#!/bin/bash
BARCLAMPS="/VMs/repos/crowbar1/crowbar/barclamps/"
SOURCE_REPO="release/mesa-1.6.1/master"
TARGET_REPO="release/roxy/master"
TOTAL=0

for x in `ls ${BARCLAMPS}`; do
        cd ${BARCLAMPS}/${x}
        TOTAL_THIS_BC=$(git --no-pager log --pretty=oneline --no-merges ${TARGET_REPO}..${SOURCE_REPO} 2>/dev/null | wc -l)
        echo "$(git --no-pager log --pretty=oneline --no-merges ${TARGET_REPO}..${SOURCE_REPO} 2>/dev/null | wc -l) commits outstanding in ${x}"
	TOTAL=$(($TOTAL + $TOTAL_THIS_BC))
done

echo "Total for ${TARGET_REPO}..${SOURCE_REPO} : ${TOTAL}"

