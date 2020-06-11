$ErrorActionPreference = "Stop"

# ************ Load other profile scripts ************

$profileDir = split-path $profile
$MachineName_Work = "PFD4544"

function Load-AutoLoadScripts
(
    $path,
    [switch] $verbose = $false
)
{
    if(!(test-path $path)) {
        Write-Host "Skipping missing auto-load directory $path" -fore Yellow
        return
    }
    
    Write-Host "Loading scripts from '$path' and sub-directories."

    $toLoad = @(gci -recurse $path | 
               ?{$_ -is "System.IO.FileInfo" -and
               (@(".ps1", ".psm1") -contains $_.Extension) -and
               $_.FullName -ne $profile})

    foreach($script in $toLoad)
    {
        switch($script.Extension) {
            ".ps1" {
                . Load-Script $script -verbose:$verbose
            }
            ".psm1" {
                Import-Module -Force -DisableNameChecking $script.FullName
            }
            default {
                throw "Unknown script extension for file $($script.FullName)"
            }
        }
    }
}
function Load-Script
(
    $scriptFile,
    [switch] $verbose = $false
)
{
    # If $scriptFile is a path string, fetch the fileinfo from that path.
    if ($scriptFile -is "String")
    {
        if(test-path $scriptFile) {
            $scriptFile = gi $scriptFile
        }
        else {
            Write-Host "Skipping missing script $scriptFile" -fore Yellow
            return
        }
    }
    
    if($verbose) {
        # Note: $scriptFile is a fileinfo object.
        write-host ("Loading {0}\" -f $scriptFile.Directory.FullName) -nonewline
        write-host $scriptFile.Name -foregroundcolor yellow
    }
    
    . $scriptFile.FullName
}

function Load-ParkerFoxScripts()
{
    if(Test-AtWork)
    {
        . Load-Script "D:\Projects\SVN\Solutions\DeployTools\trunk\DeployTools.PowerShell\Scripts\BuildPc.Main.ps1" -verbose
        . Load-Script "D:\Projects\SVN\Solutions\AspNetStats\Scripts\Poller.ps1" -verbose
        . Load-Script "D:\Projects\SVN\Solutions\PageScanner\PageScanner.ps1" -verbose
    }
    else
    {
        . Load-Script "C:\Data\Code\Parker Fox\Git\DeployTools\Scripts\BuildPc.Main.ps1" -verbose
    }
}

function Test-AtWork()
{
    return $env:computername -eq "$MachineName_Work"
}

function Load-Profile() {

    "`nLoading profile scripts . . . `n"
    Import-Module pscx
    Import-Module posh-git    
    # Import-Module PowerTab
    . Load-ParkerFoxScripts
    . Load-AutoLoadScripts (join-path $profileDir "AutoLoad")
    
    ""
    Init-Ssh
    ""
    " ************* "
    ""
    ""
    ""
}

. Load-Profile