
mkdir -p obj
mkdir -p out

CROSS_COMPILE=mips2_fp_le-
CC=${CROSS_COMPILE}gcc
AS=${CROSS_COMPILE}as
LD=${CROSS_COMPILE}ld
OBJCOPY=${CROSS_COMPILE}objcopy
OBJDUMP=${CROSS_COMPILE}objdump
SIZE=${CROSS_COMPILE}size


# ROM layout:
#   BOOT_BIN (boot + bootram)
#   CHUNK_HEADER
#   UNZIP_BIN
#   ZIP_BIN
#   DUMMY_BIN (if needed)
#   CHUNK 1, 2, ... 16

cd unzip
./unzip.sh
cd ..
cp unzip/out/unzip.bin out
cp ../../../../../vmlinux out
cp ../../../../../System.map out
$OBJCOPY -O binary out/vmlinux out/uranus.bin
cp out/uranus.bin ../../../../../uranus.bin

IN_LINUX_ENV=`uname`
if [ "$IN_LINUX_ENV" == "Linux" ] ; then
    ../../../../../../Tools/boot_utils/linux_lzma e out/uranus.bin out/uranus.zip -lc0 -lp2  # SUPPORT_UNZIP
else
    ../../../../../../Tools/boot_utils/lzma.exe e out/uranus.bin out/uranus.zip -lc0 -lp2  # SUPPORT_UNZIP
fi

# input
CHUNK_HEADER=out/chunk_header.bin
UNZIP_BIN=out/unzip.bin
ZIP_BIN=out/uranus.zip
PAD_BIN=pad00.bin


# CHUNKs
CHUNK[1]=chunks/vd_dsp.bin

# output
BOOT1_INC=out/boot1.inc
BOOT_BIN=out/boot.bin
ALL_BIN=out/all.bin
FLASH_BIN=out/flash.bin
DUMMY_BIN=out/dummy.bin

rm  -f $BOOT1_INC
rm  -f $BOOT_BIN
rm  -f $ALL_BIN


##### Pad & Calculate Sizes #####
#SIZE_UNZIP=`/bin/ls -l $UNZIP_BIN | /bin/awk '{ print $5 }'`
#case `expr $SIZE_UNZIP % 4` in
#    [1])
#	/bin/cat $PAD_BIN >> $UNZIP_BIN
#	/bin/cat $PAD_BIN >> $UNZIP_BIN
#	/bin/cat $PAD_BIN >> $UNZIP_BIN
#	;;
#	[2])
#	/bin/cat $PAD_BIN >> $UNZIP_BIN
#	/bin/cat $PAD_BIN >> $UNZIP_BIN
#	;;
#	[3])
#	/bin/cat $PAD_BIN >> $UNZIP_BIN
#	;;
#esac
#
#
#SIZE_ZIPBIN=`/bin/ls -l $ZIP_BIN | /bin/awk '{ print $5 }'`
#case `expr $SIZE_ZIPBIN % 4` in
#    [1])
#	/bin/cat $PAD_BIN >> $ZIP_BIN
#	/bin/cat $PAD_BIN >> $ZIP_BIN
#	/bin/cat $PAD_BIN >> $ZIP_BIN
#	;;
#	[2])
#	/bin/cat $PAD_BIN >> $ZIP_BIN
#	/bin/cat $PAD_BIN >> $ZIP_BIN
#	;;
#	[3])
#	/bin/cat $PAD_BIN >> $ZIP_BIN
#	;;
#esac

printf "#This file is auto created. Do not modify!\n" >> $BOOT1_INC

#Board selection with kernel menuconfig

test -e "../../../../../.config" && curBoardSet=`grep -i CONFIG_MSTAR_TITANIA3_BD_FPGA=y ../../../../../.config`
if [ "$curBoardSet" != '' ] ; then
	echo $curBoardSet
    printf "BD_FPGA = 1\n" >> $BOOT1_INC
    printf "BD_MST087B_D01A = 0\n" >> $BOOT1_INC
    printf "BD_MST087C_D02A = 0\n" >> $BOOT1_INC
    printf '\n' >> $BOOT1_INC
fi

