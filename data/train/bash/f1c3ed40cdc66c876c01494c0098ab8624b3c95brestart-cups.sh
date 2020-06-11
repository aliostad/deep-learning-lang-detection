restart_cups()
{
	# Handle Debian package name change from cupsys to cups.
	[ -e /etc/init.d/cups ] && rcname=cups || rcname=cupsys
	# Restart cupsd if it is running
	if /etc/init.d/$rcname status; then
	    if hash invoke-rc.d; then
		invoke="invoke-rc.d $rcname"
	    else
		invoke="/etc/init.d/$rcname"
	    fi
	    # Flush remote.cache to deal with things like changing the
	    # server we BrowsePoll against. But don't do so if
	    # policy-rc.d is going to prevent us from restarting cupsd
	    # (for instance, if reactivate is installed and running;
	    # in that case, the next logout will flush remote.cache and restart
	    # cupsd anyway).
	    if $invoke stop; then
		rm -f /var/cache/cups/remote.cache
		if type restart_cups_extra >/dev/null 2>&1; then
		    restart_cups_extra 0
		fi
		$invoke start
	    else
		ret="$?"
		if type restart_cups_extra >/dev/null 2>&1; then
		    restart_cups_extra "$ret"
		fi
	    fi

	    # Wait up to two minutes to pick up all the BrowsePoll server's queues.
	    browse_host="$(sed -ne '/^BrowsePoll/ { s/^BrowsePoll //p; q }' /etc/cups/cupsd.conf)"
	    if [ -n "$browse_host" ]; then
		browse_host="$(sed -ne '/^BrowsePoll/ { s/^BrowsePoll //p; q }' /usr/share/debathena-cupsys-config/cupsd-site.conf)"
	    fi
	    if [ -n "$browse_host" ]; then
		echo "Retrieving printer list, please wait..." >&2
		echo "(This may take up to 30 seconds)" >&2
		queue_count=$(lpstat -h "$browse_host" -a | awk '{print $1}' | sort -u | wc -l)

		if echo "$browse_host" | grep -q ':'; then
		    browse_port="${browse_host##*:}"
		    browse_host="${browse_host%:*}"
		else
		    browse_port=631
		fi

		# Execute the cups-polld in a subshell so that we can
		# set an EXIT trap
		(trap "start-stop-daemon --stop --oknodo --pidfile /var/run/debathena-cupsys-config-polld.pid" EXIT

		    start-stop-daemon --start \
			--chuid lp \
			--pidfile /var/run/debathena-cupsys-config-polld.pid \
			--background \
			--make-pidfile \
			--startas /usr/lib/cups/daemon/cups-polld -- \
			"$browse_host" "$browse_port" 1 631

		    timeout=0
		    while [ $(lpstat -a | wc -l) -lt $queue_count ] && [ $timeout -le 30 ]; do
			sleep 1
			timeout=$((timeout+1))
		    done)
	    fi
	else
	    if type restart_cups_extra >/dev/null 2>&1; then
		restart_cups_extra -1
	    fi
	fi
}
