#!/bin/bash

#######################################################################
##        NET                                                        ##
#######################################################################

rrdtool graph /root/.rrd/net.png \
  DEF:in=/root/.rrd/net.rrd:in:AVERAGE \
  DEF:out=/root/.rrd/net.rrd:out:AVERAGE \
  AREA:out#FF8080:"outgoing" \
  LINE1.0:in#FF0000:"incoming" \
  -v "Traffic per 5m" -W "Gaia" > /dev/null

rrdtool graph /root/.rrd/net_lin_3hrs.png \
--start -10800 \
  DEF:in=/root/.rrd/net.rrd:in:AVERAGE \
  DEF:out=/root/.rrd/net.rrd:out:AVERAGE \
  COMMENT:"last 3 hours" \
  AREA:out#FF8080:"outgoing" \
  LINE1.0:in#FF0000:"incoming" \
  -v load -W "Hermes"


exit

rrdtool graph /var/www/peper-home.net/htdocs/load.png \
  DEF:myspeed=/root/.rrd/load.rrd:load:AVERAGE \
  LINE1.0:myspeed#FF0000:"5min average load" --start end-172800s \
  -v "Load" -W "Hermes" > /dev/null

rrdtool graph /var/www/peper-home.net/htdocs/load_short.png \
  DEF:myspeed=/root/.rrd/load.rrd:load:AVERAGE \
  LINE1.0:myspeed#FF0000:"5min average load" --start end-7200s \
  -v "Load" -W "Hermes" > /dev/null

rrdtool graph /var/www/peper-home.net/htdocs/load_b.png \
  DEF:myspeed=/root/.rrd/load.rrd:load:AVERAGE \
  LINE1.0:myspeed#FF0000:"5min average load" --start end-172800s \
  -o --units=si \
  -v "Load (b)" -W "Hermes" > /dev/null

rrdtool graph /var/www/peper-home.net/htdocs/load2.png \
  DEF:myspeed=/root/.rrd/load2.rrd:load:LAST \
  DEF:myspeed2=/root/.rrd/load2.rrd:load:AVERAGE \
  LINE1.0:myspeed#FF0000:"5min average load" --start end-172800s \
  LINE1.0:myspeed2#0000FF:"1h average load" --start end-172800s \
  -v "Load" -W "Hermes" > /dev/null

rrdtool graph /root/.rrd/load_lin_hour.png \
--start -3600 \
DEF:load=/root/.rrd/load2.rrd:load:LAST \
DEF:load2=/root/.rrd/load2.rrd:load:AVERAGE:step=300 \
COMMENT:"last hour" \
LINE1:load#FF0000 \
LINE1:load2#0000FF \
-v load -W "Hermes"

rrdtool graph /root/.rrd/load_lin_3hrs.png \
--start -10800 \
DEF:load=/root/.rrd/load2.rrd:load:LAST \
DEF:load2=/root/.rrd/load2.rrd:load:AVERAGE:step=300 \
DEF:load3=/root/.rrd/load2.rrd:load:AVERAGE:step=900 \
COMMENT:"last 3 hours" \
LINE1:load#FF0000 \
LINE1:load2#00FF00 \
LINE1:load3#0000FF \
-v load -W "Hermes"

rrdtool graph /root/.rrd/load_lin_day.png \
--start -86400 \
DEF:load=/root/.rrd/load2.rrd:load:LAST \
DEF:load2=/root/.rrd/load2.rrd:load:AVERAGE:step=900 \
DEF:load3=/root/.rrd/load2.rrd:load:AVERAGE:step=3600 \
COMMENT:"last day" \
LINE1:load#00FF00:"1 min value" \
LINE1:load2#FF0000:"15min avg" \
LINE1:load3#0000FF:"1h avg" \
-v load -W "Hermes"

rrdtool graph /root/.rrd/load_lin_week.png \
--start -604800 \
DEF:load=/root/.rrd/load2.rrd:load:LAST \
DEF:load3=/root/.rrd/load2.rrd:load:AVERAGE:step=3600 \
COMMENT:"last week" \
LINE1:load#FF8080 \
LINE1:load3#0000FF \
-v load -W "Hermes"

#################
## logarithmic ##
#################

rrdtool graph /root/.rrd/load_log_hour.png \
--start -3600 \
-o --units=si \
DEF:load=/root/.rrd/load2.rrd:load:LAST \
DEF:load2=/root/.rrd/load2.rrd:load:AVERAGE:step=300 \
COMMENT:"last hour" \
LINE1:load#FF0000 \
LINE1:load2#0000FF \
-v load -W "Hermes"

rrdtool graph /root/.rrd/load_log_3hrs.png \
--start -10800 \
-o --units=si \
DEF:load=/root/.rrd/load2.rrd:load:LAST \
DEF:load2=/root/.rrd/load2.rrd:load:AVERAGE:step=300 \
DEF:load3=/root/.rrd/load2.rrd:load:AVERAGE:step=900 \
COMMENT:"last 3 hours" \
LINE1:load#FF0000 \
LINE1:load2#00FF00 \
LINE1:load3#0000FF \
-v load -W "Hermes"

rrdtool graph /root/.rrd/load_log_day.png \
--start -86400 \
-o --units=si \
DEF:load=/root/.rrd/load2.rrd:load:LAST \
DEF:load2=/root/.rrd/load2.rrd:load:AVERAGE:step=900 \
DEF:load3=/root/.rrd/load2.rrd:load:AVERAGE:step=3600 \
COMMENT:"last day" \
LINE1:load#FF8080:"1min value" \
LINE1:load2#0000FF:"15min value" \
LINE1:load3#00FF00:"1h value" \
-v load -W "Hermes"

rrdtool graph /root/.rrd/load_log_week.png \
--start -604800 \
-o --units=si \
DEF:load=/root/.rrd/load2.rrd:load:LAST \
DEF:load3=/root/.rrd/load2.rrd:load:AVERAGE:step=3600 \
COMMENT:"last week" \
LINE1:load#FF8080 \
LINE1:load3#0000FF \
-v load -W "Hermes"






