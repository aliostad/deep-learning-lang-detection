#!/bin/bash
#
# A simple script to set up yum/zypper repo from local mirrors v0.1
# 
# wget http://xunyu.asiapacific.hpqcorp.net/repo/repo-setup.sh
#

RHEL_REPOD_PATH=/etc/yum.repos.d
SLES_REPOD_PATH=/etc/zypp/repos.d
REPOD_PATH=

REPO_URL=http://xunyu.asiapacific.hpqcorp.net/repo
#SCRIPT_URL=$REPO_URL/repo-setup.sh

WGET_OPTS="--no-cache"
WGET="wget $WGET_OPTS"

print_info(){
	echo
	echo "Here're repos we provided by now:"
	echo "--------------------------------"
	echo "  OS Version 	| SW | Debug | SRC | SDK |"
	echo "  RHEL5.8ga  	| Y  |   N   |  Y  |  N  |"
	echo "  RHEL5.9ga  	| Y  |   N   |  Y  |  N  |"
	echo "  RHEL5.10b  	| Y  |   Y   |  Y  |  N  |"
	echo "  RHEL5.10s2  	| Y  |   Y   |  N  |  N  |"
	echo "  RHEL6.3ga2 	| Y  |   Y   |  Y  |  N  |"
	echo "  RHEL6.4ga  	| Y  |   Y   |  Y  |  N  |"
	echo "  RHEL7.0a3 	| Y  |   N   |  Y  |  N  |"
	echo "  SLES11sp1  	| Y  |   Y   |  Y  |  N  |"
	echo "  SLES11sp2	| Y  |   Y   |  Y  |  N  |"
	echo "  SLES11sp2gm	| Y  |   Y   |  Y  |  Y  |"
	echo "--------------------------------"
	echo
}

#
# RHEL
#
`grep -q "Red Hat" /etc/issue`
if [ $? -eq 0 ]; then

	REPOD_PATH=$RHEL_REPOD_PATH

	#
	# RHEL5.8ga
	# 
	`grep -q "release 5.8 (Tikanga)" /etc/issue`
	if [ $? -eq 0 ]; then
		$WGET $REPO_URL/rhel5.8ga/rhel5.8ga.repo -P $REPOD_PATH
		$WGET $REPO_URL/rhel5.8ga/rhel5.8ga-src.repo -P $REPOD_PATH
		exit 0
	fi
	
	
	#
	# RHEL5.10s2
	# 
	`grep -q "release 5.10 Beta (Tikanga)" /etc/issue`
	if [ $? -eq 0 ]; then
		$WGET $REPO_URL/rhel5.10s2/rhel5.10s2.repo -P $REPOD_PATH
		$WGET $REPO_URL/rhel5.10s2/rhel5.10s2-debug.repo -P $REPOD_PATH
		exit 0
	fi

	#
	# RHEL6.3ga
	# 
	`grep -q "release 6.3 (Santiago)" /etc/issue`
	if [ $? -eq 0 ]; then
		$WGET $REPO_URL/rhel6.3/rhel6.3ga.repo -P $REPOD_PATH
		$WGET $REPO_URL/rhel6.3/rhel6.3ga-optional.repo -P $REPOD_PATH
		$WGET $REPO_URL/rhel6.3/rhel6.3ga-debug.repo -P $REPOD_PATH
		$WGET $REPO_URL/rhel6.3/rhel6.3ga-src.repo -P $REPOD_PATH
		exit 0
	fi
	
	#
	# RHEL6.4ga
	# 
	`grep -q "release 6.4 (Santiago)" /etc/issue`
	if [ $? -eq 0 ]; then
		$WGET $REPO_URL/rhel6.4ga/rhel6.4ga.repo -P $REPOD_PATH
		$WGET $REPO_URL/rhel6.4ga/rhel6.4ga-debug.repo -P $REPOD_PATH
		$WGET $REPO_URL/rhel6.4ga/rhel6.4ga-optional.repo -P $REPOD_PATH
		$WGET $REPO_URL/rhel6.4ga/rhel6.4ga-src.repo -P $REPOD_PATH
		exit 0
	fi

	#
	# RHEL7.0a2
	#
	`grep -q "release 7.0 Alpha2 (Maipo)" /etc/issue`
	if [ $? -eq 0 ]; then
		$WGET $REPO_URL/rhel7.0/rhel7.0a2.repo -P $REPOD_PATH
		$WGET $REPO_URL/rhel7.0/rhel7.0a2-debug.repo -P $REPOD_PATH
		$WGET $REPO_URL/rhel7.0/rhel7.0a2-src.repo -P $REPOD_PATH
		exit 0
	fi

	#
	# RHEL7.0a3
	#
	`grep -q "release 7.0 Alpha3 (Maipo)" /etc/issue`
	if [ $? -eq 0 ]; then
		$WGET $REPO_URL/rhel7.0a3/rhel7.0a3.repo -P $REPOD_PATH
		$WGET $REPO_URL/rhel7.0a3/rhel7.0a3-optional.repo -P $REPOD_PATH
		$WGET $REPO_URL/rhel7.0a3/rhel7.0a3-src.repo -P $REPOD_PATH
		exit 0
	fi


	#
	# Un-known
	#
	print_info
	exit 1
fi

#
# SLES
#
`grep -q "SUSE" /etc/issue`
if [ $? -eq 0 ]; then
	
	REPOD_PATH=$SLES_REPOD_PATH

	#
	# SLES11sp1
	#
	`grep -q "SUSE Linux Enterprise Server 11 SP1" /etc/issue`
	if [ $? -eq 0 ]; then
		$WGET $REPO_URL/SLES11/SLES11sp1.repo -P $REPOD_PATH
		$WGET $REPO_URL/SLES11/SLES11sp1-debug.repo -P $REPOD_PATH
		#$WGET $REPO_URL/SLES11/SLES11sp1-src.repo -P $REPOD_PATH
		exit 0
	fi

	#
	# SLES11sp2
	#
	`grep -q "SUSE Linux Enterprise Server 11 SP2" /etc/issue`
	if [ $? -eq 0 ]; then
		$WGET $REPO_URL/SLES11/SLES11sp2.repo -P $REPOD_PATH
		$WGET $REPO_URL/SLES11/SLES11sp2-debug.repo -P $REPOD_PATH
		#$WGET $REPO_URL/SLES11/SLES11sp2-src.repo -P $REPOD_PATH
		exit 0
	fi
	
	#
	# SLES11sp3gm
	#
	`grep -q "SUSE Linux Enterprise Server 11 SP3" /etc/issue`
	if [ $? -eq 0 ]; then
		$WGET $REPO_URL/sles11sp3gm/sles11sp3gm.repo -P $REPOD_PATH
		$WGET $REPO_URL/sles11sp3gm/sles11sp3gm-debug.repo -P $REPOD_PATH
		$WGET $REPO_URL/sles11sp3gm/sles11sp3gm-sdk.repo -P $REPOD_PATH
		exit 0
	fi

	#
	# Un-known
	#
	print_info
	exit 1
fi

print_info
exit 1
