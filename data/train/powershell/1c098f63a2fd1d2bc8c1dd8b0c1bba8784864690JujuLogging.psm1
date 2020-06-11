# Copyright 2016 Cloudbase Solutions Srl
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

Import-Module JujuHelper

function Write-JujuLog {
    <#
    .SYNOPSIS
     Write-JujuLog writes a line in the Juju log with the given log level
    .PARAMETER LogLevel
     LogLevel represents the logging level of the message
    .PARAMETER Message
     Message that is to get written to the log
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [ValidateSet("TRACE", "DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL")]
        [string]$LogLevel="INFO"
    )
    PROCESS {
        $cmd = @("juju-log.exe")
        if($LogLevel -eq "DEBUG") {
            $cmd += "--debug"
        }
        $cmd += $Message
        $cmd += @("-l", $LogLevel.ToUpper())
        $return = Invoke-JujuCommand -Command $cmd
    }
}

function Write-JujuDebug {
    <#
    .SYNOPSIS
     Helper function that writes a log message with DEBUG log level.
    .PARAMETER Message
     The message that is to get written to the log
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    PROCESS {
        Write-JujuLog -Message $Message -LogLevel DEBUG
    }
}

function Write-JujuTrace {
    <#
    .SYNOPSIS
     Helper function that writes a log message with TRACE log level.
    .PARAMETER Message
     The message that is to get written to the log
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    PROCESS {
        Write-JujuLog -Message $Message -LogLevel TRACE
    }
}

function Write-JujuInfo {
    <#
    .SYNOPSIS
     Helper function that writes a log message with INFO log level.
    .PARAMETER Message
     The message that is to get written to the log
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    PROCESS {
        Write-JujuLog -Message $Message -LogLevel INFO
    }
}

function Write-JujuWarning {
    <#
    .SYNOPSIS
     Helper function that writes a log message with WARNING log level.
    .PARAMETER Message
     The message that is to get written to the log
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    PROCESS {
        Write-JujuLog -Message $Message -LogLevel WARNING
    }
}

function Write-JujuCritical {
    <#
    .SYNOPSIS
     Helper function that writes a log message with CRITICAL log level.
    .PARAMETER Message
     The message that is to get written to the log
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    PROCESS {
        Write-JujuLog -Message $Message -LogLevel CRITICAL
    }
}

function Write-JujuErr {
    <#
    .SYNOPSIS
     Helper function that writes a log message with ERROR log level.
    .PARAMETER Message
     The message that is to get written to the log
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    PROCESS {
        Write-JujuLog -Message $Message -LogLevel ERROR
    }
}

function Write-JujuError {
    <#
    .SYNOPSIS
     Write an error level message to the juju log and optionally throw an exception using that same message.
    .PARAMETER Message
     Message to write to juju log
    .PARAMETER Fatal
     A boolean value that instructs the commandlet to throw an exception or not
    .NOTES
     Do not use this function. The recommended way of dealing with exceptions is to catch them in the hook itself.
     Write your charm modules to only throw exceptions on fatal errors. Use try{}catch{} in your hook to log the actual
     error.
    #>
    [Obsolete("This function is Obsolete. Please use Write-JujuErr")]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [Alias("Msg")]
        [string]$Message,
        [bool]$Fatal=$true
    )
    PROCESS {
        Write-JujuLog -Message $Message -LogLevel ERROR
        if ($Fatal) {
            Throw $Msg
        }
    }
}

function Get-CallStack {
    <#
    .SYNOPSIS
    Returns an array of three elements, containing: Error message, error position, and stack trace.
    .PARAMETER ErrorRecord
    The error record to extract details from.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord
    )
    PROCESS {
        $message = $ErrorRecord.Exception.Message
        $position = $ErrorRecord.InvocationInfo.PositionMessage
        $trace = $ErrorRecord.ScriptStackTrace
        $info = @($message, $position, $trace)
        return $info
    }
}

function Write-HookTracebackToLog {
    <#
    .SYNOPSIS
    A helper function that accepts an ErrorRecord and writes a full call stack trace of that error to the juju log. This function
    works best when used in a try/catch block. You get a chance to log the error with proper log level before you re-throw it, or
    exit the hook. 
    .PARAMETER ErrorRecord
    The error record to log.
    .PARAMETER LogLevel
    Optional log level to use. Defaults to ERROR.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord,
        [string]$LogLevel="ERROR"
    )
    PROCESS {
        $name = $MyInvocation.PSCommandPath
        Write-JujuLog "Error while running $name" -LogLevel $LogLevel
        $info = Get-CallStack $ErrorRecord
        if($info[0]){
            Write-JujuLog $info[0] -LogLevel $LogLevel
        }
        if($info[1]) {
            Write-JujuLog $info[1] -LogLevel $LogLevel
        }
        foreach ($i in $info[2].Split("`r`n")){
            if($i) {
                Write-JujuLog $i -LogLevel $LogLevel
            }
        }
    }
}

Export-ModuleMember -Function * -Alias *