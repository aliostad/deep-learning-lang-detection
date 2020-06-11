#!/bin/sh
. /usr/local/bin/motion-web-alert-plugin/write_log.sh

#Config path && Read configuration
write_log 'Load config...'
PATH_CONF='/etc/motion-web-alert-plugin'
FILE_CONF='motion-web-alert-plugin.conf'
READ_CONF=`cat $PATH_CONF/$FILE_CONF | tr "\n" '|'` 
if [ -z "$READ_CONF" ]; then write_log 'load config Failed!'; return 0 ; fi

#Return Configuration value
load_config(){
  echo "$READ_CONF" | tr '|' "\n" | grep "^$1=" | awk -F"$1=" '{print $2}'
}

ALERT_ON=`load_config 'ALERT_ON'`
INTRUDE_ON=`load_config 'INTRUDE_ON'`

POWERDOWN_ON=`load_config 'POWERDOWN_ON'`
SMS_ON=`load_config 'SMS_ON'`
TWITTER_ON=`load_config 'TWITTER_ON'`

INTRUDE_SMS_ON=`load_config 'INTRUDE_SMS_ON'`
INTRUDE_SMS_MSG=`load_config 'INTRUDE_SMS_MSG'`
INTRUDE_SMS_PHONE=`load_config 'INTRUDE_SMS_PHONE'`
INTRUDE_TWITTER_ON=`load_config 'INTRUDE_TWITTER_ON'`
INTRUDE_TWITTER_MSG=`load_config 'INTRUDE_TWITTER_MSG'`
INTRUDE_TWITTER_USER=`load_config 'INTRUDE_TWITTER_USER'`
INTRUDE_TWITTER_PASS=`load_config 'INTRUDE_TWITTER_PASS'`

POWERDOWN_SMS_ON=`load_config 'POWERDOWN_SMS_ON'`
POWERDOWN_SMS_MSG=`load_config 'POWERDOWN_SMS_MSG'`
POWERDOWN_SMS_PHONE=`load_config 'POWERDOWN_SMS_PHONE'`
POWERDOWN_TWITTER_ON=`load_config 'POWERDOWN_TWITTER_ON'`
POWERDOWN_TWITTER_MSG=`load_config 'POWERDOWN_TWITTER_MSG'`
POWERDOWN_TWITTER_USER=`load_config 'POWERDOWN_TWITTER_USER'`
POWERDOWN_TWITTER_PASS=`load_config 'POWERDOWN_TWITTER_PASS'`

WEB_USER=`load_config 'WEB_USER'`
WEB_PASSWORD=`load_config 'WEB_PASSWORD'`

ALERT_DAY=`load_config 'ALERT_DAY'`
MO_ALL_TIME=`load_config 'MO_ALL_TIME'`
TU_ALL_TIME=`load_config 'TU_ALL_TIME'`
WE_ALL_TIME=`load_config 'WE_ALL_TIME'`
TH_ALL_TIME=`load_config 'TH_ALL_TIME'`
FR_ALL_TIME=`load_config 'FR_ALL_TIME'`
SA_ALL_TIME=`load_config 'SA_ALL_TIME'`
SU_ALL_TIME=`load_config 'SU_ALL_TIME'`
MO_TIME=`load_config 'MO_TIME'`
TU_TIME=`load_config 'TU_TIME'`
WE_TIME=`load_config 'WE_TIME'`
TH_TIME=`load_config 'TH_TIME'`
FR_TIME=`load_config 'FR_TIME'`
SA_TIME=`load_config 'SA_TIME'`
SU_TIME=`load_config 'SU_TIME'`

IMGUR_KEY=`load_config 'IMGUR_KEY'`

SMS_GATEWAY_URL=`load_config 'SMS_GATEWAY_URL'`      
SMS_GATEWAY_POST=`load_config 'SMS_GATEWAY_POST'`
SMS_GATEWAY_USER=`load_config 'SMS_GATEWAY_USER'`
SMS_GATEWAY_PASSWORD=`load_config 'SMS_GATEWAY_PASSWORD'`

TYPE_ALERT=`load_config 'TYPE_ALERT'`
TYPE_POWER=`load_config 'TYPE_POWER'`

SHORT_URL_USER=`load_config 'SHORT_URL_USER'`
SHORT_URL_KEY=`load_config 'SHORT_URL_KEY'`

WAIT=`load_config 'WAIT'`
REMOVE_DAY=`load_config 'REMOVE_DAY'`
REMOVE_SIZE=`load_config 'REMOVE_SIZE'`
write_log 'Load config Ok'
