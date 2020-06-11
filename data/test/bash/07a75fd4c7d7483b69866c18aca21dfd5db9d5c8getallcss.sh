#!/bin/bash
#
# Example: ./getallcss.sh http://www.forsakringskassan.se/ topatch.html topatch.html.patched
#

if [ -z "$3" ]
then
 echo Usage: $0 "<URL> <PATCH FILE> <PATCHED FILE>"
 exit
fi
url=$1
to_patch=$2
patched=$3


# Gather all css files we can find
mixed_html=`curl -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:33.0) Gecko/20100101 Firefox/33.0' $url -L`
link_css=`echo $mixed_html | grep -o 'rel="stylesheet" href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^rel=\"stylesheet\" href=["'"'"']//' -e 's/["'"'"']$//'`
echo "Found these linked css files:"
echo $link_css

import_css=`echo $mixed_html | grep -o 'import url(['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^import url(["'"'"']//' -e 's/["'"'"']$//'`
echo "Found these imported css files:"
echo $import_css


#Construct a HTML-chunk with included of the found css files
html_chunk=''
for css in $link_css$import_css
do
 html_chunk=$html_chunk"<link rel='stylesheet' href='$url$css'/>"
done


#Patch
echo Patching $to_patch
html_chunk=`echo $html_chunk | sed -e 's/\&/\\\\&/g'`
sed "s|THISISCSS|$html_chunk|g" $to_patch > $patched
echo Created: $patched
