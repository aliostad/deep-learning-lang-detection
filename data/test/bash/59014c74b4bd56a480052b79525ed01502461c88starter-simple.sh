SC=/tmp/etc/config/autoloader-starter.wanup; LOAD=/tmp/autoloader.start.sh
mkdir -p /tmp/etc/config
cat > $SC << EOF
#!/bin/sh
_COUNT=0
while true ; do
_SIZE=0
if [ -f "$LOAD.gz" ] ; then _SIZE=\`ls -l $LOAD.gz | awk '{print \$5}'\` ; fi
while true ; do
  ping -c 3 ddwrt.googlecode.com
  if [[ \$? != 0 ]]; then sleep 180 ; else break ; fi
done
if [ \$_SIZE -lt 5 ] ; then
  if [ \$_COUNT -gt 0 ] ; then sleep 90; fi
  wget -O - http://ddwrt.googlecode.com/svn/trunk/autoloader.start.sh.gz > $LOAD.gz
  let _COUNT++
else
  gunzip -f $LOAD.gz ; cp /tmp/crontab /tmp/crontab.backup ; chmod +x $LOAD ; $LOAD 1 &
  break
fi
done
EOF
sleep 20 ; sh $SC &