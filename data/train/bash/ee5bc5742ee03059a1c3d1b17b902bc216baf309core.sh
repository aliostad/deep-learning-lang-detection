#!/bin/bash

# Core
#------
# Loads all tasks and imports bashtask lib.
# (This is the one you run)

# Load ArchNow Specific helpers #
source ./helpers.sh

# Options #
BASE_URL=http://raw.githubusercontent.com/OscarOrSomething/ArchNow/master

# Load BashTask Lib #
source ./lib.sh

# _load declarations #
_load "tasks/preChroot/network";
_load "tasks/preChroot/filesystem";
_load "tasks/preChroot/mirrors";
_load "tasks/preChroot/pacstrap";
_load "tasks/preChroot/genfstab";

_load "tasks/chroot";

_load "tasks/chroot/locale";
_load "tasks/chroot/time";
_load "tasks/chroot/hostname";
_load "tasks/chroot/multilib";
_load "tasks/chroot/archlinuxfr";
_load "tasks/chroot/user";
_load "tasks/chroot/grub";
_load "tasks/chroot/rootPasswdExpire";
_load "tasks/chroot/exit";


# Go! #
_go;
