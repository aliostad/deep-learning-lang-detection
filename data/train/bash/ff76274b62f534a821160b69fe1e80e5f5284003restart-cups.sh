restart_cups()
{
    # Historically, we used to have to do all sorts of clever stuff
    # when restarting CUPS.  In an effort to plan for future
    # hilarity, we'll keep this hook around, but only restart
    # CUPS if it's running, and don't error out if we can't.

    # Note that this will likely end badly on Trusty+, due to the
    # avahi-cups-reload Upstart job.  Test it before making changes.

    # It's not 2008 anymore, there's nothing named "cupsys"
    rcname=cups
    if /etc/init.d/$rcname status; then
        if hash invoke-rc.d; then
            invoke="invoke-rc.d $rcname"
        else
            invoke="/etc/init.d/$rcname"
        fi
	# This should not be fatal
	if ! $invoke restart; then
	    echo "NOTICE: Failed to restart CUPS.  Oh well..." >&2
	fi
    fi
}
