#!/bin/bash
echo "**************************************************************************"
echo " Kill all ae_qc* process                                                  "
echo "**************************************************************************"
process=$( ps -eaf  | grep ae_qc | awk '{print $2}' )
 echo "process = "$process
echo "killing  $process"
kill $process
sleep 10s
echo "Retry with kill -9 $process to be sure there will no be a problem..."
kill -9 $( ps -eaf  | grep ae_qc  | awk '{print $2}' )
echo '*********************************************************************'
echo "END $0... "
echo '*********************************************************************'

