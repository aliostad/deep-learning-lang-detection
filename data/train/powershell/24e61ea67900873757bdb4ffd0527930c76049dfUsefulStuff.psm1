<# 
  .Synopsis
  A bunch of useful stuff
  
  .Version
  __version__
#>

function Get-Batchfile ($file) {
    $cmd = "`"$file`" & set"
    cmd /c $cmd | Foreach-Object {
        $p, $v = $_.split('=')
        Set-Item -path env:$p -value $v
    }
}

function Prune-Local-Branches() {
    git branch --merged master | grep -v 'master$' | xargs git branch -d
}

function Load-VsVars32-2013()
{
    write-host "Initializing VS2013 Environment"
    
    $vs120comntools = (Get-ChildItem env:VS120COMNTOOLS).Value
    $batchFile = [System.IO.Path]::Combine($vs120comntools, "vsvars32.bat")
    Get-Batchfile $BatchFile
}

export-modulemember -function Load-VsVars32-2013