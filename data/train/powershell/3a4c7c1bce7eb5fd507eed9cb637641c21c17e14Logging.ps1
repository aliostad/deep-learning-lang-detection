. (Join-Path -Path $PSScriptRoot -ChildPath 'Utility.ps1')

#TODO
#- convert log to CSV
#- use PSCustomObject for log entry
#- create custom object with types: [pscustomobject]@{a='1'} | select @{Name='a'; Expression={$_.a -as [int]}} | gm
#- use Start-Job -InitializationScript {}
#- Get-Module Hyper-V | select LogPipelineExecutionDetails

if (-not $LoggingPreference) {
    # SilentlyContinue: Do not log to file
    # Continue: Log to file
    $LoggingPreference = 'SilentlyContinue'
}

if (-not $LoggingLevel) {
    # Info: Write-Host, Write-Output, Write-Error, Write-Warning
    # Verbose: Write-Verbose
    # Debug: Write-Debug
    $LoggingLevel = 'Info'
}

if (-not $LoggingFilePath) {
    $Timestamp = (Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')
    $LoggingFilePath = "$(Get-ScriptPath)\$($Timestamp)_$env:USERNAME@$env:COMPUTERNAME.log"
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
        [ValidateSet('Information', 'Verbose', 'Debug')]
        [string]
        $Level = 'Information'
    )

    Begin {
        if (-not (Test-Path -Path $LoggingFilePath)) {
            'Timestamp;Caller;Level;Message' | Out-File -FilePath $LoggingFilePath
        }
        $CallerInvocationInfo = Get-CallerInvocationInfo -ExcludeLogging
        if (-not $CallerInvocationInfo) {
            $Caller = 'UNKNOWN'
        } else {
            $Caller = Get-InvocationName -InvocationInfo $CallerInvocationInfo
        }
        $Timestamp = (Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')
    }

    Process {
        if ($LoggingPreference -ieq 'Continue') {
            Foreach ($Line in $Message) {
                ('{0};{1};{2};{3}' -f $Timestamp, $Caller, $Level, $Line) | Out-File -FilePath $LoggingFilePath -Append
            }
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
        Write-Log -Message $Message
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
        Write-Log -Message $Message

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
        Write-Log -Message $Message -Level Debug

        if (@('Debug') -contains $LoggingLevel) {
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
        write-Log -Message $Message -Level Verbose

        if (@('Verbose', 'Debug') -contains $LoggingLevel) {
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
        write-Log -Message $Message
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
        write-Log -Message $Message
        Microsoft.Powershell.Utility\Write-Error -Message $Message
    }
}