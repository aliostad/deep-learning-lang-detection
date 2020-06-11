Function Write-Log{
    
<# 

 .Synopsis
  Advanced log writer capable of logging to several outputs at once.

 .Description
  This script will allow for fast logging to several outputs at one time.

 .Parameter Output
  Defines the output sources where the log entries will be written.

 .Parameter Message
  The message that will be logged to the destination outputs.
 
 .Parameter EventType
  Defines the event type registered in the event viewer. Accepted values are: Information, Warning, or Error

 .Parameter ID
  Defines the ID number that will be logged to the event viewer entry.

 .Parameter LogFile
  Defines the log file path and name.
  
 .Parameter EventLogName
  Defines the event log name in event viewer.
  
 .Parameter EventLogSource
  Defines the event log source reported to event viewer.
  
 .Inputs
  None
      Write-Log will accept pipeline commands for the Message parameter only.
  
 .Outputs
  None
      There is no value returned for Write-Log.
  
 .Example
      Write-Log -Message "Error at line 25"
	  Write an event to both the console and event log with the message "Error at line 25".

 .Example
      Write-Log -Output EventLog -Message "Error at line 25" -EventType "Error" -ID 1928
	  Write an event to event viewer as an Error flag, EventID of 1928, and the message "Error at line 25".
 
 .Link
      http://technology.man.co/sites/Engineering/windows/Shared%20Documents/Powershell/Modules/Manheim-General/Manheim-General.docx
	  
#>
	
	[cmdletBinding()]
	param(
        [parameter(Position=0,HelpMessage="Which Log(s) Would You Like To Send The Message?")]
		[ValidateSet("","Console","LogFile","EventLog","LogsOnly","All")]
		[String]$Output,
		
        [parameter(Mandatory=$true,Position=1,HelpMessage="The Message You Would Like To Write To The Log.",ValueFromPipeline=$true)]
		[ValidateNotNullOrEmpty()]
		[String]$Message,
		
        [parameter(HelpMessage="Event Type (Information, Warning, Error)")]
		[ValidateSet("Information","Warning","Error")]
		[String]$EventType = 'Information',
		
        [parameter(HelpMessage="Event Log Id")]
		[ValidateNotNullOrEmpty()]
		[String]$ID = '0',
		
		[parameter(Mandatory=0, HelpMessage="Log File Path and Name")]
		[String]$LogFilePath,
		
		[parameter(HelpMessage="Event Log Name")]
		[ValidateNotNullOrEmpty()]
		[String]$EventLogName,
		
		[parameter(HelpMessage="Event Log Source")]
		[ValidateNotNullOrEmpty()]
		[String]$EventLogSource
    )

    Switch($Output){
        
       	'Console'
			{
				If($EventType -match "Information") {Write-Host $Message}
				ElseIf($EventType -match "Warning") {Write-Warning $Message}
				ElseIf($EventType -match "Error") {Write-Error $Message}
			}
	
		'LogFile'
           	{
				Add-Content -Path $LogFilePath -Value "$(Get-Date): $Message"
			}
       
       	'EventLog'
           	{
				Write-EventLog -LogName $EventLogName -Source $EventLogSource -EntryType $EventType -EventId $ID -Message $Message
			}
        
       	'LogsOnly'
			{
				Add-Content -Path $LogFilePath -Value "$(Get-Date): $Message"
				Write-EventLog -LogName $EventLogName -Source $EventLogSource -EntryType $EventType -EventId $ID -Message $Message
			}
		
		'All' #Console + File + Event Log
           	{
               	If($EventType -match "Information") {Write-Host $Message}
				ElseIf($EventType -match "Warning") {Write-Warning $Message}
				ElseIf($EventType -match "Error") {Write-Error $Message}
               	Add-Content -Path $LogFilePath -Value "$(Get-Date): $Message"
               	Write-EventLog -LogName $EventLogName -Source $EventLogSource -EntryType $EventType -EventId $ID -Message $Message
           	}
        
		Default #Console + Event Log
           	{
               	If($EventType -match "Information") {Write-Host $Message}
				ElseIf($EventType -match "Warning") {Write-Warning $Message}
				ElseIf($EventType -match "Error") {Write-Error $Message}
               	Write-EventLog -LogName $EventLogName -Source $EventLogSource -EntryType $EventType -EventId $ID -Message $Message
           	}    
	}
	
}