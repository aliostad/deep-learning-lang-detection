#!/bin/bash

REPO=$1
BASE=/www/$REPO/eprints3/bin

# editorial alerts
$BASE/send_alerts $REPO daily --quiet
if [[ $(date +%u) -eq 7 ]] # sunday
then
    $BASE/send_alerts $REPO weekly --quiet
fi
if [[ $(date +%-d) -eq 1 ]] # first of month
then
    $BASE/send_alerts $REPO monthly --quiet
fi

# housekeeping
$BASE/lift_embargos $REPO --quiet
$BASE/issues_audit $REPO --quiet

# larger repositories should generate view
# pages at different times/on different days
$BASE/generate_views $REPO --quiet

# irstats2
$BASE/../archives/$REPO/bin/stats/process_stats $REPO

# "Trent" feed user data import from Reading
$BASE/../archives/$REPO/bin/update_users.pl $REPO

# user / system time
times
