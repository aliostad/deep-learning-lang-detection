#!/bin/sh
# File:		restart.sh
# Changes:
#	20010219 Ola Lundqvist <opal@debian.org>
#	20010430 Ola Lundqvist <opal@debian.org>
#		Removed bash specific issues.
#	20011022 Luca De Vitis <luca@debian.org>
#		Introduced the error variable.
#	20020116 Ola Lundqvist <opal@debian.org>
#		Documented the error variable.
#       20020126 Ola Lundqvist <opal@debian.org>
#		Better error handing for this one.
#	20020317 Ola Lundqvist <opal@debian.org>
#		Applied simple patch from
#		"Luca - De Whiskey's - De Vitis" <luca@debian.org>
#       20061118 Ola Lundqvist <opal@debian.org>
#               Applied patch from Frederic Schutz <schutz@mathgen.ch>
#               to make sure that restart failure do not break postinst.
#       20080611 Ola Lundqvist <opal@debian.org>
#               Now uses invoke-rc.d instead if available.
# Needs:	$servers - the servers to check for.
#		$restart - where it searches for if it exists.
# Description:	Restarts a server if it is found in the restart variable.
# Sets:		$status = {error, nothing, restart}
#	 	$restarted = the ones that are restarted in order.
#		$error = error message (if $status = error)
# Note:		$restart can be somthing like this: "apache exim"

status="nothing"
error=""
if [ -z "$servers" ] ; then
    status="error"
    error="No servers specified in restart.sh."
else
    restart=" $restart "
    for A in $servers ; do
	verify=$(echo "$restart" | sed -e "s| $A ||g;")
	if [ "$verify" != "$restart" ] ; then
	    log="${log}$A needs to be restarted."
	    if [ -x /usr/sbin/invoke-rc.d ] && [ -x /etc/init.d/$A ] ; then
		if ! /usr/sbin/invoke-rc.d $A restart >/dev/null 2>&1 3>&1 4>&1 5>&1; then
		    status="error"
		    error="ERROR! /usr/sbin/invoke-rc.d $A restart, returned an error. $A could not be restarted."
		fi
	    elif [ -x /etc/init.d/$A ] ; then
		if ! /etc/init.d/$A restart >/dev/null 2>&1 3>&1 4>&1 5>&1; then
		    status="error"
		    error="ERROR! /etc/init.d/$A returned an error. $A could not be restarted."
		fi
	    elif [ -x /usr/sbin/invoke-rc.d ] ; then
		if ! /usr/sbin/invoke-rc.d $A restart >/dev/null 2>&1 3>&1 4>&1 5>&1; then
		    status="error"
		    error="ERROR! /usr/sbin/invoke-rc.d $A restart, returned an error. $A could not be restarted."
		fi
	    else
		status="error"
		error="ERROR! /etc/init.d/$A or /usr/sbin/invoke-rc.d is not installed (or not executable)."
	    fi
	fi
    done
fi
