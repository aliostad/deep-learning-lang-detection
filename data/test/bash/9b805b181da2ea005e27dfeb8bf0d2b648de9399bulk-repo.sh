#!/bin/bash

ORG="usc-csci104-spring2014"
ORGMAN_CMD="python orgman.py $ORG"
GITHUB_URL="git@github.com"

#Load SSH Keys
eval $(ssh-agent)
#For Using Custom Keys
#GITHUB_URL="githubbot"
#ssh-add ~.ssh/bot@github
ssh -T $GITHUB_URL

#Location of Skeliton Repo
REPO_CODE_DIR=/path/to/skel/repo/hw

while read line
do
	#Per student account
	USC_USER=$(echo $line | cut -d, -f1)
	GH_USER=$(echo $line | cut -d, -f2)
	STUDENT_REPO=hw_${USC_USER}
	STUDENT_TEAM=team_${USC_USER}

	echo "[LOG] Working on $USC_USER, $GH_USER"

	#echo $STUDENT_REPO
	#echo $STUDENT_TEAM
	#echo $USC_USER
	#echo $GH_USER
	#echo $REPO_CODE_DIR

	# Create Repo
	$ORGMAN_CMD add --repo $STUDENT_REPO
	git clone --quiet ${GITHUB_URL}:${ORG}/${STUDENT_REPO}.git
	cd $STUDENT_REPO
	git config user.name "Al-Ghanmi Bot"
	git config user.email "alghanmi+bot@usc.edu"
	cp -r $REPO_CODE_DIR/* $REPO_CODE_DIR/.gitignore .
	git add .
	git commit --quiet -m "Data Structures Homework Repsitory - initial commit"
	git push --quiet
	cd ..
	rm -rf $STUDENT_REPO
	
	#Create student-based team
	$ORGMAN_CMD add --team $STUDENT_TEAM --perm push
	$ORGMAN_CMD add --team $STUDENT_TEAM --member $GH_USER

	#Add team to student repo
	$ORGMAN_CMD add --repo $STUDENT_REPO --team $STUDENT_TEAM

	#Add teaching staff, Professors and Graders to student repo
	$ORGMAN_CMD add --repo $STUDENT_REPO --team TechingStaff
	$ORGMAN_CMD add --repo $STUDENT_REPO --team Graders
	
	#Add student to students team
	$ORGMAN_CMD add --team Students --member $GH_USER
	
	#Add Hook
	$ORGMAN_CMD add --repo $STUDENT_REPO --hook https://usc.alghanmi.org/git/log

	
	#Create a set of labels
	$ORGMAN_CMD add --repo $STUDENT_REPO --issues issues.txt --member $GH_USER

done < usernames.list

## EMAIL confirmation
echo -e "Hi,\nDone with setup\n\nRegards,\nRami\n\n[Message Sent From $(hostname)]" | mail -s "Repo Mass Creation" $USER
