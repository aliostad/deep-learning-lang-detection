#!/bin/sh

#  --------------------------------------------------------
#  Trash sample directory and reload with specified dataset
#  --------------------------------------------------------

# Takes 1 parameter:
#    $1: Name of dataset. Currently 1 of 
#        owm - OpenWeatherMap
#        ais - Automated Identification System
#        gpx - Global Positioning System XML

rm -r sample
mkdir sample

case ${1} in
    owm) 
		cp -r ../cases/small/owm/xml sample
		cp -r ../cases/small/owm/json sample
		;;
    ais)
		cp -r ../cases/small/ais/xml sample
		cp -r ../cases/small/ais/json sample
		;;
    gpx)
		cp -r ../cases/small/gpx/xml sample
		cp -r ../cases/small/gpx/json sample
		;;
    *) 
		echo "Unrecognized dataset"
		;;
esac


