 #!/bin/bash
 
 export SITE_HOME="/home/dmasclet/dirtosave"
 export SAVE_SITE_HOME="/home/dmasclet/dirbackup"
 FilesToSave[0]="abuse.txt";
 FileToSave[1]=""
 
function  check_vars {
 if [[ -z $SITE_HOME ]]
 then
 echo "please set the SITE_HOME directory first : "
 read site_home
 export SITE_HOME="$site_home" 
 echo "SITE_HOME directory has been set to $SITE_HOME"
 fi
 
 if [[ -z $SAVE_SITE_HOME ]]
 then
 echo "please set the SAVE_SITE_HOME directory first : "
 read save_site_home
 export SAVE_SITE_HOME="$save_site_home"
 echo "SAVE_SITE_HOME directory has been set to $SAVE_SITE_HOME"
 fi
 
 
 if [[ ! -d $SITE_HOME ]]
 then
 echo "$SITE_HOME does not exist"
 exit 1
 fi
 
 
 if [[ ! -d $SAVE_SITE_HOME ]]
 then
 echo "$SAVE_SITE_HOME does not exist"
 exit 1 
 fi
 
 
 }
 
function save_site_data {
	#`mkdir $SAVE_SITE_HOME$dataBkUp`
	echo "will save $SITE_HOME to $SAVE_SITE_HOME"
	date=`date "+%Y-%m-%d_%H:%M:%S"`
	#ending slash of $SITE_HOME is important
	rsync -aP --delete --link-dest=$SAVE_SITE_HOME/current $SITE_HOME/ $SAVE_SITE_HOME/backup-$date
	rm -f $SAVE_SITE_HOME/current
	ln -s $SAVE_SITE_HOME/backup-$date $SAVE_SITE_HOME/current
}

function dump_site_data {
echo "dump_site_data is not implemented yet "
}

check_vars && save_site_data && dump_site_data
