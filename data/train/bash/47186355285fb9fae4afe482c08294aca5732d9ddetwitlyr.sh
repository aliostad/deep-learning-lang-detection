#!/bin/zsh

user=$1
shift

marker=`curl "http://api.twitter.com/1/statuses/user_timeline.json?screen_name=$user&count=1" -s | sed -e 's/.*"text":"//' -e 's/".*//'`
file=`echo $marker | cut -f 1 -d " "`
hash=`echo $marker | cut -f 2 -d " "`
numurl=`echo $marker | cut -f 3 -d " "`
baseurl='http://xn--ogi.ws/'
#echo "marker: $marker"
#echo "file: $file"
#echo "hash: $hash"
#echo "numurl: $numurl"

numtweets=$(( ( $numurl + 69 ) / 70 ))
chunk=""
tfile=`mktemp`
touch $file

for (( t=1 ; t <= $numtweets ; ++t ))
do page=$(( $t + 1 ))
    tweet=`curl "http://api.twitter.com/1/statuses/user_timeline.json?screen_name=$user&count=1&page=$page" -s | sed -e 's/.*"text":"//' -e 's/".*//'`
    for (( c=1 ; c <= ${#tweet} ; c+=2 ))
    do end=$(( $c + 1 ))
	chrs=`echo -e $tweet | cut -c ${c}-${end}`
	chrs=`echo -n $chrs | od -t x2 | cut -f 2- -d " " | head -n 1 | sed -e 's/ //g'`
	urlpath=""
	for (( p=0 ; p < ${#chrs} ; p+=4 ))
	do  s=$(( $p + 3 ))
	    e=$(( $p + 4 ))
	    u=`echo $chrs | cut -c ${s}-${e}`
	    urlpath="${urlpath}%$u"
	    s=$(( $p + 1 ))
	    e=$(( $p + 2 ))
	    u=`echo $chrs | cut -c ${s}-${e}`
	    urlpath="${urlpath}%$u"
	done
	c=`curl -I "$baseurl$urlpath" -s | grep '^Location: ' | sed -e 's,.*: http://tinyarro.ws/preview.php?page=http%3A%2F%2F,,' -e 's/&count=.*//'`
	chunk="$chunk$c"
    done
    echo -n $chunk >${tfile}.chunk
    cat $file ${tfile}.chunk > ${tfile}.tmp
    mv ${tfile}.tmp $file
done
echo "Done with $file"
echo "sha1 should be $hash"
sha1sum $file
