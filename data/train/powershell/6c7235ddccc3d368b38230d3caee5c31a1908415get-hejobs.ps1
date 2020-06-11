# The purpose of this script is to allow various hosted exchange functions to be called from a web form
# e.g.
#	Use webform to create a CSV file (new file each day) with a uuid, jobtype and submitter.
# 	The same webform would also generate a csv with the uuid of the job as the name. This file
#	would contain the required paramaters for the associated jobtype.
#
# Example jobs.csv file:
#	uuid,jobtype,submitter
#	6eae0da3-5640-4aad-866d-5227bd7fa1ef,new-hecustomer,somedude@somedomain.com.au
#	9852699d-bd2d-4b27-a380-a0a171ff357a,new-hemailbox,somefella@somedomain.com.au
#
# The individual job csv's for the above example would be:
#	6eae0da3-5640-4aad-866d-5227bd7fa1ef.csv
#	custname,custshortname,custdomain
#	testcust,tcust,testcust.com.au
#
#	9852699d-bd2d-4b27-a380-a0a171ff357a.csv
#	businessname,displayname,givenname,surname,password
#	testcust,"Accounts TestCustomer",Accounts,#,SuperSecurePsasword111
#
# This script does work however the entire system including the webform has not been completed.


# Global Variables
$wdir="c:/manage/scripts/hejobs/"
$cdir=$wdir + "jobsCompleted/"
$script_pid=$wdir + "get-hejob.pid"
$date=(Get-Date -format "yyyy-MM-dd")
$urlBase="http://yourwebhost.com.au/hejobs/"
$jobList=$urlbase + $date + "/jobs.csv"
$jobsfile=$wdir + "jobs.csv"

# Log Variables
$logfile=$wdir + "process.log"
$postmaster="headmin@yourdomain.com.au"
$smtpserver="somehost.yourdomain.com.au"

# Functions
function logMessage($type, $string){
    $colour=""
    if($type -eq "warning"){$colour = "yellow"}
    elseif($type -eq "error"){$colour = "red"}
    elseif($type -eq "info"){$colour = "white"}
    write-host $string -foregroundcolor $colour
    ($(get-date -format "yyyy-mm-dd_ss") + ":" + $type.ToUpper() + ": " + $string) | out-file -Filepath $logfile -append
}
function logMessageSilently($type, $string){
    $colour=""
    if($type -eq "warning"){$colour = "yellow"}
    elseif($type -eq "error"){$colour = "red"}
    elseif($type -eq "info"){$colour = "white"}
    ($(get-date -format "yyyy-mm-dd_ss") + ":" + $type.ToUpper() + ": " + $string) | out-file -Filepath $logfile -append
}
function emailNotify($submitter, $uuid, $message){Send-MailMessage -SmtpServer $smtpserver -To $submitter -Cc $postmaster -Subject ("Hosted Exchange Automated Task: " + $uuid) -Body $message}
function safeClose{Remove-Item $script_pid; exit 0}
function completeJob($uuid){Move-Item -Path ($wdir + $uuid + ".csv") -Destination ($cdir + $uuid + ".csv"); logMessage info ("Job: " + $uuid + " has been moved to the completed folder.")}
function downloadJobList{$jobsdata=(wget $jobList -OutFile $jobsfile)}
function downloadJob($uuid){
    if(test-path ($wdir + $uuid + ".csv")){Remove-Item ($wdir + $uuid + ".csv"); logMessage warning ("The job file for uuid:" + $uuid + " already existed. Deleted the file.")}
    $thisJobFile=(wget ($urlBase + $date + "/" + $uuid + ".csv") -OutFile ($wdir + $uuid + ".csv"))
}
function validateUUID{
    $uuid=$args
    if($uuid -match("^(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}$")){
        if(test-path ($cdir + $uuid + ".csv")){
            logMessage warning ("Job: " + $uuid + " has already been completed. Skipping")
        }else{
            echo $true
        }
    }else{
        logMessage error ("String: " + $uuid + " is not a valid UUID. Skipping")
        echo $false
    }
}
function process_New-HEMailbox($Job){
    $job | ForEach-Object{
        if($_.surname -eq "#"){
            New-HEMailbox -BusinessName $_.businessname -DisplayName $_.displayname -GivenName $_.givenname
            if($?){
                completeJob $uuid
                emailNotify $submitter $uuid ("Task: " + $uuid + " has completed successfully. Client Mailbox " + $_.givenname + " for " + $_.custname + " has been setup successfully.")
            }else{
                logMessage error ("JobType:" + $jobtype + " with uuid:" + $uuid + " failed to create mailbox for " + $_.businessname)
            }
        }else{
            New-HEMailbox -BusinessName $_.businessname -DisplayName $_.displayname -GivenName $_.givenname -Surname $_.surname
            if($?){
                completeJob $uuid
                emailNotify $submitter $uuid ("Task: " + $uuid + " has completed successfully. Client Mailbox " + $_.givenname + "." + $_.surname + " for " + $_.custname + " has been setup successfully.")
            }else{
                logMessage error ("JobType:" + $jobtype + " with uuid:" + $uuid + " failed to create mailbox for " + $_.businessname)
            }
        }  
    }
}
function process_New-HECustomer($Job){
    $job | ForEach-Object{New-HECustomer -CustName $_.custname -CustShortName $_.custshortname -CustDomain $_.custdomain}
        if($?){
            completeJob $uuid
            emailNotify $submitter $uuid ("Task: " + $uuid + "has completed successfully. Client " + $_.custname + " has been setup successfully.")
        }else{
            logMessage error ("JobType:" + $jobtype + " with uuid:" + $uuid + " failed to create new customer" + $_.custname)
    }
}
function processJob($jobtype, $uuid, $submitter){
    $job=(Import-Csv ($wdir + $uuid + ".csv"))
    if(((Get-Command process_$jobtype).CommandType) -ne "Function"){
        logMessage error ("JobType:" + $jobtype + " doesn't have a valid function associated with it")
    }elseif(((Get-Command process_$jobtype).CommandType) -eq "Function"){
        &process_$JobType $Job
    }
}

# Is the script already running?
if(test-path $script_pid){logMessage error "Process already running. Exiting!"; exit 1}else{echo "0" > $script_pid}

# Remove the old jobs file and download the latest copy.
if(test-path $jobsfile){Remove-Item $jobsfile; downloadJobList}

# Begin the magic!
Import-Csv $jobsfile | ForEach-Object{
    if((validateUUID $_.uuid) -eq $true){
        if(downloadJob $_.uuid){
            processJob $_.jobtype $_.uuid $_.submitter
        }
    }else{
        logMessage error ("The uuid:" + $_.uuid + " was not valid. Skipping!")
        }  
}

# End of show
safeClose