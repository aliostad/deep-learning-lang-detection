#!/bin/sh

dir=$(dirname "$0")
cd "$dir"

if [ ! -e ZooKeeper-O ]; then
	action=$(alert "Can't find ZooKeeper-O. Build it first." "Ok")
	exit
fi

mkdir "../Sample Applications"

rm "../Sample Applications/EmacsOpener"
rm "../Sample Applications/GhostOpener"
rm "../Sample Applications/ListFolder"
rm "../Sample Applications/MountThis"
rm "../Sample Applications/PicoOpener"
rm "../Sample Applications/PrefAppStripper"
rm "../Sample Applications/SmpegOpener-S"

cp ZooKeeper-O "../Sample Applications/EmacsOpener"
cp ZooKeeper-O "../Sample Applications/GhostOpener"
cp ZooKeeper-O "../Sample Applications/ListFolder"
cp ZooKeeper-O "../Sample Applications/MountThis"
cp ZooKeeper-O "../Sample Applications/PicoOpener"
cp ZooKeeper-O "../Sample Applications/PrefAppStripper"
cp ZooKeeper-O "../Sample Applications/SmpegOpener-S"

xres -o "../Sample Applications/EmacsOpener" "Sample App Resources/EmacsOpener.rsrc"
xres -o "../Sample Applications/GhostOpener" "Sample App Resources/GhostOpener.rsrc"
xres -o "../Sample Applications/ListFolder" "Sample App Resources/ListFolder.rsrc"
xres -o "../Sample Applications/MountThis" "Sample App Resources/MountThis.rsrc"
xres -o "../Sample Applications/PicoOpener" "Sample App Resources/PicoOpener.rsrc"
xres -o "../Sample Applications/PrefAppStripper" "Sample App Resources/PrefAppStripper.rsrc"
xres -o "../Sample Applications/SmpegOpener-S" "Sample App Resources/SmpegOpener.rsrc"

addattr -t string zook:terminal "Y" "../Sample Applications/EmacsOpener"
addattr -t string zook:keepopen "Y" "../Sample Applications/EmacsOpener"
addattr -t string zook:dir "/boot/home/" "../Sample Applications/EmacsOpener"
addattr -t string zook:command '/boot/apps/GeekGadgets/bin/emacs $zkfiles' "../Sample Applications/EmacsOpener"
addattr -t string folder:comment "Opens Text files in Emacs" "../Sample Applications/EmacsOpener"     

addattr -t string zook:terminal "Y" "../Sample Applications/GhostOpener"
addattr -t string zook:keepopen "Y" "../Sample Applications/GhostOpener"
addattr -t string zook:command 'gs $zkfiles' "../Sample Applications/GhostOpener"
addattr -t string folder:comment "Open postscripts files in Ghostscript" "../Sample Applications/GhostOpener" 

addattr -t string zook:terminal "Y" "../Sample Applications/ListFolder"
addattr -t string zook:keepopen "Y" "../Sample Applications/ListFolder"
addattr -t string zook:dir "/boot/home/Desktop" "../Sample Applications/ListFolder"
addattr -t string zook:command 'ls -aR $zkfiles > folder.txt' "../Sample Applications/ListFolder"
addattr -t string folder:comment "Writes a listing of a folder to a text file" "../Sample Applications/ListFolder"  

addattr -t string zook:terminal "Y" "../Sample Applications/MountThis"
addattr -t string zook:keepopen "Y" "../Sample Applications/MountThis"
addattr -t string zook:command 'mkdir /$(basename $zkfiles) ; mount $zkfiles' "../Sample Applications/MountThis"
addattr -t string folder:comment "Mounts filesystem images" "../Sample Applications/MountThis"  

addattr -t string zook:terminal "Y" "../Sample Applications/PicoOpener"
addattr -t string zook:keepopen "Y" "../Sample Applications/PicoOpener"
addattr -t string zook:dir "/boot/home/Desktop" "../Sample Applications/PicoOpener"
addattr -t string zook:command 'pico $zkfiles' "../Sample Applications/PicoOpener"
addattr -t string folder:comment "Opens Text files in Pico" "../Sample Applications/PicoOpener"   

addattr -t string zook:terminal "Y" "../Sample Applications/PrefAppStripper"
addattr -t string zook:keepopen "Y" "../Sample Applications/PrefAppStripper"
addattr -t string zook:dir "/boot/home/Desktop" "../Sample Applications/PrefAppStripper"
addattr -t string zook:command 'rmattr BEOS:PREF_APP $zkfiles' "../Sample Applications/PrefAppStripper"
addattr -t string folder:comment "Removes the Preferred Application attribute from files (hint: Net+ Bookmarks)" "../Sample Applications/PrefAppStripper"

addattr -t string zook:terminal "Y" "../Sample Applications/SmpegOpener-S"
addattr -t string zook:keepopen "Y" "../Sample Applications/SmpegOpener-S"
addattr -t string zook:dir "/boot/home/Desktop" "../Sample Applications/SmpegOpener-S"
addattr -t string zook:command 'smpeg $zkfiles' "../Sample Applications/SmpegOpener-S"
addattr -t string folder:comment "Opens MPEG movies in smpeg" "../Sample Applications/SmpegOpener-S"  

mimeset -f "../Sample Applications/EmacsOpener"
mimeset -f "../Sample Applications/GhostOpener"
mimeset -f "../Sample Applications/ListFolder"
mimeset -f "../Sample Applications/MountThis"
mimeset -f "../Sample Applications/PicoOpener"
mimeset -f "../Sample Applications/PrefAppStripper"
mimeset -f "../Sample Applications/SmpegOpener-S"
