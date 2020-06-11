#Get-WebSiteStatus
$WebServers=@('SVPMI151','SVPMI152')
$HostHeaders=@('apandu.com','www.upanddo.com')
 foreach ($WebServer in $WebServers) {
    foreach ($HostHeader in $HostHeaders) {
        $HttpStatus=$null
        $HttpRequest=$null
        $HttpRequest=Invoke-WebRequest -uri $WebServer -Headers @{"Host"="$HostHeader"}
        $HttpStatus=$HttpRequest.StatusCode
        IF ($HttpStatus -eq 200) {
            Write-Host "Site $HostHeader in server $WebServer is OK!"
        }
        Else {
            $Message="Site $HostHeader in server $WebServer may be down, please check!"
            Write-Host $Message
        Send-MailMessage -To 'to@contoso.com' -From 'from@contoso.com' -Subject $Message -SmtpServer intramail.ibs.loc
        }
    }
}