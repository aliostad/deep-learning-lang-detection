#Copyright (c) 2015 OpenSpan.
#All rights reserved.
#
#The script define a date for the next load from a configuration file
#and start running the next load. The script will fail when the corresponding 
#EDS process fails
#
#@author Andrey Bespalov
#@Date = June 28, 2015 
#@HowToRun = powershell "& 'D:\enkata_storage\FedEx Production Kizhi\OPS\ZeroClickLoad\ContinuousLoads.ps1'" "ContinuousLoads.cfg"

#Initialize a config file name parameter value 
Param(
   [string]$ConfigFile
)

# Global variables 
# Script folder
$Global:ScriptFolder = "D:\enkata_storage\FedEx Production Kizhi Short\OPS\ZeroClickLoad" 
# Load XML folder
$Global:LoadXMLFolder = "D:\autoload" 
# Load XML name
$Global:LoadXMLName = "continuous_load.xml" 
# Name of a script to undeploy, deploy and run loads
$Global:LoadingScriptName = "D:\enkata32\admin-tools\bin\load-script.bat -ups -pG00dcatch -slocalhost -r10990 -tEOD_DM -iD:\Autoload\continuous_load.xml -undeploy -deploy -run"

#Email notifications
$EmailFrom = "Fedex-CatchUpLoads@openspan.com"
$EmailSubject = "Fedex Catch Up: Load status"
$EmailSMPTServer = "smtp.enkata.com"


# Send and Email according to parameters
function SendEmail($To, $From, $Subject, $Body, $smtpServer){
        Send-MailMessage -To $To -Subject $Subject -From $From -Body $Body -priority "High" -SmtpServer $smtpServer
}

#Define a date for next load to start 
function DefineLoadDateForNextLoad{
        if((Test-Path $ConfigFile) -eq 1){
            #Read the first line from the config file
			$_nextdataload = get-content $ConfigFile -totalcount 1
			#$NextDateLoad = $FileContent.Substring(0,2)
		}
        else{
			write-host "The configuration file is not found"
		}
		return $_nextdataload
}

#Modify a configuration file to delete a date for the already completed load
function ModifyConfigFile($NextDataLoad){
		$_filecontent = Get-Content  $ConfigFile | `
		                where-object {$_ -notmatch $NextDataLoad}
						
		set-content -path $ConfigFile -value $_filecontent -force -encoding string
}

# Checking file size and sending an Email in case of an alert
function CheckPreviousLoadStatus {
        # Define a load status
        if( $LastExitCode -eq 0 ){
			return "Completed" 
	    } 
		else{
		    return "Failed"
        }
}

# Generate an xml file with parameters for next load
function GenerateLoadXML ($LoadStartDate){
			
			#$_month 
			if ($LoadStartDate.substring(4,1) -eq "0"){
            	$_month = $LoadStartDate.substring(5,1)}
			else {$_month = $LoadStartDate.substring(4,2)}	
			
			#$_day 
			if ($LoadStartDate.substring(6,1) -eq "0"){
            	$_day = $LoadStartDate.substring(7,1)}
			else {$_day = $LoadStartDate.substring(6,2)}	
			
			#$_year 
			$_year = $LoadStartDate.substring(0,4)
			
			$_loadstartdate_reformated = $_month + "/" + $_day + "/" + $_year 
			
			# Go to the working directory
			set-location -path $LoadXMLFolder
			
            # Generate the XML file 
			remove-item $LoadXMLName -force
			new-item    $LoadXMLName -type file -force
				
				add-content -path $LoadXMLName -value '<?xml version="1.0"?>'
				add-content -path $LoadXMLName -value '<load-script>'
				add-content -path $LoadXMLName -value '	<project>'
				add-content -path $LoadXMLName -value '		<name>FedEx Production Kizhi Short</name>'
				add-content -path $LoadXMLName -value '			<load>'
				add-content -path $LoadXMLName -value '				<name>FedEx Automatic Load</name>'
				add-content -path $LoadXMLName -value "				<fact name=`"CONTACT`" start-date=`"$_loadstartdate_reformated`" end-date=`"$_loadstartdate_reformated`"/>"
				add-content -path $LoadXMLName -value "				<fact name=`"CUSTOMER_ISSUE`" start-date=`"$_loadstartdate_reformated`" end-date=`"$_loadstartdate_reformated`"/>"
				add-content -path $LoadXMLName -value "				<custom-param name=`"StartDate`" value=`"$LoadStartDate`"/>"
				add-content -path $LoadXMLName -value "				<custom-param name=`"StartDate_QA`" value=`"$_loadstartdate_reformated`"/>"
				add-content -path $LoadXMLName -value '				<custom-param name="WaitingBlockStartTime" value="20150630 6:00 PM"/>'
				add-content -path $LoadXMLName -value '				<custom-param name="Skip_RAW_Tables_count_validation" value="no"/>'
				add-content -path $LoadXMLName -value '			</load>'
				add-content -path $LoadXMLName -value '	</project>'
				add-content -path $LoadXMLName -value '</load-script>'
            
			#Set folder back
			set-location -path $ScriptFolder
}

# Main
# Run loads for dates specified in the config file
# If no dates in the file or a blank the script finishes to execute

# Go to the working directory
set-location -path $ScriptFolder

$LoadStatus = "Completed" 
$LoadStartDate = DefineLoadDateForNextLoad

while ($LoadStartDate -ne $Null -and $LoadStartDate -ne " " -and $LoadStatus -eq "Completed"){

		# Initialize initial start date
        $LoadStartDate = DefineLoadDateForNextLoad
			
		# Generate XML to start a load
		if ($LoadStartDate -ne $Null -and $LoadStartDate -ne " "){
			
			# Generate XML file for a load
			GenerateLoadXML($LoadStartDate)
			
			# Start the loading batch file and send an Email
			$_emailBody = 
			"The load for $($LoadStartDate) has been STARTED."
			SendEmail abespalov@openspan.com,schurbanov@openspan.com,mtsurenko@openspan.com,gsprague@openspan.com $EmailFrom $EmailSubject $_emailBody $EmailSMPTServer
			
			cmd.exe /c $LoadingScriptName
									
			$LoadStatus = CheckPreviousLoadStatus
		
			# In case of load completion - send an Email and modify the cfg file 
			if ($LoadStatus -eq "Completed"){
			    
				#Send an Email
				$_emailBody = 
				"The load for $($LoadStartDate) has been COMPLETED successfully."
				SendEmail abespalov@openspan.com,schurbanov@openspan.com,mtsurenko@openspan.com,gsprague@openspan.com $EmailFrom $EmailSubject $_emailBody $EmailSMPTServer
				
				#Modify a config file
				ModifyConfigFile($LoadStartDate)
			}
			else{
				$_emailBody = 
				"The load for $($LoadStartDate) has been FAILED."
				SendEmail abespalov@openspan.com,schurbanov@openspan.com,mtsurenko@openspan.com,gsprague@openspan.com $EmailFrom $EmailSubject $_emailBody $EmailSMPTServer
				
			}
		}
}


