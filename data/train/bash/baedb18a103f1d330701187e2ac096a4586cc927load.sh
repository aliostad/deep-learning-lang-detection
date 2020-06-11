#!/bin/bash

# HOST=127.0.0.1:8080
HOST=craigcookdotcom.herokuapp.com

# ContentType - File - Bag
function load_bag() {	
	curl -X PUT -H "Content-Type: $1" --data-binary {} http://$HOST/bags/$3
}

# ContentType - File - Recipe
function load_recipe() {
	curl -X PUT -H "Content-Type: $1" --data-binary {} http://$HOST/recipes/$3
}

function load_bags() {
	load_bag application/json bags/tweets.json tweets
	load_bag application/json bags/blogs.json blogs
	load_bag application/json bags/github.json github
}

load_bags
load_recipe application/json recipes/feed.json feed
