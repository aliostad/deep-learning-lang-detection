#!/bin/sh
###################################
# filename : meminfo.sh
# author:  liu mingming
# date:    2016.03.21
# function: OOM check
# Implementing Measure:sh meminfo.sh time(Unit: Second)
###################################

process_totalpss()
{
#	echo "TOTALPSS*********************************************">>memresult.txt
# 	echo "`date >memresult.txt``procrank | awk '/TOTAL/{ printf $1 "\n"}'>>memresult.txt`"
#	date >>memresult.txt
	procrank | awk '/TOTAL/{ printf $1 "\n"}'>>memresult.txt
	top -n 1 -d 1 >>cpuresult.txt
}


print_one_process()
{
        procrank |grep $1 | awk '{ printf $5 "\n"}'>>USSresult.txt
}

dotest()
{	
	sleep 10
	echo "$1***********************************************">>USSresult.txt
	print_one_process $1 >>USSresult.txt 
	sleep 2
#	am force-stop $1	
}
#process_system()
#{
#	cat /proc/meminfo| grep MemTotal>>memresult.txt
#}
#process_launcher()
#{
#	dotest com.android.launcher3 
#}
process_browser()
{
	am start -a android.intent.action.VIEW -d http://www.baidu.com
	sleep 2
	dotest com.android.browser
}

process_calendar()
{
	am start -n com.android.calendar/.AllInOneActivity
	sleep 2
	dotest com.android.calendar
}
process_camera()
{
	am start -n com.android.camera/com.android.camera.Camera
	sleep 2
	dotest com.android.camera 
}
process_contacts()
{
	am start -n com.android.contacts/com.android.contacts.activities.PeopleActivity
	sleep 2
	dotest com.android.contacts
}
process_dialer()
{
	am start -a android.intent.action.CALL -d tel:10086
	sleep 2
	dotest com.android.phone	
}
process_email()
{
	am start -n com.android.email/com.android.email.activity.Welcome
	sleep 2
	dotest com.android.email 
}
process_mms()
{
	am start -n com.android.mms/com.android.mms.ui.ConversationList
	sleep 2
	dotest com.android.mms 
}
process_music()
{
	am start -a android.intent.action.VIEW -d file:///sdcard/1.mp3 -t audio/*
	sleep 2
	dotest com.android.music 
}
process_notepad()
{
	am start -n com.example.android.notepad/com.example.android.notepad.NotesList
	sleep 2
	dotest com.example.android.notepad
}
process_photoviewer()
{
	am start -a android.intent.action.VIEW -d file:///sdcard/10.jpg -t image/*
	sleep 2
	dotest com.android.camera 
}
process_calculator()
{
	am start -n com.android.calculator2/com.android.calculator2.Calculator
	sleep 2
	dotest com.android.calculator2
		
}
process_deskclock()
{
	am start -n com.android.deskclock/com.android.deskclock.DeskClock
	sleep 2
	dotest com.android.deskclock
}
logcat -c 
logcat -f /sdcard/memlog.txt &
export PATH=$PATH:/data/busybox
echo "">memresult.txt
echo "">cpuresult.txt
cat /proc/meminfo| grep MemTotal>>memresult.txt
echo "TOTALPSS*********************************************">>memresult.txt
t1=`date +%s`>>memresult.txt
#t2=`expr $t1 + $1 \* 60`
t2=`expr $t1 + $1`>>memresult.txt
#i=1
#while [ "$i" -eq 1 ]
#do
#	RESPONSE=
#	echo "-----------------------------------------------"
#	echo "Please choice:"
#	echo "input --ALL"
#	echo "input --Totalpss"
#	echo "input --System"
#	echo "input --Browser"
#	echo "input --Calendar"
#	echo "input --Camera"
#	echo "input --Contacts"
#	echo "input --Dialer"
#	echo "input --Email"
#	echo "input --messaging"
#	echo "input---Music"
#	echo "input---Notepad"
#	echo "input---Photoviewer"
#	echo "inuput--Calculator"
#	echo "input --Deskclock"
#	echo "input --quit---quit testscript"
#	echo "-----------------------------------------------"
#	read   RESPONSE
while [ `date +%s` -lt $t2 ]; do 
	#case $RESPONSE in
	#	ALL)
	process_system
	process_totalpss
	process_browser
	process_calendar
	process_contacts
	process_dialer
	process_email
	process_mms
	process_music
	process_notepad
	process_photoviewer
	process_calculator
	process_deskclock
done
#	;;
#System) 
#	process_system
#	;;
#Launcher)  
#	process_launcher
#	;; 
#Brwoser)
#	process_browser
#	;;
#Calendar)  
#	process_calendar
#	;; 		
#Camera)    
#	process_camera
#	;;  
#Contacts)  
#	process_contacts	
#	;; 
#Dialer)
#	process_dialer
#	;;
#Email)
#	process_email
#	;; 
#messaging) 	
#	process_mms
#	;; 
#Music)	 
#	process_music
#	;; 
#Notepad) 
#	process_notepad
#	;; 
#Photoviewer)
#	process_photoviewer
#	;;	
#Calculator)
#	process_calculator
#	;;
#Deskclock)
#	process_deskclock
#	;;
#quit) i=0
#echo "Quit test,thanks"
#;;
#esac
#done



