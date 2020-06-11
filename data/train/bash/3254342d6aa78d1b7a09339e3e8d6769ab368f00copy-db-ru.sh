#!/bin/bash

#RU
start=4703000
end=13000000

#EU
#start=500000000
#end=504000000

#US
#start=1000000000
#end=1001000000

#SEA
#start=2000000000
#end=2001000000

#VTC
#start=2500000000
#end=2501000000

chunk=1000

pos=$start
while [ $pos -lt $end ];do
    pos2=$(($pos + $chunk))
    echo "$pos .. $pos2"
    echo "var db2 = connect('localhost:27017/xvm'); db2.players.find({_id:{\$gte:$pos, \$lt:$pos2}}).forEach(function(p) {db.players.insert(p);})" \
	| mongo --port 27020 --quiet xvm | grep -v "bye"
    pos=$pos2
done
