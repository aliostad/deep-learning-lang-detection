#!/bin/bash

# HOW TO EXECUTE:
#	1.	SSH into a fresh installation of Ubuntu 12.10 64-bit
#	2.	Put this script anywhere, such as /tmp/install.sh
#	3.	$ chmod +x /tmp/install.sh && /tmp/install.sh
#

# NOTES:
#	1.	IMPORTANT: You must create a .#production file in the root of your Meteor
#		app. An example .#production file looks like this:
#
# 		export MONGO_URL='mongodb://user:pass@linus.mongohq.com:10090/dbname'
# 		export ROOT_URL='http://www.mymeteorapp.com'
# 		export NODE_ENV='production'
# 		export PORT=80
#
#	2.	The APPHOST variable below should be updated to the hostname or elastic
#		IP of the EC2 instance you created.
#
#	3.	The SERVICENAME variable below can remain the same, but if you prefer
#		you can name it after your app (example: SERVICENAME=foobar).
#
#	4.	Logs for you app can be found under /var/log/[SERVICENAME].log
#

################################################################################
# Variables you should adjust for your setup
################################################################################

APPHOST=ec2-54-242-4-24.compute-1.amazonaws.com
SERVICENAME=BieberTweets_angular

################################################################################
# Internal variables
################################################################################

MAINUSER=$(whoami)
MAINGROUP=$(id -g -n $MAINUSER)

GITBAREREPO=/home/$MAINUSER/$SERVICENAME.git
EXPORTFOLDER=/tmp/$SERVICENAME
APPFOLDER=/home/$MAINUSER/$SERVICENAME
APPEXECUTABLE=/home/$MAINUSER/.$SERVICENAME

################################################################################
# Utility functions
################################################################################

function replace {
	sudo perl -0777 -pi -e "s{\Q$2\E}{$3}gm" "$1"
}

function replace_noescape {
	sudo perl -0777 -pi -e "s{$2}{$3}gm" "$1"
}

function symlink {
	if [ ! -f $2 ]
		then
			sudo ln -s "$1" "$2"
	fi
}

function append {
	echo -e "$2" | sudo tee -a "$1" > /dev/null
}

################################################################################
# Task functions
################################################################################

function setup_app_skeleton {
	echo "--------------------------------------------------------------------------------"
	echo "Setup app skeleton"
	echo "--------------------------------------------------------------------------------"

	rm -rf $APPFOLDER
	mkdir -p $APPFOLDER
}

function setup_app_service {
	echo "--------------------------------------------------------------------------------"
	echo "Setup app service"
	echo "--------------------------------------------------------------------------------"

	local SERVICEFILE=/etc/init/$SERVICENAME.conf
	local LOGFILE=/var/log/$SERVICENAME.log

	sudo rm -f $SERVICEFILE

	append $SERVICEFILE "description \"$SERVICENAME\""
	append $SERVICEFILE "author      \"Jason Divock <jdivock@gmail.com>\""

	append $SERVICEFILE "start on runlevel [2345]"
	append $SERVICEFILE "stop on restart"
	append $SERVICEFILE "respawn"

	append $SERVICEFILE "pre-start script"
	append $SERVICEFILE "  echo \"[\$(/bin/date -u +%Y-%m-%dT%T.%3NZ)] (sys) Starting\" >> $LOGFILE"
	append $SERVICEFILE "end script"

	append $SERVICEFILE "pre-stop script"
	append $SERVICEFILE "  rm -f /var/run/$SERVICENAME.pid"
	append $SERVICEFILE "  echo \"[$(/bin/date -u +%Y-%m-%dT%T.%3NZ)] (sys) Stopping\" >> $LOGFILE"
	append $SERVICEFILE "end script"

	append $SERVICEFILE "script"
	append $SERVICEFILE "  sleep 5"
	append $SERVICEFILE "  echo \$\$ > /var/run/$SERVICENAME.pid"
	append $SERVICEFILE "  $APPEXECUTABLE \"$LOGFILE\""
	append $SERVICEFILE "end script"
}

function setup_bare_repo {
	echo "--------------------------------------------------------------------------------"
	echo "Setup bare repo"
	echo "--------------------------------------------------------------------------------"

	rm -rf $GITBAREREPO
	mkdir -p $GITBAREREPO
	cd $GITBAREREPO

	git init --bare
	git update-server-info
}

function setup_post_update_hook {
	echo "--------------------------------------------------------------------------------"
	echo "Setup post update hook"
	echo "--------------------------------------------------------------------------------"

	local HOOK=$GITBAREREPO/hooks/post-receive
	local RSYNCSOURCE=$EXPORTFOLDER/app_rsync

	rm -f $HOOK

	append $HOOK "#!/bin/bash"
	append $HOOK "unset \$(git rev-parse --local-env-vars)"

	append $HOOK "echo \"------------------------------------------------------------------------\""
	append $HOOK "echo \"Exporting app from git repo\""
	append $HOOK "echo \"------------------------------------------------------------------------\""
	append $HOOK "sudo rm -rf $EXPORTFOLDER"
	append $HOOK "mkdir -p $EXPORTFOLDER"
	append $HOOK "git archive master | tar -x -C $EXPORTFOLDER"

	append $HOOK "echo \"------------------------------------------------------------------------\""
	append $HOOK "echo \"Updating production executable\""
	append $HOOK "echo \"------------------------------------------------------------------------\""
	append $HOOK "sudo mv -f $EXPORTFOLDER/.#production $APPEXECUTABLE"
	append $HOOK "echo -e \"\\\n\\\n/usr/bin/node $APPFOLDER/server.js >> \\\$1 2>&1\" >> $APPEXECUTABLE"
	append $HOOK "chmod 700 $APPEXECUTABLE"

	append $HOOK "echo \"------------------------------------------------------------------------\""
	append $HOOK "echo \"Bundling app as a standalone Node.js app\""
	append $HOOK "echo \"------------------------------------------------------------------------\""
	append $HOOK "cd $EXPORTFOLDER"
	append $HOOK "npm install"
	append $HOOK "bower install"
	append $HOOK "grunt build"

	append $HOOK "echo \"------------------------------------------------------------------------\""
	append $HOOK "echo \"Rsync standalone app to active app location\""
	append $HOOK "echo \"------------------------------------------------------------------------\""
	append $HOOK "rsync --checksum --recursive --update --delete --times $EXPORTFOLDER/ $APPFOLDER/"

	append $HOOK "echo \"------------------------------------------------------------------------\""
	append $HOOK "echo \"Restart app\""
	append $HOOK "echo \"------------------------------------------------------------------------\""
	append $HOOK "sudo service $SERVICENAME restart"

	# Clean-up
	append $HOOK "cd $APPFOLDER"
	append $HOOK "sudo rm -rf $EXPORTFOLDER"

	append $HOOK "echo \"\n\n--- Done.\""

	sudo chown $MAINUSER:$MAINGROUP $HOOK
	chmod +x $HOOK
}

function show_conclusion {
	echo -e "\n\n\n\n\n"
	echo "########################################################################"
	echo " On your local development server"
	echo "########################################################################"
	echo ""
	echo "Add remote repository:"
	echo "$ git remote add ec2 $MAINUSER@$APPHOST:$SERVICENAME.git"
	echo ""
	echo "To deploy:"
	echo "$ git push ec2 master"
	echo ""
}

################################################################################


setup_app_skeleton
setup_app_service
setup_bare_repo
setup_post_update_hook
show_conclusion