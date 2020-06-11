Function Test-EventLog
{
<#
    .SYNOPSIS
        Tests to see if an Event Log exists

    .DESCRIPTION
        Tests to see if an Event Log exists and returns $true or $false

    .PARAMETER EventLogName
        The Source that generates the Event Log.

    .EXAMPLE
        Test-EventLog -EventLogName Application

        This command Returns a Boolean value. In the above example it returns $true since the Event Log exists.

    .EXAMPLE
        Test-EventLog -EventLogName ApplicationTest

        This command Returns a Boolean value. In the above example it returns $false since the Event Log does not exist.

    .INPUTS
        System.String

    .OUTPUTS
        System.Boolean

    .NOTES
        This function is an Extension that can be used with PSAppDeployToolkit. These Extensions can be used in two ways.
        
        1. Using Extensions with PSAppDeployToolkit (Release\Toolkit\PSADTExtensions)
            
            When used with the Toolkit, take the specially made AppDeployToolkitExtensions.ps1 and add it to your toolkits.
            If you already have custom Extensions, you can copy the contents of the 'PSADT Extensions' region in the 
            AppDeployToolkitExtensions.ps1 and add it to your existing files. You can then add the PSADTExtensions folder 
            to the AppDeployToolkit folder where the AppDeployToolkitExtensions.ps1 resides. The custom Extensions will then 
            be dot sourced during the loading of any Custom Extensions.
            
            Using the Extensions in this way allows for integrated logging with the Toolkit. If using CMTrace output type, 
            the logs will look similar to the example CMTrace output below. In the example you can see how the Extension
            Write-PSADTEventLog's output is also added directly into the log as if it were built in to PSAppDeployToolkit.
             
            
            Log Text                                                   Component              Date/Time                    Thread
            --------                                                   ---------              ---------                    -------
            [Initialization] :: Deployment type is [Installation].	   PSAppDeployToolkit	  4/13/2016 10:09:59 AM	4012   (0x0FAC)
            [Initialization] :: TestEvent Message	                   Write-PSADTEventLog	  4/13/2016 10:18:15 AM	4012   (0x0FAC)
            
                            
        2. Using Extensions as a Module. (Release\NoToolkit\PSADTExtensions)
           
           This can be used with the Toolkit, but it will replace the Built in Logging and Toolkit functions with external
           equivalents. As an example, Write-Log now functions in the following way:
           
           Write-Log -Message $Message -Severity $Severity -Source ${CmdletName}
           
           $Severity = '1' - Write-Verbose is used.
               Input:   Write-Log -Message $Message -Severity 1 -Source ${CmdletName}
               Output:  Write-Verbose -Message "$($Message) `nSource: $($Source)"
           
           $Severity = '2' - Write-Warning is used.
               Input:   Write-Log -Message $Message -Severity 2 -Source ${CmdletName}
               Output:  Write-Warning -Message "$($Message) `nSource: $($Source)"
               
           $Severity = '3' - Write-Error is used.
               Input:   Write-Log -Message $Message -Severity 2 -Source ${CmdletName}
               Output:  Write-Error -Message "$($Message) `nSource: $($Source)"
               
           $DebugMessage = $true - Write-Debug is used.
               Input:   Write-Log -Message $Message -Source ${CmdletName} -DebugMessage
               Output:  Write-Debug -Message "$($Message) `nSource: $($Source)"
           
           This module can be imported and used just like any other module.
           
           I might add some options for the logging to replicate the Toolkit logging output so it can be used outside of the toolkit.
           You could write scripts or other modules with the same logging capabilities as the Toolkit. I have done this in the past 
           with a few specific modules, but I think it might be useful as an option in this module as well.

    .LINK
        http://psappdeploytoolkit.com
#>

    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [String]$EventLogName
    )

    Begin
    {
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }

    Process
    {
        if ([System.Diagnostics.EventLog]::Exists($EventLogName))
        {
            Write-Log -Message 'Event Log Exists' -Severity 1 -Source ${CmdletName}
            Return $true
        }
        else
        {
            Write-Log -Message "Event Log does not Exist" -Severity 1 -Source ${CmdletName}
            Return $false
        }
    }

    End
    {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}