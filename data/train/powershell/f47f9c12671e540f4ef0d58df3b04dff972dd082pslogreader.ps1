# Quest Migrator Logfile Parser
# License See LICENSE.txt
#### Load Config from config.xml ###
## Thanks Keith Hill http://goo.gl/cC9wN ##
$global:appSettings = @{}
$config = [xml](get-content "config.xml")
foreach ($addNode in $config.configuration.appsettings.add) {
 if ($addNode.Value.Contains(‘,’)) {
  # Array case
  $value = $addNode.Value.Split(‘,’)

  for ($i = 0; $i -lt $value.length; $i++) {
    $value[$i] = $value[$i].Trim()
  }
 }
 else {
  # Scalar case
  $value = $addNode.Value
 }
 $global:appSettings[$addNode.Key] = $value
}

$d = Get-Date
$logFileStorePath = $appSettings["LogFileStorePath"]
$logFileRootPath = $appSettings["LogFileRootPath"]
$logFileErrorPath = $appSettings["LogFileErrorPath"]
$copyServerFileName = $appSettings["CopyServerFileName"]
$copyServerSourcePath = $appSettings["CopyServerSourcePath"]
$debug = $appSettings["Debug"]
$logFileDate = $d.Day - 1
# Add more copy machines to the file below.
$copyServers = Import-Csv "$logFileRootPath\$copyServerFileName"
# debug settings below
Write-Host
if ($debug -eq "1") {
    Write-Host "########### DEBUG DATA ###########"
    Write-Host "======== Config file data ======="
    Write-Host "log files being read"
    Write-Host $logFiles
    Write-Host
    Write-Host "Log file directories"
    Write-Host "Logs Store Path"
    Write-Host $logFileStorePath
    Write-Host
    Write-Host "Root Path"
    Write-Host $logFileRootPath
    Write-Host
    Write-Host "Error log Path"
    Write-Host $logFileErrorPath
    Write-Host
    Write-Host "Copy Servers file name"
    Write-Host $copyServerFileName
    Write-Host
    Write-Host "Date logs will be processed from"
    Write-Host $logFileDate
    Write-Host
    Write-Host "List of Copy servers"
    Write-Host $copyServers
    Write-Host
    }
foreach ($server in $copyServers) {
        $copyMachine = $server.CopyMachine
        $copyVolume = $server.Volume
        $sourcePath = "\\$copyMachine\$copyServerSourcePath"
        if ($debug -eq "1") {
        Write-Host "########### DEBUG DATA ##########"
        Write-Host "======== Copy Server Data ======="
        Write-Host "Copy Machine"
        Write-Host $copyMachine
        Write-Host
        Write-Host "Copy Volume"
        Write-Host $copyVolume
        Write-Host
        Write-Host "Logfile Source Path"
        Write-Host $sourcePath
        Write-Host
        } else {
            Write-Host "Processing Machine"
            Write-Host $copyMachine
            $logFileMPath = "$logFileStorePath\$copyMachine"
            if (!(Test-Path -path $logFileStorePath\$copyMachine)) {New-Item $logFileStorePath\$copyMachine -Type Directory}
            $sourceLog = Get-ChildItem $sourcePath\* |? {!$_.PsIsContainer} | % {$_.Name} | where { $_.LastWriteTime.Day -lt $logFileDate}
            foreach ($log in $sourceLog) {
                $result = test-path -path "$logFileMPath\*" -include $log
                    if ($result -like "False"){
                        Write-Host "Copying Logfile" $log
                        Copy-Item "$sourcePath\$log" -Destination "$logFileStorePath\$copyMachine\"
                    }
                 }
            Write-Host 
            $logFiles = Get-ChildItem $logFileStorePath\$copyMachine | where { $_.LastWriteTime.Day -lt $logFileDate}
             foreach ($objFile in $logFiles) {
                Write-Host 
                Write-Host "Processing File"
                Write-Host $objFile -foregroundcolor "green" 
                Write-Host "from $copyMachine for volume $copyVolume"
                $fileName = "$copyVolume-error-$objFile"
                $objresult = test-path -path "$LogFileErrorPath\*" -include $fileName
                    if ($objresult -like "False"){
                        Write-Host "processing Logfile" $objfile
                        Get-Content $logFileStorePath\$copyMachine\$objFile -read 10000 | %{$_} | ? {$_ -like '*Error   *'} | Out-File $logFileErrorPath\$fileName
                    }
                }
            }
        }
