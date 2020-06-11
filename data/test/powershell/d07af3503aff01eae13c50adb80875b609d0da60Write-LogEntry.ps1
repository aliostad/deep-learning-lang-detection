Function Write-LogEntry {
<#
    .SYNOPSIS
    Writes a message to specified log file

    .DESCRIPTION
    Appends a new message to the specified log file

    .PARAMETER LogPath
    Mandatory. Full path of the log file you want to write to. Example: C:\Windows\Temp\Test_Script.log
    
    .PARAMETER MessageType
    Mandatory. Allowed message types: INFO, WARNING, ERROR, CRITICAL, START, STOP, SUCCESS, FAILURE

    .PARAMETER Message
    Mandatory. The string that you want to write to the log

    .PARAMETER TimeStamp
    Optional. When parameter specified will append the current date and time to the end of the line. Useful for knowing
    when a task started and stopped.
    
    .PARAMETER EntryDateTime
    Optional. By default a current date and time is used but it is possible provide any other correct date/time.
    
    .PARAMETER ConvertTimeToUTF
    # Need be filled

    .PARAMETER ToScreen
    Optional. When parameter specified will display the content to screen as well as write to log file. This provides an additional
    another option to write content to screen as opposed to using debug mode.
    
    .PARAMETER

    .INPUTS
    Parameters above

    .OUTPUTS
    None or String

    .NOTES
    
    Version:        1.0.0
    Author:         Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
    Purpose/Change: Initial function development.
    Creation Date:  25/10/2015
    
    Version         1.1.0
    Author:         Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
    Purpose/Change: A date for a message can be declared as parameter, version number corrected 2.0.0 > 1.0.0 corrected
    Creation Date:  26/10/2015
    
    Inspired and partially based on PSLogging module authored by Luca Sturlese - https://github.com/9to5IT/PSLogging
    
    TODO
    Updated examples - add additional with new implemented parameters
    Implement converting day/time to UTF
    Output with colors (?) - Write-Host except Write-Output need to be used
    
    .LINK
    http://9to5IT.com/powershell-logging-v2-easily-create-log-files

    .LINK
    https://github.com/it-praktyk/PSLogging
    
    .LINK
    https://www.linkedin.com/in/sciesinskiwojciech
    

  .EXAMPLE
    Write-LogEntry -LogPath "C:\Windows\Temp\Test_Script.log" -MessageType CRITICAL -Message "This is a new line which I am appending to the end of the log file."

    Writes a new critical log message to a new line in the specified log file.
    
  #>
    
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = "WriteToFile")]
        [Switch]$ToFile,
        [Parameter(Mandatory = $false, ParameterSetName = "WriteToFile")]
        [string]$LogPath,
        [Parameter(Mandatory = $true, HelpMessage = "Allowed values: INFO, WARNING, ERROR, CRITICAL, START, STOP, SUCCESS, FAILURE")]
        [ValidateSet("INFO", "WARNING", "ERROR", "CRITICAL", "START", "STOP", "SUCCESS", "FAILURE")]
        [String]$MessageType,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias("EventMessage", "EntryMessage")]
        [string]$Message,
        [Parameter(Mandatory = $false)]
        [switch]$TimeStamp,
        [Parameter(Mandatory = $false)]
        [Alias("EventDateTime", "EntryDate", "MessageDate")]
        [DateTime]$EntryDateTime = $([DateTime]::Now),
        [Parameter(Mandatory = $false)]
        [switch]$ToScreen
        
    )
    
    
    
    Process {
        
        #Capitalize MessageType value
        [String]$CapitalizedMessageType = $MessageType.ToUpper()
        
        #A padding used to allign columns in output file
        [String]$Padding = " " * $(10 - $CapitalizedMessageType.Length)
        
        #Add TimeStamp to message if specified
        If ($TimeStamp -eq $True) {
            
            [String]$MessageToFile = "[{0}][{1}{2}][{3}]" -f $EntryDateTime, $CapitalizedMessageType, $Padding, $Message
            
            [String]$MessageToScreen = "[{0}] {1}: {2}" -f $EntryDateTime, $CapitalizedMessageType, $Message
            
        }
        Else {
            
            [String]$MessageToFile = "[{0}{1}][{2}]" -f $type, $Padding, $Message
            
            [String]$MessageToScreen = "{0}: {1}" -f $type, $Message
        }
        
        #Write Content to Log
        
        If ($ToFile -eq $true) {
            
            Add-Content -Path $LogPath -Value $MessageToFile
            
        }
        
        #Write to screen for debug mode
        Write-Debug $MessageToScreen
        
        #Write to scren for ToScreen mode
        If ($ToScreen -eq $True) {
            
            Write-Output $MessageToScreen
            
        }
        
    }
}