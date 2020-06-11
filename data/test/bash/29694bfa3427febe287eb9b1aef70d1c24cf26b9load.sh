#!/bin/bash

HOST=127.0.0.1:8080

# ContentType - File - Bag
function load_bag() {	
	curl -X PUT -H "Content-Type: $1" --data-binary "@$2" http://$HOST/bags/$3
}

# ContentType - File - Recipe
function load_recipe() {
	curl -X PUT -H "Content-Type: $1" --data-binary "@$2" http://$HOST/recipes/$3
}

# ContentType - File - Bag - Name
function load_tiddler() {	
	curl -X PUT -H "Content-Type: $1" --data-binary "@$2" http://$HOST/bags/$3/tiddlers/$4
}

function load_dir() {	
	DIR=$1
	LEN=$2
	cd $DIR
	for FILE in *
	do
		if [ -f "$FILE" ]
		then
			NAME=${FILE:0:$LEN}
			# echo $NAME
			curl -X PUT -H 'Content-Type: application/json' -d "@$FILE" http://$HOST/bags/$DIR/tiddlers/$NAME
		fi	
	done
	cd ../
}

function load_statics() {
	load_tiddler image/jpeg static/images/craig.jpg static craig.jpg

	load_tiddler application/vnd.ms-fontobject static/css/Elusive-Icons.eot static Elusive-Icons.eot
	load_tiddler image/svg+xml static/css/Elusive-Icons.svg static Elusive-Icons.svg
	load_tiddler application/x-font-ttf static/css/Elusive-Icons.ttf static Elusive-Icons.ttf
	load_tiddler application/octet-stream static/css/Elusive-Icons.woff static Elusive-Icons.woff

	load_tiddler text/css static/css/default.css static default.css
	load_tiddler text/css static/css/layout.css static layout.css
	load_tiddler text/css static/css/elusive-webfont.css static elusive-webfont.css
	load_tiddler text/javascript static/js/default.js static default.js
}

function load_bags() {
	load_bag application/json bags/tweets.json tweets
	load_bag application/json bags/blogs.json blogs
	load_bag application/json bags/github.json github
	load_bag application/json bags/static.json static
}

# load_bags
load_recipe application/json recipes/feed.json feed
# load_recipe application/json recipes/feed_sorted.json feed_sorted
#load_statics
# load_dir tweets 23
# load_dir blogs 7
# load_dir github 8
