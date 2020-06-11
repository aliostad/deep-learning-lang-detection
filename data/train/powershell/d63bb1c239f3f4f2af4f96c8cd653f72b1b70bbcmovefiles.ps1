###2016-2-2
##greg.clark@bradleycorp.com
#hot folder script - developed to transfer files from PIM server to Ecommerce Servers

### include files
$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory reusablefunctions.ps1)
#$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
#. (Join-Path $ScriptDirectory setup.ps1) #works, extracting specific use from core functions

#### variables 
#$logfile = "C:\PIMExports\MagentoExports\logs\log.txt"
#$timestamp = Get-Date -format yyyyMMddHHmm
#$moveto = "C:\PIMExports\MagentoExports\archives\$timestamp"
#$moveto = "C:\PIMExports\MagentoExports\archives\idontExist"
#$movefrom = "C:\PIMExports\MagentoExports\"
#$movewhat = "*.csv"
#$triggerFile = "*.trg"

Set-Location $workingDirectory

$userMessage = "Moving Files..."

$userMessage



### test for files to move -- exit if none
if(-not (Test-Path("$movefrom$movewhat")) ){
    $userMessage = "no files to move"
    createPathIfMissing -path "$logfile" -fileType "file"
    logThis -message $userMessage -logPath $logFile
    $userMessage
    
    Start-Sleep -s 3
    exit
}

#### create this archive directory
New-Item -path $moveto -type directory -force

### perform move
if(Test-Path($moveto)){
	Move-Item -path "$movefrom$movewhat" -destination $moveto -force
}else{
    $userMessage = "could not move files to $moveto"
    logThis -message $userMessage -logPath $logFile
    $userMessage
    
    Start-Sleep -s 3
    exit
}

$userMessage = "Files have been archived...exiting"
$userMessage

Start-Sleep -s 3
exit
