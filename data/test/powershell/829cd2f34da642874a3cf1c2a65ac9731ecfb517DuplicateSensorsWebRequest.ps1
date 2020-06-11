cd C:\Temp\PRTGWebAPI
$servers = get-content "Servers.txt"
foreach ($server in $servers)
{
invoke-webrequest http://10.1.0.142/api/duplicateobject.htm?id=76518"&"name=Service%20ArcusIPServer"&"targetid=$server"&"login=gsobolev"&"password=P@ssw0rd
###invoke-webrequest http://10.1.0.142/api/duplicateobject.htm?id=76131"&"name=Service%20EGAIS%20-%20Transport%20Terminal%20Monitoring"&"targetid=$server"&"login=gsobolev"&"password=P@ssw0rd 
###invoke-webrequest http://10.1.0.142/api/duplicateobject.htm?id=76130"&"name=Service%20EGAIS%20-%20Transport%20Terminal%20Updater"&"targetid=$server"&"login=gsobolev"&"password=P@ssw0rd
$server+" duplicated"
}
pause