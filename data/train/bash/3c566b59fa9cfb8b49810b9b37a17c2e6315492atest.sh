#!/bin/sh

cd $(dirname $(realpath $(cygpath --unix $0)))

no_deploy=0
while [ ! -z "$1" ]; do
    if [ "$1" = "--no-deploy" ]; then
      no_deploy=1
    fi
    shift
done

[ "$no_deploy" = "0" ] && ./deploy.sh

[ "$WOT_DIRECTORY" = "" ] && WOT_DIRECTORY=/cygdrive/d/work/games/WoT
CURRENT_DIRECTORY=`pwd`

SAMPLE_REPLAY=test.wotreplay
#SAMPLE_REPLAY=test2.wotreplay
#SAMPLE_REPLAY=cw.wotreplay
#SAMPLE_REPLAY=sunk.wotreplay
#SAMPLE_REPLAY=tk.wotreplay

cd "${WOT_DIRECTORY}"
REPLAY=${CURRENT_DIRECTORY}/../utils/replays/${SAMPLE_REPLAY}
cmd /c start ./WorldOfTanks.exe `cygpath --windows $REPLAY`
