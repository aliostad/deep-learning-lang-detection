TOP=$(top -n 1)
UPTIME=$(uptime)

[ "x$(echo "$UPTIME" | grep day)" != "x" ] && LIMIT="-2" 

echo "sys_uptime $(echo "$UPTIME" | cut -d ',' -f1$LIMIT | cut -d ' ' -f4-)"
echo "global_load $(echo "$UPTIME" | cut -d ':' -f5)"
echo "user_load $(echo "$TOP" | awk 'NR == 3 { print $2 }' | cut -d '%' -f1)%"
echo "sys_load $(echo "$TOP" | awk 'NR == 3 { print $3 }' | cut -d '%' -f1)%"
echo "idle_load $(echo "$TOP" | awk 'NR == 3 { print $5 }' | cut -d '%' -f1)%"
echo "wait_load $(echo "$TOP" | awk 'NR == 3 { print $6 }' | cut -d '%' -f1)%"

