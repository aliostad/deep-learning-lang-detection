#!/bin/sh
#
# Riverbed Model Data
# $Id: model_EX1260H_2.sh 111975 2012-09-26 23:34:49Z msmith $
#
###############################################################################

# Changes made to this file need to be propagated to the official twiki
# applicance model data file located @ 
# http://internal/twiki/bin/view/NBT/ModelSpecificSoftwareParameters

# MODEL_SWAPSIZE  : MB (BINARY)
# MODEL_VARSIZE   : MB (BINARY)
# MODEL_DISKSIZE  : BYTES
# MODEL_BWLIMIT   : kbps
MODEL_MEMCHECK=7900
MODEL_SWAPSIZE=7900
MODEL_VARSIZE=15360
MODEL_ROOTSIZE=3096
MODEL_BOOTDEV=/dev/flash0
MODEL_DISKSIZE=65000000000
MODEL_DISKDEV=/dev/disk0
MODEL_STOREDEV=/dev/disk8p2
MODEL_SMBDEV=
MODEL_SMBBYTES=
MODEL_DUALSTORE=false
MODEL_KERNELTYPE=smp
MODEL_MDRAIDDEV1=
MODEL_MDRAIDDEV2=
MODEL_MDRAIDSMBDEV1=
MODEL_MDRAIDSMBDEV2=
MODEL_ID=F85
MODEL_LAYOUT=FLASHRRDM
MODEL_CLASS="EX1260"
MODEL_FLEXL="EX1260L_2 EX1260M_2 EX1260H_2"
MODEL_TMPFSSIZE=2048
# The virtual mfg tag indicates that mfg should not use
# a sport id in mfg.
MODEL_FTS=true
MODEL_FTS_PARTITION=2
MODEL_FTS_MEDIA="SSD"
MODEL_FTS_DISKSIZE_MB=66048

do_pre_writeimage_actions()
{
    return
}

do_extra_mfdb_actions()
{
    return
}

do_extra_initialdb_actions()
{
    return
}

