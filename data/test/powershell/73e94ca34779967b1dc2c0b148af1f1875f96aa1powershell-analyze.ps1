# analyze powershell scripts using PSScript Analyzer
# the PSScript Analyzer is installed separately from powershell
# PSAvoidUsingWriteHost is excluded because Write-Host can display color

# restart powershell ----------------------------------------------------------

# restart powershell with -noexit 
param($Show)
if (!$Show)
{
    PowerShell -NoExit -NoLogo -File $MyInvocation.MyCommand.Path 1
    return
}

# -----------------------------------------------------------------------------

#clear
Write-Host "Powershell Version $($Host.version.major) $($PSVersionTable.PSVersion)"
$bindir = "$Env:HOME/bin"
Write-Host("Directory $bindir")

$psfiles = Get-ChildItem "$bindir/*.ps1" | foreach { $_.Name }
ForEach ($psfile in $psfiles)
{
    $str = "* " * 25
    Write-Host "`nAnalyzing "$psfile   " $str"
    Invoke-ScriptAnalyzer  -Path $bindir/$psfile `
        -ExcludeRule PSAvoidUsingWriteHost, PSAvoidUsingCmdletAliases
}

Write-Host
# not needed with -noexit
#Write-Host
#Pause_Host
