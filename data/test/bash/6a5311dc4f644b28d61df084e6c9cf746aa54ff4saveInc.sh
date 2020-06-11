#! /bin/bash

memPos=$(cat ~/.config/memPath)

if [ -f ./SAVE/saveBase.tar.gz ]
then
	#save incrementale
	stock=$(ls -c ./SAVE/ | head -n1)
	ee="$(find ./grapheStock/ -newer ./SAVE/$stock)"
ifinal=""
cmpt=0
	for i in $ee
	do
		if [ $cmpt -eq 0 ]
		then
			cmpt=$(($cmpt + 1)) # enlever 1er element
			continue
		fi
		echo $i
ifinal="$ifinal $i"
ifinal=$(echo "$ifinal" | cut -f2 -d ' ')
	done
	echo "$ifinal ee"
	tar -cvzf "./SAVE/save$(date +%d\%m\%Y).tar.gz" $ifinal
else
	# save complete si premiere fois
	tar -cvzf ./SAVE/saveBase.tar.gz ./grapheStock/
fi

