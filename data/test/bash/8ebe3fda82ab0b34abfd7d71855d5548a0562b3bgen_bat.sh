#!/bin/bash



PROCESS_ONE=$( grep "present rate" /proc/acpi/battery/BAT1/state | awk -F: '{ print $2 }' | sed 's/ //g;s/mA//g' )
PROCESS_TWO=$( grep "remaining capacity" /proc/acpi/battery/BAT1/state | awk -F: '{ print $2 }' | sed 's/ //g;s/mAh//g' )
PROCESS_TRE=$( grep "present voltage" /proc/acpi/battery/BAT1/state | awk -F: '{ print $2 }' | sed 's/ //g;s/mV/ mV/g' )
PROCESS_FOR=$( grep "design capacity:" /proc/acpi/battery/BAT1/info | awk -F: '{ print $2 }' | sed 's/ //g;s/mAh//g' )
PROCESS_FIV=$( grep "last full capacity" /proc/acpi/battery/BAT1/info | awk -F: '{ print $2 }' | sed 's/ //g;s/mAh//g' )
PROCESS_PRODUKT=$( echo "scale=8; $PROCESS_TWO / $PROCESS_ONE" | bc )
PROCESS_HOUR="$( echo $PROCESS_PRODUKT | awk -F. '{ print $1 }' )h"
PROCESS_MINUTE="$( echo "0.$(echo $PROCESS_PRODUKT | awk -F. '{ print $2}') * 60" | bc | awk -F. '{ print $1 }' )min"
PROCESS_HEALTY="$( echo "scale=2; $PROCESS_FIV / $PROCESS_FOR * 100" | bc )%"

echo   "::===================::"
printf "|| Rate   : %4s mA  ||\n" "$PROCESS_ONE"
printf "|| Status : %4s mAh ||\n" "$PROCESS_TWO"
printf "|| Remain : %2s %5s ||\n" "$PROCESS_HOUR" "$PROCESS_MINUTE"
printf "|| Volt   : %8s ||\n" "$PROCESS_TRE"
printf "|| Healty : %6s   ||\n" "$PROCESS_HEALTY"
echo   "::===================::"
