#
# _2___Restart_AppPool.ps1
#

#Hmm, I want to use the different streams for tracing.

Function Test-VerboseTrace{
    param(
        [string]$message
    )

    Write-Verbose $message
}

Test-VerboseTrace "Hello World"

#Oh, that doesn't work

Function Test-VerboseTrace2{
    param(
        [string]$message
    )

    Write-Verbose $message -Verbose
}

Test-VerboseTrace2 "Hello World"

#Urgh! There has to be a better way. Oh hey, wow - Advanced Functions FTW!

Function Restart-AppPool{
    [cmdletbinding()]
    param(
        [string]$appPoolName
    )

    "Importing web admin module" | Write-Verbose
    Import-Module WebAdministration

    "Going to restart App Pool {0}" -f $appPoolName | Write-Output
    Restart-WebAppPool -Name $appPoolName
}

Restart-AppPool -appPoolName "SOMEAPPPOOLNAME" -Verbose