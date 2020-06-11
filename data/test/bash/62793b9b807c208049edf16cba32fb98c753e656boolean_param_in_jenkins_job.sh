#!/bin/bash -eu

# When you add a boolean parameter to a Jenkins job, the two values the
# param will contain are the strings "true" or "false".
#
# So when using a boolean param value configured with these settings:
#
#   Name: SAVE_VIDEO_ON_SUCCESS
#   Default value: [ ]
#
# In a bash script build step, you can use the parameter as follows:

SAVE_VIDEO_ON_SUCCESS=true # What Jenkins does when the checkbox is enabled

echo "SAVE_VIDEO_ON_SUCCESS is '$SAVE_VIDEO_ON_SUCCESS'"
if [ "$SAVE_VIDEO_ON_SUCCESS" == "true" ] ; then
    echo "The checkbox was enabled."
else
    echo "The checkbox was disabled."
fi

SAVE_VIDEO_ON_SUCCESS=false # What Jenkins does when the checkbox is disabled

echo "SAVE_VIDEO_ON_SUCCESS is '$SAVE_VIDEO_ON_SUCCESS'"
if [ "$SAVE_VIDEO_ON_SUCCESS" == "false" ] ; then
    echo "The checkbox was disabled."
else
    echo "The checkbox was enabled."
fi
