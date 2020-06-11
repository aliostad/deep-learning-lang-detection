############################################################################################################
# Author: Adam Sulik                                                                                       #
# Date : 10/15/2014                                                                                        #
# Abstract: This script grabs the cpu load (percentage of load) and averages it out over                   #
#           5 minutes. Since Nagios does checks every 90 seconds what we do is check the cpu               #
#           over a 30 second window 4 times and output those values to a log. Then we go average out the   #
#           last 12 lines in the log (which equates to 4.5 minutes of averages) and based on the load      #
#           lets nagios know if there is a problem.                                                        #
#                                                                                                          #
############################################################################################################


$msg = "Unknown - The Script has failed. Please manually check CPU level to be sure all is well"
$err = 3
$filePath = "C:\Scripts\Nagios\cpulog.txt"
$linesToCheck = 9
$servername = "localhost"

# This PollCPU function grabs the cpu load 3 times and pauses X amount of second between
function PollCPU($time) {
    for($i=0;$i-lt3;$i++){
       (Get-WmiObject -computername $servername win32_processor | Measure-Object -property LoadPercentage -Average).Average|Out-File -FilePath $filePath -Append
       start-sleep -Seconds ($time)
    }
}
function FileLength([string]$arg1) {
    $lines = Get-Content -Path $arg1 |Measure-Object -Line
    $lines = $lines.Lines
    return $lines
}

# This Average function first checks to see if there are proper amount of values to check agains (in this case it would
# be 12 (which is a 4.5 minute span) if there are less than that (probably first time being run and the file was just
# created. It will quickly run the Poll CPU function and recursivly run itself checking again to see if the correct
# number of lines are present, and continue until there are 12 lines.
# if / when the correct number of lines are there we grab the contents of the log file, and average the last 12 lines
# returning that value
function Average{
    if ((FileLength($filePath)) -lt $linesToCheck) {
        PollCPU
        Average
    }else{
        
        $dataDump = Get-Content -Path $filePath | select -Last $linesToCheck
        $sum = 0
        foreach($item in $dataDump){
            $sum = $sum + $item
        }
        $ave = $sum / $linesToCheck
        return $ave
     }
}

# We only need X number of lines (in our case 12) in the log, since we don't want it to become bloated
# the cleanlog function grabs the log data and grabs the last X number of lines then overwrites it with 
# those values. This effectly clears out old data from the log
function CleanLog {
    $dataDump = Get-Content -Path $filePath | select -Last $linesToCheck
    $dataDump | Out-File -FilePath $filePath
}

# Here we check to see if the log file is more than x number of lines and if so cleans the log.
# next we just check to see if the average load is at a certain value we exit out accordingly
# letting nagios know the CPU's average state over the past couple minutes.
function exitAlert {
    $averageValue = Average
    $averageValue = [decimal]::round($averageValue,2)
    if ((FileLength($filePath)) -gt $linesToCheck){
        CleanLog
    }
    if (($averageValue) -ge 90){
        $msg = "Critical - CPU load is at " + $averagevalue + "% utilization"
        $err = 2
    } 
    elseif(($averageValue) -ge 80){
        $msg = "Warning - CPU load is at " + $averagevalue + "% utilization"
        $err = 1
    } else {
        $msg = "OK - CPU load is at " + $averagevalue + "% utilization"
        $err = 0
    }
    Write-Host $msg
    #$host.SetShouldExit($err)
}

# This is the initiator of the script. We first check to see if a log file even exists, if it does not
# then one is created.
function Main {
    if (-not (Test-Path $filePath)){
        New-Item $filePath -ItemType file
    }
PollCPU(.5)
ExitAlert
}

Main