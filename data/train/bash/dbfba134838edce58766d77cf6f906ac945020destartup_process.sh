#!/bin/bash

#set -x
count=1
process_dir=`dirname $0`
process_fp="${process_dir%/*}/main_process.py"
process_lp="${process_dir%/*}/logs/worker_process.log"

if [ "`ps axu | grep "${process_fp}" | grep -v 'grep' | awk '{print $2}'`" ]; then
echo "Process Started PID:" `ps axu | grep "${process_fp}" | grep -v 'grep' | awk '{print $2}'`
else
rm -rf ${process_lp}
for((i=1;i<=$count;i++)); do
nohup python -u ${process_fp} ${i} > ${process_lp} 2>&1 &
done;
echo "Process Started PID:" `ps axu | grep "${process_fp}" | grep -v 'grep' | awk '{print $2}'`
fi
