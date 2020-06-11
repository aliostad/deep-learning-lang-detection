#!/bin/sh
cd ../../
process=`pwd | xargs -i basename {}`
ps auxf  | awk '{ if( FNR == 1 ) printf "%s\n", $0;}'
ps auxf  | grep "./${process}_ccd ../etc/${process}_ccd.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_ccd2 ../etc/${process}_ccd2.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_ccd3 ../etc/${process}_ccd3.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_ccd4 ../etc/${process}_ccd4.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_ccd5 ../etc/${process}_ccd5.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_ccd6 ../etc/${process}_ccd6.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_ccd11 ../etc/${process}_ccd11.conf" | grep -v grep | awk '{printf "%s\n", $0;}'

ps auxf  | grep "./${process}_mcd ../etc/${process}_mcd.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_submcd ../etc/${process}_submcd.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_submcd2 ../etc/${process}_submcd2.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_submcd3 ../etc/${process}_submcd3.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_submcd4 ../etc/${process}_submcd4.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_submcd5 ../etc/${process}_submcd5.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_submcd6 ../etc/${process}_submcd6.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_submcd7 ../etc/${process}_submcd7.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_submcd_log ../etc/${process}_submcd_log.conf" | grep -v grep | awk '{printf "%s\n", $0;}'

ps auxf  | grep "./${process}_dcc ../etc/${process}_dcc.conf" | grep -v grep | awk '{printf "%s\n", $0;}'
ps auxf  | grep "./${process}_dcc2 ../etc/${process}_dcc2.conf" | grep -v grep | awk '{printf "%s\n", $0;}'

exit 0
