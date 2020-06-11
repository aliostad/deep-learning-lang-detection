Function Send-NetMessage{ 
<#   
.SYNOPSIS   
    Sends a message to network computers 
  
.DESCRIPTION   
    Allows the administrator to send a message via a pop-up textbox to multiple computers 
  
.EXAMPLE   
    Send-NetMessage "This is a test of the emergency broadcast system.  This is only a test." 
  
    Sends the message to all users on the local computer. 
  
.EXAMPLE   
    Send-NetMessage "Updates start in 15 minutes.  Please log off." -Computername testbox01 -Seconds 30 -VerboseMsg -Wait 
  
    Sends a message to all users on Testbox01 asking them to log off.   
    The popup will appear for 30 seconds and will write verbose messages to the console.  
 
.EXAMPLE 
    ".",$Env:Computername | Send-NetMessage "Fire in the hole!" -Verbose 
     
    Pipes the computernames to Send-NetMessage and sends the message "Fire in the hole!" with verbose output 
     
    VERBOSE: Sending the following message to computers with a 5 delay: Fire in the hole! 
    VERBOSE: Processing . 
    VERBOSE: Processing MyPC01 
    VERBOSE: Message sent. 
     
.EXAMPLE 
    Get-ADComputer -filter * | Send-NetMessage "Updates are being installed tonight. Please log off at EOD." -Seconds 60 
     
    Queries Active Directory for all computers and then notifies all users on those computers of updates.   
    Notification stays for 60 seconds or until user clicks OK. 
     
.NOTES   
    Author: Rich Prescott   
    Blog: blog.richprescott.com 
    Twitter: @Rich_Prescott 
#> 
 
Param( 
    [Parameter(Mandatory=$True)] 
    [String]$Message, 
     
    [String]$Session="*", 
     
    [Parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)] 
    [Alias("Name")] 
    [String[]]$Computername=$env:computername, 
     
    [Int]$Seconds="5", 
    [Switch]$VerboseMsg, 
    [Switch]$Wait 
    ) 
     
Begin 
    { 
    Write-Verbose "Sending the following message to computers with a $Seconds second delay: $Message" 
    } 
     
Process 
    { 
    ForEach ($Computer in $ComputerName) 
        { 
        Write-Verbose "Processing $Computer" 
        $cmd = "msg.exe $Session /Time:$($Seconds)" 
        if ($Computername){$cmd += " /SERVER:$($Computer)"} 
        if ($VerboseMsg){$cmd += " /V"} 
        if ($Wait){$cmd += " /W"} 
        $cmd += " $($Message)" 
 
        Invoke-Expression $cmd 
        } 
    } 
End 
    { 
    Write-Verbose "Message sent." 
    } 
}

Send-NetMessage "The C: drive is passed disk thresholds. Please be mindful of this and clear up when finished." -Computername hfqaeloa