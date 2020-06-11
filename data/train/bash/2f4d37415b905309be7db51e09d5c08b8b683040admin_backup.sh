#!/bin/bash
ADM_CONF="/etc/vdr/plugins/admin/admin.conf"
ADM_SAVE="$ADM_CONF.save"
cp -f $ADM_CONF $ADM_SAVE
DIFF=1

for i in $(seq 1 5); do
   if [ -f $ADM_SAVE.$i ] ; then
      if [ "$(diff -uN $ADM_SAVE $ADM_SAVE.i)" = "" ] ; then
         DIFF=0
	 break
      fi
   else
      break      
   fi      	 
done
if [ "$DIFF" = "1" ] ; then
   # Wraparound
   
   while [ $i -gt 1 ] ; do
      idx=$(($i - 1))
      cp -f $ADM_SAVE.$idx $ADM_SAVE.$i
      i=$idx         
   done
   cp -f $ADM_SAVE $ADM_SAVE.1
fi
