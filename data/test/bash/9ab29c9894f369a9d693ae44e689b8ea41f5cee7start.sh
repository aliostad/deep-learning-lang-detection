#!/bin/sh

local REDIS_CONF="/etc/redis.conf"

set_maxmemory() {
	if [ ! -f /.redis_maxmemory_set ]; then
		local MAXMEMORY=${REDIS_MAXMEMORY:-"64MB"}

		echo "=> Set Redis maximum memory to $MAXMEMORY."
		echo "maxmemory $MAXMEMORY" >> $REDIS_CONF

		touch /.redis_maxmemory_set
	fi
}

set_persistance() {
	local PERSIST=${REDIS_PERSIST:-"yes"}

	if [ ${PERSIST} == "yes" ]; then
		if [ ! -f /.redis_save_set ]; then
			echo "=> Set Redis save intervals"
			echo "save 900 1" >> $REDIS_CONF
			echo "save 300 10" >> $REDIS_CONF
			echo "save 60 10000" >> $REDIS_CONF

			touch /.redis_save_set
		fi
	fi
}

start() {
	set_maxmemory
	set_persistance

	exec redis-server $REDIS_CONF
}

start
