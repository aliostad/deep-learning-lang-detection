#!/bin/sh
#
# Riverbed Model Data
# $Id: model_CX755H.sh 128727 2013-06-14 19:02:26Z balajir $
#
###############################################################################

# Changes made to this file need to be propagated to the official twiki
# applicance model data file located @ 
# http://internal/twiki/bin/view/NBT/ModelSpecificSoftwareParameters

# MODEL_SWAPSIZE  : MB (BINARY)
# MODEL_VARSIZE   : MB (BINARY)
# MODEL_DISKSIZE  : BYTES
# MODEL_BWLIMIT   : kbps
MODEL_MEMCHECK=3500
MODEL_SWAPSIZE=4096
MODEL_VARSIZE=15360
MODEL_ROOTSIZE=1024
MODEL_BOOTDEV=/dev/flash0
MODEL_DISKSIZE=155189248000
MODEL_DISKDEV=/dev/disk0
MODEL_DISKDEV_2=/dev/disk1
MODEL_STOREDEV=/dev/disk1p2
MODEL_SMBDEV=/dev/disk0p5
MODEL_SMBBYTES=100000000000
MODEL_DUALSTORE=false
MODEL_KERNELTYPE=smp
MODEL_MDRAIDDEV1=
MODEL_MDRAIDDEV2=
MODEL_MDRAIDSMBDEV1=
MODEL_MDRAIDSMBDEV2=
MODEL_ID=JA5
MODEL_LAYOUT=FLASHRRDM
MODEL_CLASS="CX755"
MODEL_FLEXL="CX755L CX755M CX755H"

MODEL_FTS=true
MODEL_FTS_PARTITION=2
MODEL_FTS_MEDIA="SSD"
MODEL_FTS_DISKSIZE_MB=147194
MODEL_LAST_PART_FILL=false    # do not fill up the last partition, set to "true" to fill the last partition or leave not add this variable

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