test -e "../../../../../.config" && curBoardSet=`grep -i CONFIG_MSTAR_TITANIA3_BD_MST087B_D01A=y ../../../../../.config`
if [ "$curBoardSet" != '' ] ; then
	echo $curBoardSet
    printf "BD_FPGA = 0\n" >> $BOOT1_INC
    printf "BD_MST087B_D01A = 1\n" >> $BOOT1_INC
    printf "BD_MST087C_D02A = 0\n" >> $BOOT1_INC
    printf '\n' >> $BOOT1_INC
fi

test -e "../../../../../.config" && curBoardSet=`grep -i CONFIG_MSTAR_TITANIA3_BD_MST087C_D02A=y ../../../../../.config`
if [ "$curBoardSet" != '' ] ; then
	echo $curBoardSet
    printf "BD_FPGA = 0\n" >> $BOOT1_INC
    printf "BD_MST087B_D01A = 0\n" >> $BOOT1_INC
    printf "BD_MST087C_D02A = 1\n" >> $BOOT1_INC
    printf '\n' >> $BOOT1_INC
fi

SIZE_UNZIP=`/bin/ls -l $UNZIP_BIN | /bin/awk '{ print $5 }'`
gawk '$3 == "kernel_entry" { print "KERNEL_ENTRY_ADDR = 0x"$1 }' out/System.map >> $BOOT1_INC
printf "SIZE_UNZIP = 0X" >> $BOOT1_INC
printf %08X $SIZE_UNZIP  >> $BOOT1_INC
printf '\n' >> $BOOT1_INC

SIZE_ZIPBIN=`/bin/ls -l $ZIP_BIN | /bin/awk '{ print $5 }'`
printf "SIZE_ZIPBIN = 0X" >> $BOOT1_INC
printf %08X $SIZE_ZIPBIN  >> $BOOT1_INC
printf '\n' >> $BOOT1_INC

# # Reserve Bytes for boot code (to avoid recursive defines SIZE_BOOT in boot1.inc)
#SIZE_BOOT_RESERVED          = 3072
#SIZE_BOOTROM_RESERVED       = 2048
#SIZE_BOOTRAM_RESERVED       = 2048 #1024
SIZE_BOOT_BIN=7168 # 1C00

##### Compile/Link #####
# compile boot code
$AS -EL -mips32 -gdwarf2 -O2 -G0 -Isrc -Iout -o obj/boot.o src/boot.s
$AS -EL -mips32 -gdwarf2 -O2 -G0 -Isrc -Iout -o obj/bootrom.o src/bootrom.s
$AS -EL -mips32 -gdwarf2 -O2 -G0 -Isrc -Iout -o obj/bootram.o src/bootram.s

$LD  -EL -o out/boot.elf -Map out/boot.map -T link.ld
$OBJCOPY -O binary -I elf32-little out/boot.elf out/boot.bin
$OBJDUMP -S out/boot.elf > out/boot.dis
$SIZE out/boot.elf > out/boot.siz

##### Concatenate all binaries #####
#/bin/cat $BOOT_BIN > $ALL_BIN
#/bin/cat $CHUNK_HEADER > $ALL_BIN
#/bin/cat $UNZIP_BIN >> $ALL_BIN
#/bin/cat $ZIP_BIN >> $ALL_BIN


SIZE_CHUNK_HEADER=128
FLASH_CHUNK_BASE_ADDRESS=0

FLASH_CHUNK_ORIG_BASE_ADDRESS=$((FLASH_CHUNK_BASE_ADDRESS+SIZE_BOOT_BIN+SIZE_CHUNK_HEADER+SIZE_UNZIP+SIZE_ZIPBIN))
FLASH_CHUNK_BASE_ADDRESS=$((((FLASH_CHUNK_ORIG_BASE_ADDRESS>>3)+1)<<3))
CUR_CHUNK=$FLASH_CHUNK_BASE_ADDRESS
DUMMY_SIZE=$((FLASH_CHUNK_BASE_ADDRESS-FLASH_CHUNK_ORIG_BASE_ADDRESS))

