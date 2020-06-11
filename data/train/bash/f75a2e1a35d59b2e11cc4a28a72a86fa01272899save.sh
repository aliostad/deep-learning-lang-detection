#!/bin/sh

dir=`dirname "$0"`
cd $dir/..

# créer save s'il n'existe pas
if ! [ -d save ]
then
	mkdir save
fi

quantity="$1"
shift

lastsave=`ls save | tail -1`

findopt=''
if ! [ -z "$lastsave" ]
then
	findopt="-cnewer save/$lastsave"
fi

echo $findopt

n=`find graphs -name '*.png' $findopt | wc -l`

if [ $n -gt 0 ]
then
	# nom archive
	archive="save/`date +%Y_%m_%d_-_%H_%M`.tar"

	# créer une archive tar vide
	tar cfT "$archive" /dev/null

	#ajouter les $quantity derniers graphes de chaque titre à l'archive
	for action in $@
	do
			tar rf "$archive" `find graphs -name "$action"'*.png' $findopt | tail -$quantity`
	done
fi
