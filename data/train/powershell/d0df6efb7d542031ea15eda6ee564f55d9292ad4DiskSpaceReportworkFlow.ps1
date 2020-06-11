<# 
Scripted workflow, executed by task scheduler collects disk data over WMI and checks their remaining percent assigning each one thresholds for its criticality.
Emails analysts results and formats using HTML generation. 

#>

Import-Module AttendaModule
Import-Module pspasswordproxyws

function GenerateHTMLDiskSpaceReport {


    param(
        $inputObject
    )


    function ConditionalPercentFormat {

        param($inputObject)

        if ($inputObject -gt 10)
        {
        $return = "tg-warning"
        }
        elseif ($inputObject -gt 5)
        {
        $return = "tg-low"
        }
        elseif ($inputObject -gt 0)
        {
        $return = "tg-critical"
        }

        return $return
    }

@"
<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;border-color:#aaa;}
.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#333;background-color:#fff;}
.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#fff;background-color:#f38630;}
.tg .tg-z2zr{background-color:#FCFBE3}

.tg .tg-warning{background-color:#f8ff00}
.tg .tg-low{background-color:#f8a102}
.tg .tg-critical{background-color:#fe0000}

</style>
<table class="tg">
  <tr>
    <th class="tg-031e">CI</th>
    <th class="tg-031e">Drive Letter</th>
    <th class="tg-031e">FreeSpaceMB</th>
    <th class="tg-031e">TotalSizeMB</th>
    <th class="tg-031e">Percent</th>
    <th class="tg-031e">Volume Name</th>
  </tr>
  $(
  $inputObject | foreach {

  $ci = $_.CI
  $drive = $_.caption
  [int]$freeSpace = $_.freespace / 1mb
  [int]$totalsize = $_.totalsize / 1mb
  [int]$percentFree = $_.percentFree
  $name = $_.name

@"
  <tr>
    <td class="tg-031e">$ci</td>
    <td class="tg-z2zr">$drive</td>
    <td class="tg-031e">$freeSpace</td>
    <td class="tg-z2zr">$totalsize</td>
    <td class="$(ConditionalPercentFormat $percentFree)">$percentFree%</td>
    <td class="tg-z2zr">$name</td>
  </tr>
"@
}
)

</table>

"@

}

workflow DiskStatistics {

   param([PSobject[]]$computers)

    foreach –parallel ($computer in $computers){

        $credential = $computer.Credential
        $hostname = $computer.ComputerName

        Get-WmiObject -ClassName win32_logicaldisk -PSComputerName $hostname -PSCredential $credential
        
        }
}

function Get-ServerObjects ($customer) {

    # Custom build CMDB query tool to obtain Regus CI's 
    $ser1 = Get-CMDBItem -cu $customer -serverOnly | ? {$_.type -like "*Windows*"} | select -ExpandProperty CI

    # Building server objects with credentails
     foreach ($server in $ser1) {
        $pass = (Get-ManageCredential -PasswordProxyWS $ws -CI $server)
    
        $ser = new-object -typename PSobject
        $ser | Add-Member -MemberType NoteProperty -Name Credential -Value $null
        $ser | Add-Member -MemberType NoteProperty -Name ComputerName -Value $null
        $ser.ComputerName += $server
        $ser.Credential += $pass
        Write-Verbose "$server"
        $ser
        }


}

function Get-DiskReport ($diskstatistics, [switch]$schedule, [string[]]$recipients, $reportTitle) {

$formatted = $output | Where-Object {$_.Description -like "Local Fixed Disk"} | select @{name='CI';expression={ $_.SystemName }},
                                                                                   @{name='Caption';expression={ $_.Caption }},
                                                                                   @{name='FreeSpace';expression={ $_.FreeSpace }},
                                                                                   @{name='TotalSize';expression={ $_.Size }},
                                                                                   @{name='PercentFree';expression={ ($_.FreeSpace / $_.Size) * 100 }},
                                                                                   @{name='Name';expression={ $_.volumename }}
                                                                                   
$nearWarningThreshold = $formatted | Where-Object {$_.PercentFree -lt 25 -and $_.PercentFree -gt 20}
$warningThreshold = $formatted | Where-Object {$_.PercentFree -lt 19 -and $_.PercentFree -gt 11}
$lowThreshold = $formatted | Where-Object {$_.PercentFree -lt 10 -and $_.PercentFree -gt 06}
$criticalThreshold = $formatted | Where-Object {$_.PercentFree -lt 05 -and $_.PercentFree -gt 00}

$nearWarningThresholdTable  = GenerateHTMLDiskSpaceReport $nearWarningThreshold
$warningThresholdTable = GenerateHTMLDiskSpaceReport $warningThreshold
$lowThresholdTable = GenerateHTMLDiskSpaceReport $lowThreshold
$criticalThresholdTable = GenerateHTMLDiskSpaceReport $criticalThreshold


$emailBody = @"

<style type="text/css">
h1 {
    font-family: "Lucida Sans Unicode", "Lucida Grande", sans-serif;
    font-style: normal;
    font-size: 25px;
}
h2 {
    font-family: "Lucida Sans Unicode", "Lucida Grande", sans-serif;
    font-style: normal;
    font-size: 15px;
}
</style>

See attached disk statistics for the environment. 

<h1>Critical DiskSpace: (Items $($criticalThreshold.count))</h1>
<h2> 0% - 5% free space</h2>
$criticalThresholdTable

<h1>Low DiskSpace: (Items $($lowThreshold.count))</h1>
<h2> 6% - 10% free space</h2>
$lowThresholdTable

<h1>Warning DiskSpace: (Items $($warningThreshold.count))</h1>
<h2> 11% - 19% free space</h2>
$warningThresholdTable

<h1>Near Warning DiskSpace: (Items $($nearWarningThreshold.count))</h1>
<h2> 20% - 25% free space</h2>
$nearWarningThresholdTable

Regards,
<br>
Luke Griffith
"@



Send-MailMessage -to $recipients -bcc "<Luke.Griffith@attenda.com>"  -From "<support@attenda.com>" -Subject $reportTitle -Body "$emailBody" -SmtpServer 217.64.226.204 -BodyAsHtml

$date = get-date -UFormat %d/%m/%y

if (!(test-path -Path "Wrk:\DiskReports\$reportTitle.csv"))
{
    New-Item -Path "wrk:\DiskReports\$reportTitle.csv" -ItemType f -Value "$reportTitle - LogStarted $date"
}

Add-Content -Value "$date, $($nearWarningThreshold.count), $($warningThreshold.count), $($lowThreshold.count), $($criticalThreshold.count)" -Path "wrk:\DiskReports\$reportTitle.csv" -Force



}

function  Listen-Job ([string]$jobName,[int]$timeout) {


    $job = Get-Job -Name $jobName
    $time = Get-Date 
    
    while ([bool]($job | Where-Object {$_.State -eq "Running"} | Measure-Object | Select-Object -ExpandProperty Count) -and   ((New-TimeSpan -Start ($time.ToUniversalTime()) -End (Get-Date).ToUniversalTime()).TotalSeconds -lt $timeout))
    {

        $job | Receive-Job 
        

    }
    
}




$customer = <# redacted #>
$reportTitle = <# redacted #>
[string[]]$recipients = <# redacted #>

    $jobName = [guid]::NewGuid()
    $servers = Get-ServerObjects $customer
    DiskStatistics $servers -AsJob -JobName $jobName
    $output = Listen-Job -jobName $jobName -timeout 360
    Get-Job -Name $jobName -IncludeChildJob | Remove-Job -Force
    Get-DiskReport -diskstatistics $output -schedule -recipients $recipients -reportTitle $reportTitle

$customer = <# redacted #>
$reportTitle = <# redacted #>
$recipients = <# redacted #>

    $jobName = [guid]::NewGuid()
    $servers = Get-ServerObjects $customer
    DiskStatistics $servers -AsJob -JobName $jobName
    $output = Listen-Job -jobName $jobName -timeout 360
    Get-Job -Name $jobName | Remove-Job -Force
    Get-DiskReport -diskstatistics $output -schedule -recipients $recipients -reportTitle $reportTitle
    