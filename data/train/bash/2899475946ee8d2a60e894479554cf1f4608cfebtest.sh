#!/bin/sh

cd $(dirname $(realpath $(cygpath --unix $0)))

sh deploy.sh

WOT_DIRECTORY=/cygdrive/d/home/max/WoT
CURRENT_DIRECTORY=`pwd`

#SAMPLE_REPLAY=15.wotreplay
#SAMPLE_REPLAY=fogofwar.wotreplay
#SAMPLE_REPLAY=markers.wotreplay
SAMPLE_REPLAY=squad.wotreplay
#SAMPLE_REPLAY=tk,blowup.wotreplay

cd ${WOT_DIRECTORY}
REPLAY=${CURRENT_DIRECTORY}/../test/replays/${SAMPLE_REPLAY}
#cmd /c start ./WorldOfTanks.exe `cygpath --windows $REPLAY`
cmd /c start ./wot-xvm-proxy.exe /debug `cygpath --windows $REPLAY`
#cmd /c start ./wot-xvm-proxy.exe `cygpath --windows $REPLAY`
