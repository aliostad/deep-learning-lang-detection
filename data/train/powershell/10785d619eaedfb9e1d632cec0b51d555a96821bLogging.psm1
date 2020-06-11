#region Private variables
$now = Get-Date
$timestamp = $now.ToString('yyyyMMddHHmmss')
$LogPath = "$PSScriptRoot\Log-$($Env:COMPUTERNAME)-$($env:USERNAME)-$timestamp.txt"
$LogLevel = 'Info'
#endregion Private variables

function Assert-Variable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
        ,
        [Parameter()]
        [ValidateNotNull()]
        [scriptblock]
        $Scriptblock
    )

    if (-Not (Get-Variable -Name LogPath -ErrorAction SilentlyContinue)) {
        if (-Not $Scriptblock) {
            throw ('[{0}] Variable {1} not found. Aborting.' -f $MyInvocation.MyCommand, 'LogPath')

        } else {
            $Scriptblock.Invoke()
        }
    }
}

function Start-LogSession {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path = "$PSScriptRoot\Log-$($Env:COMPUTERNAME).txt"
        ,
        [Parameter()]
        [ValidateSet('Info', 'Verbose', 'Debug')]
        [string]
        $Level = 'Info'
        ,
        [Parameter()]
        [switch]
        $ClearLog
    )

    Process {
        if ($ClearLog) {
            Remove-Item -Path $LogPath -Force
        }

        $LogPath  = $Path
        $LogLevel = $Level

        $now = Get-Date
        Write-Log '================================================================================'
        Write-Log ('[INFO   ] Starting log session on {0} at {1}-{2}-{3} {4}:{5}:{6} for {7}' -f $Env:COMPUTERNAME, $now.Year, $now.Month, $now.Day, $now.Hour, $now.Minute, $now.Second, $env:USERNAME)
    }
}

function Stop-LogSession {
    [CmdletBinding()]
    param()

    Process {
        $now = Get-Date
        Write-Log ('[INFO   ] Ending log session at {0}-{1}-{2} {3}:{4}:{5}' -f $now.Year, $now.Month, $now.Day, $now.Hour, $now.Minute, $now.Second)
    }
}

function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Message
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path = $LogPath
    )

    Begin {
        Assert-Variable -Name LogPath -Scriptblock (Get-Item -Path Function:\Start-LogSession).ScriptBlock
    }

    Process {
        Foreach ($Line in $Message) {
            $Line | Out-File -FilePath $Path -Append
        }
    }
}

function Write-Host {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Message
    )

    Process {
        Write-Log -Message "[INFO   ] $Message"
        Microsoft.Powershell.Utility\Write-Host $Message
    }
}

function Write-Output {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Message
    )

    Process {
        Write-Log -Message "[INFO   ] $Message"

        Microsoft.Powershell.Utility\Write-Output $Message
    }
}
    
function Write-Debug {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Message
    )

    Process {
        Write-Log -Message "[DEBUG  ] $Message"

        if (@('Debug') -contains $LogLevel) {
            Microsoft.Powershell.Utility\Write-Debug -Message $Message
        }
    }
}

function Write-Verbose {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Message
    )

    Process {
        write-Log -Message "[VERBOSE] $Message"

        if (@('Verbose', 'Debug') -contains $LogLevel) {
            Microsoft.Powershell.Utility\Write-Verbose -Message $Message
        }
    }
}

function Write-Warning {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Message
    )

    Process {
        write-Log -Message "[WARNING] $Message"
        Microsoft.Powershell.Utility\Write-Warning -Message $Message
    }
}

function Write-Error {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Message
    )

    Process {
        write-Log -Message "[ERROR  ] $Message"
        Microsoft.Powershell.Utility\Write-Error -Message $Message
    }
}