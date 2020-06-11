emmc_size=`cat /sys/block/mmcblk0/size`

TARGET_4GB_MODEL=8388608    # (4*1024*1024*1024)/512
TARGET_8GB_MODEL=16777216   # (8*1024*1024*1024)/512
TARGET_16GB_MODEL=33554432  # (16*1024*1024*1024)/512

if [ $emmc_size -lt $TARGET_4GB_MODEL ]; then
    setprop persist.sys.emmc_size 4G
    echo 4G model
elif [ $emmc_size -lt $TARGET_8GB_MODEL ]; then
    setprop persist.sys.emmc_size 8G
    echo 8G model
elif [ $emmc_size -lt $TARGET_16GB_MODEL ]; then
    setprop persist.sys.emmc_size 16G
    echo 16G model
else
    setprop persist.sys.emmc_size 32G
    echo 32G model
fi
