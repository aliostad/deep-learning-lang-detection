function Trace-Robocopy {
    #http://ss64.com/nt/robocopy-exit.html
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)] [scriptblock] $robocopyBlock
    )
    &$robocopyBlock
    $exit = $LastExitCode
    $nl = [Environment]::NewLine
    $OkCopy = "New files from source copied to destination."
    $NoChange = "Source and destination in sync. No files copied."
    $Xtra = "Some Extra files or directories were detected and removed in destination."
    $Mismatches = "Some Mismatched files or directories were detected.`n
    Housekeeping is probably necessary."
    $Fail = "Some files or directories could not be copied (copy errors occurred and the retry limit was exceeded)."
    $Fatal = "Serious error. robocopy did not copy any files."

    $msg=@{
    "16"  =  " $Fatal"
    "15"  =  " $OkCopy $nl $Fail $nl $Mismatches $nl $Xtra"
    "14"  =  " $Fail $nl $Mismatches $nl $Xtra"
    "13"  =  " $OkCopy $nl $Fail $nl $Mismatches"
    "12"  =  " $Fail $nl $Mismatches"
    "11"  =  " $OkCopy $nl $Fail $nl $Xtra"
    "10"  =  " $Fail $nl $Xtra"
    "9"   =  " $OkCopy $nl $Fail"
    "8"   =  " $Fail"
    "7"   =  " $OkCopy $nl $Mismatches $nl  $Xtra"
    "6"   =  " $Mismatches $nl $Xtra"
    "5"   =  " $OkCopy $nl $Mismatches"
    "4"   =  " $Mismatches"
    "3"   =  " $OkCopy $nl $Xtra"
    "2"   =  " $Xtra"
    "1"   =  " $OkCopy"
    "0"   =  " $NoChange"
    }

    if ($msg."$exit" -gt $null) {
        Write-Host -ForegroundColor Yellow $msg."$exit"
    }
    else {
        Write-Host -ForegroundColor Yellow "Unknown ExitCode : $exit"
    }
    
    if (([int]$exit) -ge 8) {
        throw "Robocopy step failed"
    }
}