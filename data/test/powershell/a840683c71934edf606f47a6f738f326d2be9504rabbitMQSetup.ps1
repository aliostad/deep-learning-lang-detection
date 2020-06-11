##setup!
$apiURL = "http://verfy-cor-dev02:15672/api"; #change URL
$apiUsername = "guest";
$apiPassword = "guest";
$envName = "dev";
$clientName = "jhilden_client";
$clientUsername = "jhilden_user";
$clientPassword = "jhilden_password";
##end setup!

$vhost = $envName + "." + $clientName
$clientUsername = $envName + "." + $clientUsername
$encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($apiUsername+":"+$apiPassword ))
$headers = @{Authorization = "Basic "+$encoded}
$vhostURL = $apiURL + "/vhosts/" + $vhost;
$exchangeName = "AuthComplete";
$queueNameEPCIS = "AuthComplete.EPCIS";
$queueNameES = "AuthComplete.ElasticSearch";

#step 1 create vhost
Try 
{
	$response = Invoke-WebRequest -Uri $vhostURL -Headers $headers
	[console]::Writeline("vhost {0} already exists", $vhost);
}
Catch
{
	$response = Invoke-WebRequest -Uri $vhostURL -Headers $headers -Method Put -ContentType "application/json"
	[console]::Writeline("vhost {0} created", $vhost);
}

#step 2: create user
$userURL = $apiURL + "/users/" + $clientUsername;
Try 
{
	$response = Invoke-WebRequest -Uri $userURL -Headers $headers
	[console]::Writeline("user {0} already exists", $clientUsername);
}
Catch
{	
	$body = "{""password"":""" + $clientPassword + """, ""tags"":""""}";	
	$response = Invoke-WebRequest -Uri $userURL -Headers $headers -Method Put -ContentType "application/json" -Body $body
	[console]::Writeline("user {0} created with password {1}", $clientUsername, $clientPassword);
}

#step 3: assign user to vhost
$permissionsURL = $apiURL + "/permissions/" + $vhost + "/" + $clientUsername
$body = "{""scope"":""client"",""configure"":"""",""write"":"".*"",""read"":"".*""}";	
$response = Invoke-WebRequest -Uri $permissionsURL -Headers $headers -Method Put -ContentType "application/json" -Body $body	
[console]::Writeline("user {0} given permissions on vhost {1}", $clientUsername, $vhost);

#step 3b: assign the admin user to the vhost
$permissionsURL = $apiURL + "/permissions/" + $vhost + "/" + $apiUsername
$body = "{""scope"":""client"",""configure"":"".*"",""write"":"".*"",""read"":"".*""}";	
$response = Invoke-WebRequest -Uri $permissionsURL -Headers $headers -Method Put -ContentType "application/json" -Body $body	
[console]::Writeline("user {0} given permissions on vhost {1} - including configuration", $apiUsername, $vhost);

#step 4: create AuthComplete exchange on the vhost
$exchangeURL = $apiURL + "/exchanges/" + $vhost + "/" + $exchangeName;
$body = "{""type"":""fanout"",""auto_delete"":false,""durable"":true,""arguments"":[]}"
$response = Invoke-WebRequest -Uri $exchangeURL -Headers $headers -Method Put -ContentType "application/json" -Body $body
[console]::Writeline("exchange {0} created (if it didn't already exist) on vhost {1}", $exchangeName, $vhost);

#step 5: create queue AuthComplete.EPCIS
$queueURL = $apiURL + "/queues/" + $vhost + "/" + $queueNameEPCIS;
$body = "{""auto_delete"":false,""durable"":true,""arguments"":[]}"
$response = Invoke-WebRequest -Uri $queueURL -Headers $headers -Method Put -ContentType "application/json" -Body $body
[console]::Writeline("queue {0} created (if it didn't already exist) on vhost {1}", $queueNameEPCIS, $vhost);

#step 6: create queue AuthComplete.ElasticSearch
$queueURL = $apiURL + "/queues/" + $vhost + "/" + $queueNameES;
$body = "{""auto_delete"":false,""durable"":true,""arguments"":[]}"
$response = Invoke-WebRequest -Uri $queueURL -Headers $headers -Method Put -ContentType "application/json" -Body $body
[console]::Writeline("queue {0} created (if it didn't already exist) on vhost {1}", $queueNameES, $vhost);

#step 7: bind exchange AuthComplete to queue AuthComplete.EPCIS
$bindURL = [string]::Format("{0}/bindings/{1}/e/{2}/q/{3}", $apiURL, $vhost, $exchangeName, $queueNameEPCIS);
#echo $bindURL;
$body = "{""routing_key"":"""",""arguments"":[]}";
$response = Invoke-WebRequest -Uri $bindURL -Headers $headers -Method Post -ContentType "application/json" -Body $body
[console]::Writeline("exchange {0} bound to {1} on vhost {2}", $exchangeName, $queueNameEPCIS, $vhost);


#step 8: bind exchange AuthComplete to queue AuthComplete.ElasticSearch
$bindURL = [string]::Format("{0}/bindings/{1}/e/{2}/q/{3}", $apiURL, $vhost, $exchangeName, $queueNameES);
#echo $bindURL;
$body = "{""routing_key"":"""",""arguments"":[]}";
$response = Invoke-WebRequest -Uri $bindURL -Headers $headers -Method Post -ContentType "application/json" -Body $body
[console]::Writeline("exchange {0} bound to {1} on vhost {2}", $exchangeName, $queueNameES, $vhost);