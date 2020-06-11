#!/bin/bash
function pzChunkAddFresh(){

    if [ "$#" -eq '1' ] ; then 

        path1="$pzFreshPath"/"$1"
        shift
    else
        path1="$pzFreshPath"/servertest 
    fi

    path2="$pzMpPath"
    files=$(diff "$path1" "$path2"/servertest | grep "Only in $path1" | cut -d' ' -f4 |  tr "\n" " " )
    [ -z "$files" ] && return 

    cd "$path1"
    cp -v  $files $path2
}

function pzChunkList(){

    if [ "$#" -eq '1' ] ; then 

        dir='servertest'
        file="$1"

    elif [ "$#" -eq '2' ] ; then 

        dir="$1"  
        file="$2"  
    else
        dir='servertest'
        file='chunkList.txt'
    fi

    while read line ; do
    
        pzChunkReplace -d "$dir" $line

    done < "$pzFreshPath"/"$file"
}
function pzChunkReplace(){

    if [ "$1" == '-d' ] ; then 

        shift
        path1="$pzFreshPath"/"$1"
        shift
    else
        path1="$pzFreshPath"/servertest 
    fi

    path2="$pzMpPath"
    x="$1"
    y="$2"
    rad=0
    [ ! -z "$3" ] && rad="$3"

    x1=$(( x - rad ))
    y1=$(( y - rad ))

    x2=$(( x + rad ))
    y2=$(( y + rad ))

    echo "$x1 $y1 $x2 $y2"
    files=$( find $path1 -type f | awk -F'[_.]' "{ if ( \$2 >= $x1 && \$2 <= $x2 ) print }" | awk -F'[_.]' "{ if ( \$3 >= $y1 && \$3 <= $y2 ) print }" | tr "\n" " " )  

    [ -z "$files" ] && return 
    cp -vf $files "$path2"
}
