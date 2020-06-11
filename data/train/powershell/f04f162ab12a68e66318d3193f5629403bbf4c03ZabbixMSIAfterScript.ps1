# zabbix after-script 
write-host "Stopping zabbix service..."

Stop-Service -displayname "Zabbix Agent"
# zabbix after-script 
$location = "c:\program files\zabbix agent\"
$confSave = "zabbix_agentd.save.conf"
$conf = "zabbix_agentd.conf"


#if(Test-Path c:\program files\zabbix agent\zabbix_agentd.save.conf")
#	{
#	New-Item -Path $location -Name "$confSave" -itemtype file
#	}
copy-item '$location$conf' '$location$confSave'


$in = new-object System.IO.Streamreader('$location$confSave');


$out = new-object System.IO.StreamWriter('$location$confSave');


while ($line  = $in.readline())

                {

                if ($line.startswith("Server="))

                                {

                                $out.writeline("<server>");

                                }

                elseif ($line.startswith("Hostname="))


                                {

                                $out.writeline("Hostname=" + ($env:computername).tolower() + 

"<domainname>");

                                }

                else

                                {

                                $out.writeline($line);

                                }

                }

$out.close();

$in.close();

start-service "Zabbix Agent"
