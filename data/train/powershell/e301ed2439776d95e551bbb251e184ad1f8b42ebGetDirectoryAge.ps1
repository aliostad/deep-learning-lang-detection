########################################################### 
# AUTHOR      : Patrick Schmidt, support@server-eye.de  
# DATE        : 08-09-2015   
# DESCRIPTION : This scripts checks if an given directory meets the age requirements! (is younger than ...)
#   
# VERSION     : 0.8
########################################################### 

<#
<version>2</version>
<description>Prüft das Alter eines Ordners. (Jünger als ...)</description>
#>

param(
    [string]$dirPath,
    [double]$value,
    [string]$unit
)

#load the libraries from the Server Eye directory
$scriptDir = $MyInvocation.MyCommand.Definition |Split-Path -Parent |Split-Path -Parent

$pathToApi = $scriptDir + "\PowerShellAPI.dll"
$pathToJson = $scriptDir + "\Newtonsoft.Json.dll"
[Reflection.Assembly]::LoadFrom($pathToApi)
[Reflection.Assembly]::LoadFrom($pathToJson)

#init api variables..
$api = new-Object ServerEye.PowerShellAPI
$msg = new-object System.Text.StringBuilder

$exitCode = 0
$version = ""

If (Test-Path $dirPath) 
{ 
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin -EA SilentlyContinue 
    $msg.AppendLine("--Dir: " + $dirPath)

    $lastWriteTime = (get-item $dirPath).LastWriteTime
    $timespan = $null

    switch($unit)
    {

        "days"{$timespan = new-timespan -days $value}
        "hours"{$timespan = new-timespan -hours $value}
        "minutes"{$timespan = new-timespan -Minutes $value}
        "default"{$timespan = new-timespan -days $value}
        

    }

    $totalMinutes = [math]::Round((New-TimeSpan -Start $lastWriteTime  -End (get-date)).TotalMinutes)
     
    if (((get-date) - $lastWriteTime) -gt $timespan) {
        $msg.AppendLine("--ERROR: The directory is older than the given timespan" )
        $msg.AppendLine("----Last write time is " + $lastWriteTime.ToString([System.Globalization.CultureInfo]::CurrentCulture) )
        $api.setStatus([ServerEye.PowerShellStatus]::ERROR)
        $exitCode = -3
    } else {
         $msg.AppendLine("--OK: The directory is within your threshhold!" )
         $msg.AppendLine("----Last write time is " + $lastWriteTime.ToString([System.Globalization.CultureInfo]::CurrentCulture) )
         $exitCode = 0
         $api.setStatus([ServerEye.PowerShellStatus]::OK)
    }

    $api.setMeasurementValue("Age in minutes",[double]$totalMinutes)

}
Else 
{
    $msg.AppendLine("--ERROR: The given path could not be found!")
    $api.setStatus([ServerEye.PowerShellStatus]::ERROR)
    $exitCode = -5
} 

<#api adding #> 
$api.setMessage($msg)  

#write our api stuff to the console. 
Write-Host $api.toJson() 
exit $exitCode