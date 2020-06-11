#!/bin/bash

#This file is part of lipck - the "linux install party customization kit".
#
# Copyright (C) 2014 trilader, Anwarias, Christopher Spinrath
#
# lipck is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# lipck is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with lipck.  If not, see <http://www.gnu.org/licenses/>.

function install_debs()
{
        DEB_DIR="$1"

        if [ ! -d "$DEB_DIR" ]; then
                echo "Nothing to install here!"
                return 0
        fi

        for p in "$DEB_DIR/"*
        do
		echo "installing $p..."
                dpkg -i "$p"
		echo "done."
        done
}

function divert_initctl()
{
        dpkg-divert --local --rename --add /sbin/initctl
        if ! ln -s /bin/true /sbin/initctl; then
		echo "LIPCK: Failed to divert initctl!"
		revert_initctl
		exit 1
	fi
        # Fix sysvinit legacy invoke-rc.d issue with nonexisting scripts
        dpkg-divert --local --rename --add /usr/sbin/invoke-rc.d
        if ! ln -s /bin/true /usr/sbin/invoke-rc.d; then
		echo "LIPCK: Failed to divert invoke-rc.d!"
		revert_initctl
		exit 1
	fi
}

function revert_initctl()
{
        rm /sbin/initctl
        dpkg-divert --local --rename --remove /sbin/initctl
        # Fix sysvinit legacy invoke-rc.d issue with nonexisting scripts
        rm /usr/sbin/invoke-rc.d
        dpkg-divert --local --rename --remove /usr/sbin/invoke-rc.d
}

function get_packages_from_file()
{
        FILENAME="$1"

        if [ ! -e "$FILENAME" ]; then
                echo "Error: package file $FILENAME does not exist!"
                exit 3
        fi

        echo "$(grep -v "^#" "$FILENAME" | tr '\n' ' ')"
}
