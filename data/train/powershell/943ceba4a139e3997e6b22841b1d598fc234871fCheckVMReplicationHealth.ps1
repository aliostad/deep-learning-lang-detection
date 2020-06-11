$hstname = Hostname
$Replication = Get-VMReplication 
$MessageFail = $hstname + ' Replication Alert'
$SmtpServer = 'fs-ws-1.flintstudios.net'

for ($i=0; $i -lt $Replication.length; $i++) {
            $MessageBody = $hstname+ " has reported a replication status of " + $Replication.health[$i] + ' for server ' + $Replication.name[$i]
            $FailMessageSubject = $Replication.name[$i] + " Replication Alert"
            if ($Replication.health[$i] -ne 'Normal') {
                
             send-mailmessage -to "domains <domains@flintstudios.co.uk>" -from 'alerting@flintsatudios.net' -subject $MessageFail  -body $MessageBody -smtpServer $SmtpServer
        }
        #else{
        #    send-mailmessage -to "Chris <chris@flintstudios.co.uk>" -from 'disastereecovery@flintstudios.net' -subject 'DONT PANIC!'  -body $MessageBody -smtpServer $SmtpServer
        #}

}