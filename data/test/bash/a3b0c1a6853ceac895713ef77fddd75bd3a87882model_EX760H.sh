#!/bin/sh
#
# Riverbed Model Data
# $Id: model_EX760H.sh 113250 2012-10-19 22:32:47Z clala $
#
###############################################################################

# Changes made to this file need to be propagated to the official twiki
# applicance model data file located @ 
# http://internal/twiki/bin/view/NBT/ModelSpecificSoftwareParameters

MODEL_MEMCHECK=15800
MODEL_SWAPSIZE=8000
MODEL_VARSIZE=30720
MODEL_ROOTSIZE=2200
MODEL_BOOTDEV=/dev/disk0
MODEL_BOOTDEV_2=
MODEL_DISKSIZE=148951269376
MODEL_DISKDEV=/dev/disk1
MODEL_DISKDEV_2=
MODEL_STOREDEV=/dev/disk0p9
MODEL_SMBDEV=
MODEL_SMBBYTES=
MODEL_DUALSTORE=false
MODEL_KERNELTYPE=smp
MODEL_MDRAIDDEV1=
MODEL_MDRAIDDEV2=
MODEL_MDRAIDSMBDEV1=
MODEL_MDRAIDSMBDEV2=
MODEL_ID=DA3
MODEL_LAYOUT=SSGSTD
MODEL_CLASS="EX760"
MODEL_FLEXL="EX760L EX760M EX760H"
MODEL_GCACHESIZE=5120
MODEL_TMPFSSIZE=2048
# The virtual mfg tag indicates that mfg should not use
# a sport id in mfg.
#MODEL_BOB_MFG=true
MODEL_FTS=true
MODEL_FTS_PARTITION=9
MODEL_FTS_MEDIA="SSD"
MODEL_FTS_DISKSIZE_MB=142051
MODEL_ERASE_BLOCK_SIZE_SSD=524288 # In bytes

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

