#!/usr/bin/env bash
# Author:
#  Héctor Molinero Fernández <hector@molinero.xyz>.
#

#=======================================#
GIT_REMOTE='https://android.googlesource.com/platform/external/noto-fonts'
GIT_BRANCH='android-6.0.1_r3'
GIT_FOLDER='NotoColorEmoji-git'
GIT_TTF='other/NotoColorEmoji.ttf'

EMOJI_FOLDER='NotoColorEmoji-img'

CHUNK_START='89504e470d0a1a0a'
CHUNK_END='49454e44ae426082'

#=======================================#
infoMsg() {
	echo -e "\e[1;33m + \e[1;32m$1 \e[0m"
}

#=======================================#
infoMsg "Removing previous files..."

rm -rf $EMOJI_FOLDER $GIT_FOLDER

#=======================================#
infoMsg "Cloning remote repository..."

git clone --branch $GIT_BRANCH $GIT_REMOTE $GIT_FOLDER

#=======================================#
infoMsg "Extracting images..."

mkdir -p $EMOJI_FOLDER

HEX_DUMP=$(xxd -p $GIT_FOLDER/$GIT_TTF | tr -d '\n' | grep -oP "(?s)$CHUNK_START.+?$CHUNK_END")
COUNT=0

while IFS= read -r line; do
	((COUNT++))
	echo "$line" | xxd -p -r > $EMOJI_FOLDER/$COUNT.png
done <<< "$HEX_DUMP"

#=======================================#
if hash pngcheck 2>/dev/null; then
	infoMsg "Checking images..."

	pngcheck -q $EMOJI_FOLDER/*.png
fi

#=======================================#
infoMsg "Removing temp files..."

rm -rf $GIT_FOLDER

exit 0
