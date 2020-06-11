$deletes = get-WinEvent -Path C:\Logs\Archive-Security-2012-11-29-06-30-54-125.evtx | where {$_.Message -clike "*DELETE*"} | fl message

foreach ($x in $deletes) {
    $x | gm
    "=================================================================="
}


#Get-WinEvent -FilterHashTable @{Path = "E:\Logs\Archive-Security-2012-11-29-06-30-54-125.evtx"; } | where