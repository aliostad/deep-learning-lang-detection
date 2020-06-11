
# Get cpu count
case "$LP_OS" in
    Linux)   _lp_CPUNUM=$( nproc 2>/dev/null || grep -c '^[Pp]rocessor' /proc/cpuinfo ) ;;
    FreeBSD|Darwin|OpenBSD) _lp_CPUNUM=$( sysctl -n hw.ncpu ) ;;
    SunOS)   _lp_CPUNUM=$( kstat -m cpu_info | grep -c "module: cpu_info" ) ;;
esac


sl-onos-ret linux && {
        sl-lp-cpu-load () { 
            local load eol
            read load eol < /proc/loadavg
            echo "$load"
        }    
}

sl-onos-ret darwin && {
        sl-lp-cpu-load () { 
            local bol load eol
            # If you have problems with syntax coloring due to the following
            # line, do this: ln -s liquidprompt liquidprompt.bash
            # and edit liquidprompt.bash
            read bol load eol <<<"$( LANG=C sysctl -n vm.loadavg )"
            echo "$load"
        }    
}

