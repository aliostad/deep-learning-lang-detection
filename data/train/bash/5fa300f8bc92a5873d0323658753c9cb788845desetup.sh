#!/bin/sh

REPO_NAME_DEF=apt-repo
REPO_PATH_DEF=~/debian-repo
REPO_DESC_DEF="Private APT repository"

echo "1. Configure APT repository's information:"
read -p "   Path: " REPO_PATH
read -p "   Name: " REPO_NAME
read -p "   Description: " REPO_DESC

if [ -z "$REPO_PATH" ]; then
	REPO_PATH=$REPO_PATH_DEF
fi
if [ -z "$REPO_NAME" ]; then
	REPO_NAME=$REPO_NAME_DEF
fi
if [ -z "$REPO_DESC" ]; then
	REPO_DESC=$REPO_DESC_DEF
fi

echo "2. Generate a GPG key:"
gpg --gen-key
gpg -ao apt-key.asc --export

read -p "   GPG Public Key: " APTKEY

mkdir -p $REPO_PATH/repo
cp -a bin conf $REPO_PATH
sed -i "s|%%REPO_NAME%%|$REPO_NAME|g" $REPO_PATH/conf/release.conf
sed -i "s|%%DESCRIPTION%%|$REPO_DESC|g" $REPO_PATH/conf/release.conf
sed -i "s|%%APTKEY%%|$APTKEY|g" $REPO_PATH/bin/update.sh


echo "3. To access the APT Repository, add apt-key.asc with following command:"
echo "       apt-key add apt-key.asc"

echo ""
echo "4. Add the directory path into web server and restart it."

echo ""
echo "5. Add debian packages under $REPO_PATH/repo/pool/main and run:"
echo "       $REPO_PATH/bin/update.sh"

