#!/bin/bash
set -o errexit
set -o nounset

REPO_MD5='bbf05a064c4d184550d71595a662e098'
REPO_DIR='/opt/bin'
REPO_NAME='repo'
REPO_PATH="${REPO_DIR}/${REPO_NAME}"
REPO_URL='https://android.git.kernel.org/repo'

SOURCE_DIR="android-source"
SOURCE_TMP_DIR="/tmp/${SOURCE_DIR}"

sudo apt-get --assume-yes install \
    git

# Setup repo
if [ ! -d "${REPO_DIR}" ]; then
    sudo mkdir "${REPO_DIR}"
fi    
sudo wget -O "$REPO_PATH" "$REPO_URL"
if [ "`openssl md5 "$REPO_PATH" | cut -d ' ' -f 2`" != "$REPO_MD5" ]; then
    echo 'Repo invalid! Aborting.'
    exit 1
fi
sudo chmod a+x "$REPO_PATH"

# Download source
mkdir "${SOURCE_TMP_DIR}"
cd "${SOURCE_TMP_DIR}"
"${REPO_PATH}" init -u git://android.git.kernel.org/platform/manifest.git
"${REPO_PATH}" sync

# Move to source to opt
cd ..
sudo mv "${SOURCE_DIR}" /opt