# echo $CUR_CHUNK
i=1
for (( i=1; i<=16; i=i+1 ))
do
    # CHUNK display size information
    if [ "${CHUNK[$i]}" != "" ] ; then
        test -e ${CHUNK[$i]} && SIZE_CHUNK=`/bin/ls -l ${CHUNK[$i]} | /bin/awk '{ print $5 }'`
    else
        SIZE_CHUNK=0
    fi

    if [ "$SIZE_CHUNK" != "0" ] ; then
        printf "\n# ==== Chunk ${CHUNK[$i]} size ==== \n" >> $BOOT1_INC
        printf "SIZE_CHUNK$i = 0X" >> $BOOT1_INC
        printf %08X "$SIZE_CHUNK"  >> $BOOT1_INC
        printf '\n# ================================== \n' >> $BOOT1_INC
    fi

    # Append CHUNK1 and display address
    if [ "$SIZE_CHUNK" != "0" ] ; then
        printf "\n# ==== Chunk ${CHUNK[$i]} at flash address ====\n" >> $BOOT1_INC
        printf "ADDR_CHUNK$i = 0X" >> $BOOT1_INC
        printf %08X "$CUR_CHUNK"  >> $BOOT1_INC
        printf '\n# ============================================== \n' >> $BOOT1_INC
        BYTE_0=$((CUR_CHUNK&255))
        BYTE_1=$(((CUR_CHUNK>>8)&255))
        BYTE_2=$(((CUR_CHUNK>>16)&255))
        BYTE_3=$(((CUR_CHUNK>>24)&255))
        SBYTE_0=$((SIZE_CHUNK&255))
        SBYTE_1=$(((SIZE_CHUNK>>8)&255))
        SBYTE_2=$(((SIZE_CHUNK>>16)&255))
        SBYTE_3=$(((SIZE_CHUNK>>24)&255))
        CUR_CHUNK=$((CUR_CHUNK+SIZE_CHUNK))
    else
        BYTE_0=$((0))
        BYTE_1=$((0))
        BYTE_2=$((0))
        BYTE_3=$((0))
        SBYTE_0=$((0))
        SBYTE_1=$((0))
        SBYTE_2=$((0))
        SBYTE_3=$((0))
    fi

    if [ $((i==1)) == 1 ] ; then
        /bin/awk 'BEGIN{printf("%c%c%c%c",'"$BYTE_0"', '"$BYTE_1"', '"$BYTE_2"', '"$BYTE_3"')}' > $CHUNK_HEADER
        /bin/awk 'BEGIN{printf("%c%c%c%c",'"$SBYTE_0"', '"$SBYTE_1"', '"$SBYTE_2"', '"$SBYTE_3"')}' >> $CHUNK_HEADER
    else
        /bin/awk 'BEGIN{printf("%c%c%c%c",'"$BYTE_0"', '"$BYTE_1"', '"$BYTE_2"', '"$BYTE_3"')}' >> $CHUNK_HEADER
        /bin/awk 'BEGIN{printf("%c%c%c%c",'"$SBYTE_0"', '"$SBYTE_1"', '"$SBYTE_2"', '"$SBYTE_3"')}' >> $CHUNK_HEADER
    fi
done

/bin/cat $BOOT_BIN > $ALL_BIN
/bin/cat $CHUNK_HEADER >> $ALL_BIN
/bin/cat $UNZIP_BIN >> $ALL_BIN
/bin/cat $ZIP_BIN >> $ALL_BIN


if [ $DUMMY_SIZE != 0 ] ; then
    i=1
    DUMMY_BYTE=255
    printf %c "$DUMMY_BYTE" > $DUMMY_BIN
    for (( i=1; i<$DUMMY_SIZE; i=i+1 ))
    do
        printf %c "$DUMMY_BYTE" >> $DUMMY_BIN
    done
    /bin/cat $DUMMY_BIN >> $ALL_BIN
fi


i=1
for (( i=1; i<=16; i=i+1 ))
do
    # echo "\n Appending... ${CHUNK[$i]}"
    if [ "${CHUNK[$i]}" != "" ] ; then
        test -e ${CHUNK[$i]} && SIZE_CHUNK=`/bin/ls -l ${CHUNK[$i]} | /bin/awk '{ print $5 }'`
    else
        SIZE_CHUNK=0
    fi

    if [ "$SIZE_CHUNK" != "0" ] ; then
        echo "Appending $i chunk : ${CHUNK[$i]} , size : $SIZE_CHUNK"
        /bin/cat ${CHUNK[$i]} >> $ALL_BIN
    fi
done

##### Swap if necessary #####
# Swapping is no more needed in Titania chip
#perl byteswap.pl $ALL_BIN $FLASH_BIN
cp $ALL_BIN ../../../../../flash.bin
