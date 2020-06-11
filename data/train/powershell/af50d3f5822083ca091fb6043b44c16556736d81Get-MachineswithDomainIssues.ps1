#this script pulls the event log and parses the computername for all machines having an error
#authenticating to the domain
#5722/6 - 5805/6 - 5723/5
 
$computername = 'tsgdc1.tsg.ds', 'tsgdc2.tsg.ds', 'tsgdc3.tsg.ds'
$daysinpast = 1

$afterdate = (Get-Date).AddDays(-$daysinpast)

$list = foreach ($pc in $computername) {
$message = Get-WinEvent -FilterHashtable @{StartTime = $afterdate;logname='system'; id=5722} -ComputerName $pc | Select-Object Message

    foreach ($line in $message) {
    
    $line.Message.split(" ")[6]
    }
}
$list += foreach ($pc in $computername) {
$message = Get-WinEvent -FilterHashtable @{StartTime = $afterdate;logname='system'; id=5805} -ComputerName $pc | Select-Object Message

    foreach ($line in $message) {
    
    $line.Message.split(" ")[6]
    }
}
$list += foreach ($pc in $computername) {
$message = Get-WinEvent -FilterHashtable @{StartTime = $afterdate;logname='system'; id=5723} -ComputerName $pc | Select-Object Message

    foreach ($line in $message) {
    
    $line.Message.split(" ")[5]
    }
}


$list -replace ("'",'') | sort-object | Get-Unique