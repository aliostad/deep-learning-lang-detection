#time $OPENAIR_TARGETS/SIMU/PROC/eNB_Process -i0 -n200 >/dev/null &
#time $OPENAIR_TARGETS/SIMU/PROC/eNB_Process -i1 -n200 >/dev/null &
#time $OPENAIR_TARGETS/SIMU/PROC/eNB_Process -i2-n200 >/dev/null &
#time $OPENAIR_TARGETS/SIMU/PROC/ue_Process -i0 -n200 >/dev/null &
#time $OPENAIR_TARGETS/SIMU/PROC/ue_Process -i1 -n200 >/dev/null &
#time $OPENAIR_TARGETS/SIMU/PROC/ue_Process -i2 -n200 >/dev/null &
#time $OPENAIR_TARGETS/SIMU/PROC/ue_Process -i3 -n200 >/dev/null &
#time $OPENAIR_TARGETS/SIMU/PROC/ue_Process -i4 -n200 >/dev/null &
#time $OPENAIR_TARGETS/SIMU/PROC/ue_Process -i5 -n200 >/dev/null &
#time $OPENAIR_TARGETS/SIMU/PROC/ue_Process -i6 -n200 >/dev/null &
#time $OPENAIR_TARGETS/SIMU/PROC/ue_Process -i7 -n200 >/dev/null &
#time $OPENAIR_TARGETS/SIMU/PROC/channel -b1 -u4 -n50

#valgrind --tool=callgrind --collect-bus=yes --branch-sim=yes $OPENAIR_TARGETS/SIMU/PROC/channel -b1 -u1 -n2


