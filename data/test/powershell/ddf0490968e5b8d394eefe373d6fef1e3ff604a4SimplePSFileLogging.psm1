<#
    Version:        1.1.0.0
    Author:         Adam Hammond
    Creation Date:  02/05/2016
    Last Change:    Added Write-FileLog
    Description:    Contains functions used to manage log writing to file.
                    
    Link:           https://github.com/HammoTime/SimplePSLogging
    License:        The MIT License (MIT)
#>

Function Enable-FileLogWriting
{
    <#
        .SYNOPSIS
        
        Enables logging to file for the SimplePSLogging library.
        
        .DESCRIPTION
        
        Sets a few global variables that are looked for by 'Write-Message'. Once
        these are set, Write-Message will log every line out to the file given.
        
        .PARAMETER OutputLocation
        
        The file you want to write the output to.
        * Folder must exist.
        * File does not have to exist.
         
        .EXAMPLE
         
        Enable-LogWriting
         
        Output:
        [2016-04-01 00:00:00] [INFO]: Logging is now enabled.
        [2016-04-01 00:00:00] [INFO]: Log output will be available at 'C:\Temp\Log.txt'.
         
        .LINK
         
        https://github.com/HammoTime/SimplePSLogging/
    #>
    param
    (
        [Parameter(Mandatory=$True)]
        $OutputLocation
    )

    $OutputFolder = Split-Path -Parent $OutputLocation
    $FolderExists = $False
    $CanWrite = $False

    if(Test-Path $OutputFolder)
    {
        $FolderExists = $True

        Try
        {
            # System will throw an exception due to security policy
            # if we can't open write on the file.
            # This is also good, because it acts as a 'touch' if
            # the file doesn't exist, so we know we've been successful.
            [System.IO.File]::OpenWrite($OutputLocation).Close()
            $CanWrite = $True
        }
        Catch { }
    }

    if($FolderExists -and $CanWrite) 
    {
        $Global:FileLoggingEnabled = $True
        $Global:LogFileLocation = $OutputLocation

        Write-Message 'Logging is now enabled.'
        Write-Message "Log output will be available at '$OutputLocation'."
    }
    else
    {
        Write-Message 'Logging could not be activated!' ERRR -ForegroundColor Red -BackgroundColor Black
       
        if(!$FolderExists)
        {
            Write-Message "'$OutputFolder' doesn't exist." ERRR -ForegroundColor Red -BackgroundColor Black
        }
        else
        {
            if(!$CanWrite)
            {
                Write-Message "Sorry, you don't have permission to write to '$OutputLocation'." ERRR -ForegroundColor Red -BackgroundColor Black
            }
        }
    }
}

Function Disable-FileLogWriting
{
    <#
        .SYNOPSIS
        
        Disables logging to file for the SimplePSLogging library.
        
        .DESCRIPTION
        
        Unsets a few global variables that are looked for by 'Write-Message'. Once
        these have been destroyed, Write-Message will no longer write output to file.
         
        .EXAMPLE
         
        Disable-LogWriting
         
        Output:
        [2016-04-01 00:00:00] [INFO]: File logging now disabled on this system.
         
        .LINK
         
        https://github.com/HammoTime/SimplePSLogging/
    #>
    $LoggingHasBeenDisabled = $False
    
    if($Global:FileLoggingEnabled)
    {
        Write-Message 'File logging now disabled on this system.'
        $Global:FileLoggingEnabled = $False
        $Global:LogFileLocation = $null
        $LoggingHasBeenDisabled = $True
    }

    if(!$LoggingHasBeenDisabled)
    {
        Write-Message -ForegroundColor Red 'Logging wasn''t enabled, no action has occured.' ERRR
    }
}

Function Write-FileLog
{
    <#
        .SYNOPSIS
        
        Writes a message out to a log file.
        
        .DESCRIPTION
        
        Takes an output string that is passed from Write-Message and writes it out to file. This can be
        used to write any string to file once Enable-FileLogWriting has been executed (if you want to
        skip using the Write-Message functionality).
        
        .PARAMETER Message
        
        The message you wish to write to file.
         
        .LINK
         
        https://github.com/HammoTime/SimplePSLogging/
    #>
    
    param
    (
        [Parameter(Mandatory=$True)]
        [String]
        $Message
    )
    
    if($Global:FileLoggingEnabled)
    {
        Try
        {
            # Changed to AppendAllText to support -NoNewLine correctly.
            [System.IO.File]::AppendAllText($Global:LogFileLocation, $Message, [System.Text.Encoding]::Unicode)
        }
        Catch
        {
            Write-Host -ForegroundColor Red ($_.Exception | Format-List -Force)
            Disable-LogWriting File
        }
    }
}

Export-ModuleMember -Function Enable-FileLogWriting
Export-ModuleMember -Function Disable-FileLogWriting
Export-ModuleMember -Function Write-FileLog