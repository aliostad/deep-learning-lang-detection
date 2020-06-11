# Print the average load.

run_segment() {
	loads=`uptime | cut -d "," -f 3- | cut -d ":" -f2 | sed -e "s/^[ \t]*//"`
    load_a=`echo $loads | sed -e "s/^ *\([^, ]\+\), \+\([^, ]\+\), \+\([^ ]\+\).*$/\1/g"`
    load_b=`echo $loads | sed -e "s/^ *\([^, ]\+\), \+\([^, ]\+\), \+\([^ ]\+\).*$/\2/g"`
    load_c=`echo $loads | sed -e "s/^ *\([^, ]\+\), \+\([^, ]\+\), \+\([^ ]\+\).*$/\3/g"`
    if [ -n "$load_a" ]; then
        printf "L:%.1f,%.1f,%.1f" "$load_a" "$load_b" "$load_c"
    else
        echo $loads
    fi
	exit 0
}
