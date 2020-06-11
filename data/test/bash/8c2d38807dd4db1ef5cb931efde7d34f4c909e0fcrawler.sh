#!/bin/sh
#
#    takes 3 arguments:
# $1 is remote members directory url
#   usually http://yourdomain.com/mailman/admin/mailinglist_name/members
# $2 is admin password
# $3 is local output file
#


# crawl every letter of the alphabet
for i in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z
do
	# get the first page
	wget -O - --post-data "adminpw=$2"  "$1?letter=$i" > tmp
	
	# process it once to get all addresses
	egrep tmp | egrep "_realname" | sed 's/^.*value="\([^"]*\)".*value="\([^"]*\)".*$/\1,\2/' | sed 's/%40/@/' >> $3

	# check if there is any mention of multiple pages
	egrep chunk tmp | sed 's/^.*chunk=\([^"]*\)".*$/\1/' > tmp2
	
	# process any extra pages
	while read line
	do 
	if [ $line = "0" ]; then
	   echo 'ignore chunk=0, we already have it in the first page'
	else
		wget -O - --post-data "adminpw=$2"  "$1?letter=$i&chunk=$line" | egrep "_realname" | sed 's/^.*value="\([^"]*\)".*value="\([^"]*\)".*$/\1,\2/' | sed 's/%40/@/' >> $3
	fi
	done < tmp2	

done

# clean tmp files
rm tmp
rm tmp2