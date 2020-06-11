#!/bin/bash
###############################################################################
#
#                           Kernel Build Script 
#
###############################################################################

if [ -n ${CMD_V_KERNEL_BUILD} ]
then
export OEM_PRODUCT_MANUFACTURER=PANTECH
export SYS_MODEL_NAME=EF34K
export MODEL_NAME=MODEL_EF34K
export SYS_MODEL_BOARD_VER=WS20
export SKY_MODEL_SW_VER_PREFIX=S0000000
fi

export TARGET_BUILD_SKY_MODEL_ID=MODEL_"$SYS_MODEL_NAME"
export TARGET_BUILD_SKY_FIRMWARE_VER=$SKY_MODEL_SW_VER_PREFIX
export SKY_INCLUDE=./include/CUST_SKY.h

export SKY_ANDROID_FLAGS


SKY_ANDROID_FLAGS+="-DMODEL_SKY -DMODEL_ID=$TARGET_BUILD_SKY_MODEL_ID -include $SKY_INCLUDE -DBOARD_VER=$SYS_MODEL_BOARD_VER -DSKY_MODEL_NAME=\\\"$SYS_MODEL_NAME\\\" -DFIRM_VER=\\\"$TARGET_BUILD_SKY_FIRMWARE_VER\\\" -DSYS_MODEL_NAME=\\\"$SYS_MODEL_NAME\\\""

echo "$SKY_ANDROID_FLAGS"

#export ARCH=arm
#export CROSS_COMPILE=../prebuilt/linux-x86/toolchain/arm-eabi-4.4.0/bin/arm-eabi-

make msm8660-perf-EF34K_defconfig
make -j4


