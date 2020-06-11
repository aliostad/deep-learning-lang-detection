#!/bin/bash
# -*- coding: utf-8 -*-

# sets the execution break on error so that if any
# of the commands fails the execution is broken
set -e +h

source /config

source /tools/repo/scripts/build/base/config.sh
source /tools/repo/scripts/build/base/config.system.sh

unset VERSION

# prints some information about the current configuration
# that is going to be used in the system building operation
# and then sleeps for some time to display this information
print_scudum
sleep $BUILD_TIMEOUT

/tools/repo/scripts/build/system/tree.sh

rm -rf sources && mkdir sources
cd sources

/tools/repo/scripts/build/system/linux-headers.sh
/tools/repo/scripts/build/system/man-pages.sh
/tools/repo/scripts/build/system/glibc.sh
/tools/repo/scripts/build/system/adjusting.sh
/tools/repo/scripts/build/system/zlib.sh
/tools/repo/scripts/build/system/file.sh
/tools/repo/scripts/build/system/binutils.sh
/tools/repo/scripts/build/system/gmp.sh
/tools/repo/scripts/build/system/mpfr.sh
/tools/repo/scripts/build/system/mpc.sh
/tools/repo/scripts/build/system/$GCC_BUILD_BINARY.sh
/tools/repo/scripts/build/system/sed.sh
/tools/repo/scripts/build/system/bzip2.sh
/tools/repo/scripts/build/system/pkg-config.sh
/tools/repo/scripts/build/system/ncurses.sh
/tools/repo/scripts/build/system/util-linux.sh
/tools/repo/scripts/build/system/psmisc.sh
/tools/repo/scripts/build/system/procps-ng.sh
/tools/repo/scripts/build/system/e2fsprogs.sh
/tools/repo/scripts/build/system/shadow.sh
/tools/repo/scripts/build/system/coreutils.sh
/tools/repo/scripts/build/system/iana-etc.sh
/tools/repo/scripts/build/system/m4.sh
/tools/repo/scripts/build/system/bison.sh
/tools/repo/scripts/build/system/grep.sh
/tools/repo/scripts/build/system/readline.sh
/tools/repo/scripts/build/system/bash.sh
/tools/repo/scripts/build/system/libtool.sh
/tools/repo/scripts/build/system/gdbm.sh
/tools/repo/scripts/build/system/inetutils.sh
/tools/repo/scripts/build/system/perl.sh
/tools/repo/scripts/build/system/autoconf.sh
/tools/repo/scripts/build/system/automake.sh
/tools/repo/scripts/build/system/diffutils.sh
/tools/repo/scripts/build/system/gawk.sh
/tools/repo/scripts/build/system/findutils.sh
/tools/repo/scripts/build/system/flex.sh
/tools/repo/scripts/build/system/gettext.sh
/tools/repo/scripts/build/system/groff.sh
/tools/repo/scripts/build/system/xz.sh
/tools/repo/scripts/build/system/grub.sh
/tools/repo/scripts/build/system/less.sh
/tools/repo/scripts/build/system/gzip.sh
/tools/repo/scripts/build/system/iproute2.sh
/tools/repo/scripts/build/system/kbd.sh
/tools/repo/scripts/build/system/kmod.sh
/tools/repo/scripts/build/system/libpipeline.sh
/tools/repo/scripts/build/system/make.sh
/tools/repo/scripts/build/system/man-db.sh
/tools/repo/scripts/build/system/patch.sh
/tools/repo/scripts/build/system/sysklogd.sh
/tools/repo/scripts/build/system/sysvinit.sh
/tools/repo/scripts/build/system/tar.sh
/tools/repo/scripts/build/system/texinfo.sh
/tools/repo/scripts/build/system/gperf.sh
/tools/repo/scripts/build/system/eudev.sh
/tools/repo/scripts/build/system/bc.sh
/tools/repo/scripts/build/system/cpio.sh
/tools/repo/scripts/build/system/vim.sh
/tools/repo/scripts/build/system/nano.sh
/tools/repo/scripts/build/system/openssl.sh
/tools/repo/scripts/build/system/openssh.sh
/tools/repo/scripts/build/system/wget.sh
/tools/repo/scripts/build/system/curl.sh
/tools/repo/scripts/build/system/git.sh
/tools/repo/scripts/build/system/net-tools.sh
/tools/repo/scripts/build/system/dhcp.sh

cd .. && rm -rf sources
