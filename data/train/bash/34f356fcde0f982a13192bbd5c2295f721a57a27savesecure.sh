#!/usr/bin/env zsh 

# Passionaqua.Web SaveSecure a03
# Please read README.md
# Licensed under MIT licence.
[[ -x =notify-send ]] || {echo "You don't have notify-send present in your \$PATH variable. Please fix it" ; exit 1}
echo "Passionaqua SaveSecure"

# Which dir would you like to save?
DIRTOSAVE='~/documents'

# What is your gpg public key?
ADDR_GPG='you@isp.tld'

# Dir where is synced hubiC or Dropbox, or ...
DIRTOPUSH='/home/adrien/hubiC/Documents'

################################################################################
NAMEARCHIVE=$(date +%d.%m.%G)
NAMEARCHIVE="save_$NAMEARCHIVE.tar.gz"

notify-send -u normal -a "SaveSecure" "SaveSecure:" "Starting..."

if [ -d "$DIRTOSAVE" ] && [ -d "$DIRTOPUSH" ]; then
	# We make an archive
	echo "Making archive..."
	notify-send -u normal -a "SaveSecure" "SaveSecure:" "Archiving..."
	tar -czv -f $NAMEARCHIVE $DIRTOSAVE
	# And we encrypt it with GPG
	echo "Encrypting..."
	notify-send -u normal -a "SaveSecure" "SaveSecure:" "Encrypting..."
	gpg --encrypt -r $ADDR_GPG $NAMEARCHIVE
	# Then, we move the archive to the dir to push
	mv $NAMEARCHIVE.gpg $DIRTOPUSH
	# Then, we remove the archive
	rm $NAMEARCHIVE
	echo "Finish."
	notify-send -u normal -a "SaveSecure" "SaveSecure:" "Success."
else
	#Dir to save or dir to push doesnt exists
	echo "Please check that DIRTOSAVE ($DIRTOSAVE) exist and DIRTOPUSH ($DIRTOPUSH) too. Aborted"
	notify-send -u critical -a "SaveSecure" "SaveSecure:" "ABORTED. Please check DIRTOSAVE and DIRTOPUSH."
	exit 1
fi
