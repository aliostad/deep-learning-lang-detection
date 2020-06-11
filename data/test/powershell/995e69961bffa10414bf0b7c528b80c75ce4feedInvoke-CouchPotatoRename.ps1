function Invoke-CouchPotatoRename 
    {
    [OutputType([Object])]
        Param
        (
        [Parameter(Mandatory=$True,Position=0)]
        [string]
        $couchUrl,

        [Parameter(Mandatory=$True,Position=1)]
        [string]
        $couchApiKey
        )

        # Couchpotato's renamer doesn't work. This function forces a restart after each item is moved. It stops when the "From" path is empty.

        do{
          $renamerlog = Get-CouchLogs -couchUrl $couchUrl -couchApiKey $couchApiKey -lines 1 -logType all 
          }
        until($renamerlog.logCategory -like "[tato.core.plugins.renamer]" -and $renamerlog.logMessage -match "Moving `"")

        Write-Warning "Move in Progress..."
        Start-Sleep -Seconds 60
        
        do{
          $renamerlog = Get-CouchLogs -couchUrl $couchUrl -couchApiKey $couchApiKey -lines 1 -logType all 
          }
        until($renamerlog.logCategory -like "[hpotato.core.plugins.base]" -and $renamerlog.logMessage -match "Opening url:")


        
        Write-Warning "Restarting!"
        Start-Sleep -Seconds 30
        Restart-CouchPotato -couchUrl $couchUrl -couchApiKey $couchApiKey 
          
        do{
          $restartComplete = Test-CouchOnline -couchUrl $couchUrl -couchApiKey $couchApiKey
          }
        until($restartComplete.success -like $True)
        
}


$couchPSettings = Get-CouchSettings -couchUrl $CouchURL -couchApiKey $couchKey

do{
    Invoke-CouchPotatoRename -couchUrl $CouchURL -couchApiKey $CouchAPIKey
    $moviesLeft = (gci $couchPSettings.values.renamer.from)
  }
until($moviesLeft.Count -lt 5)

