#!/bin/sh
#Savescum - Because I'm too much of a failure to not die a lot.

savescum() {

case $1 in
crawl)
	case $2 in
	save)
		cp /usr/share/stone-soup/saves/$3-1000.tar.gz ~/.crawlsaves
		;;
	load)
		cp ~/.crawlsaves/$3-1000.tar.gz /usr/share/stone-soup/saves
		;;
	*)
		echo "Invalid option. either save or load."
		;;
	esac;
	;;
adom)
	case $2 in
	save)
		cp ~/.adom.data/savedg/$3.svg ~/.adomsaves
		;;
	load)
		cp ~/.adomsaves/$3.svg ~/.adom.data/savedg
		;;
	*)
		echo "Invalid option. either save or load."
		;;
	esac;
	;;
*)
	echo "Spelled it wrong, shithead."
	;;
esac;

}

savescum $1 $2 $3
