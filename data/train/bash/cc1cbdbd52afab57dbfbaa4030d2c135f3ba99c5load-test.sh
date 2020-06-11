#!/bin/bash

# --------------------------
# Simple Load Test Utility
# --------------------------
# Written by James Berger
# Last updated: August 13th 2013


# Description:
# ------------
# This grabs the five minute load average via the uptime command.
# It compares it to the max_load variable and if the current load
# average is higher than the max_load variable, it alerts and 
# sends you an email.


# Setting our variables
#----------------------
# (note that the max load variable is set to a very low value by
#  default, 0.001. This is for testing purposes so you can verify
#  if the script works or not. If you're actually using it, you
#  should set it to a more reasonable value, like 1 or 0.75)
max_load=0.001
email_destination=generic-email-address@somewhere.com

# We call uptime, and then we use cut with space delimiters to grab
# the five minute load average, then we use translate (tr) to strip
# out any spaces and commas so we have a nice float value instead
# of a string.
current_load=$(uptime | cut -d' ' -f 15 | tr -d "," | tr -d " ")


# Comparing the current load to the max load
#--------------------------------------------
# Now we'll use an if statement to see if the current load exceeds
# what was set for the max load. Bash doesn't like to evaluate 
# floating numbers, so we'll pipe it out to bc to do a simple
# 'greater than?' check. If it passes the check, we email the
# person specified in our email_destination variable and if not,
# we simply exit.
if [ $(echo "$current_load > $max_load"|bc) -eq 1 ]
then
echo -e "ALERT.\n This is a message from the Simple Load Test Utility. The current load of $current_load has exceeded the maximum defined load of $max_load on the server $(hostname).\n This alert was created on $(date) (local time on $(hostname))." | mail -s "High load alert on $(hostname)" $email_destination
else
  exit 0
fi
exit 0
