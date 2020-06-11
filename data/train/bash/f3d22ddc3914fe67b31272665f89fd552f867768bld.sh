#!/bin/bash


# Inherited Variables:
#
# TTYLINUX_XTOOL_DIR = ${XBT_DIR}/${TTYLINUX_XBT}


# *****************************************************************************
# Constants
# *****************************************************************************

X_LOAD="x-load-omap3-mainline"


# *****************************************************************************
# Check Command Line Arguments
# *****************************************************************************

if [[ $# -eq 0 ]]; then
	echo "$(basename $0) called with no arguments; one argument is needed."
	exit 1
fi
[[ "$1" != "no" ]] || exit 0
xloadTarget=$1
echo ""
echo "=> Making x-load (${xloadTarget})"


# *****************************************************************************
# Remove any left-over previous build things.  Then untar x-load source package.
# *****************************************************************************

echo "Removing any left-over build products and untarring ${X_LOAD} ..."
rm -rf x-load.bin.ift
rm -rf ${X_LOAD}
tar -xf ${X_LOAD}.tar.bz2


# *****************************************************************************
# Build x-load
# *****************************************************************************

cd ${X_LOAD}

oldPath=${PATH}
export PATH="${TTYLINUX_XTOOL_DIR}/host/usr/bin:${PATH}"

# Make the "x-load.bin" file.
#
_logFile="${xloadTarget}.MAKELOG"
rm -f ../${_logFile}
echo "" >../${_logFile}
# make CROSS_COMPILE="${XBUILDTOOL}-" distclean
make CROSS_COMPILE="${TTYLINUX_XBT}-" ${xloadTarget} >>../${_logFile} 2>&1
make CROSS_COMPILE="${TTYLINUX_XBT}-"                >>../${_logFile} 2>&1
unset _logFile

export PATH=${oldPath}

# Make the signing program.
#
echo "Making the signature program, signGP."
gcc -o signGP ../signGP.c

# Use the signGP tool to sign the x-loader image, making "x-load.bin.ift".
#
echo "Signing \"x-load.bin\", making \"x-load.bin.ift\"."
./signGP x-load.bin

# Move x-load.bin.ift to the parent directory.
#
mv x-load.bin.ift ..

cd ..

ls --color -lh x-load.bin.ift


# *****************************************************************************
# Cleanup
# *****************************************************************************

rm -rf "${X_LOAD}"

unset CROSS_COMPILE
unset X_LOAD
unset oldPath
unset xloadTarget


# *****************************************************************************
# Exit OK
# *****************************************************************************

exit 0
