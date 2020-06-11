#! /bin/sh

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 检测repo工具是否已经下载
if [ -f $SRC_DIR/repocurl/repo ]; then
	echo "repo exist."
else
	echo "curl repo ..."
	if [ ! -d $SRC_DIR/repocurl ]; then
		mkdir -p $SRC_DIR/repocurl
	fi
	if [ ! -f $SRC_DIR/repocurl/repo ]; then
		curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo > $SRC_DIR/repocurl/repo
		chmod +x $SRC_DIR/repocurl/repo
	fi
fi

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 检测是否已经初始化
if [ ! -d $SRC_DIR/master ]; then
	mkdir -p $SRC_DIR/master
	cd $SRC_DIR/master
	echo "$PWD - repo init ..."
	$SRC_DIR/repocurl/repo init -u https://android.googlesource.com/platform/manifest
else
	cd $SRC_DIR/master
	print_color.sh -g "$PWD - repo sync ..."
	$SRC_DIR/repocurl/repo forall -c git checkout -f
	$SRC_DIR/repocurl/repo sync
	while [ $? -ne 0 ]
		do
			print_color.sh -g "$PWD - repo sync again ..."
			$SRC_DIR/repocurl/repo sync
		done
fi

