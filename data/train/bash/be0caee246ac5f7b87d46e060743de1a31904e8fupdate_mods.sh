#!/bin/bash

load_mod() {
	wget https://github.com/$2/$4/archive/$3.zip -O $1.zip
	unzip $1.zip
	rm $1.zip
	mv $4-$3 $1
}

load_usual_mod() {
	load_mod $1 $2 master $1
}

load_hmod() {
	load_usual_mod $1 HybridDog
}

# make folder
mkdir tmp
cd tmp

# download mods
echo "loading mods…"
for i in builtin_item item_drop; do
	load_hmod $i
done
load_mod snow Splizard master minetest-mod-snow

# move mods
echo "moving mods…"
for i in $(ls); do
	trash ../mods/$i
	mv $i ../mods/$i
done

# remove folder
cd ..
rm -R tmp

echo "done!"
