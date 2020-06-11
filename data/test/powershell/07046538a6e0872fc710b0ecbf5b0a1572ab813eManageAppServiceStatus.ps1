#### DISCOVERY DATA ####
########################

param($sourceId,$managedEntityId)

## Authentication variables
$user = "darthmaul"
$pwd = "!deathstar" | ConvertTo-SecureString -asPlainText -Force
$limit = 1

$api = New-Object -comObject 'MOM.ScriptAPI'
$discoveryData = $api.CreateDiscoveryData(0, $sourceId, $managedEntityId)
#Log script event
#$api.LogScriptEvent('Scripts/ManageAppServiceStatus.ps1',999,4,$service)

$defUrl = "https://demo1.galacticempire.co.uk/tie-fighter/api/v2/service_states?limit=$limit&offset=$offset"
$cred = New-Object System.Management.Automation.PSCredential($user,$pwd)
$stackStatus = Invoke-RestMethod -Uri $defUrl -Credential $cred

if ($stackStatus.Count -ge 1) 
{
    #appends only the service url for an individual service
    $parsedUrls = $stackStatus.serviceUrl
    #secure requests required else the call fails
    $UrlsParsed = $parsedUrls.Replace("http","https")
    #$UrlsParsed 

    #for each service found perform an addition call to determine the status of the service. 
    foreach ($Url in $UrlsParsed)
    {
		#create discoverty instance
        $instance = $discoveryData.CreateClassInstance("$MPElement[Name='StackAppServiceStatus.Discovery.ProbeService']$")

        $sep = Invoke-WebRequest -uri $url -Credential $cred
        #collects first different data sets
        $svcStatus = $sep | select @{name="Response";Expression ={$_.statuscode}}, @{name="Status";Expression ={$_.statusdescription}} 
        #collects seconds different data sets
        $svcCall = $sep | ConvertFrom-Json | select displayname, serviceTypeUrl, port, serviceport
        #appends both data set together
        $svcStatus | Add-Member -MemberType NoteProperty -Name displayname -Value $svcCall.displayname
        $svcStatus | Add-Member -MemberType NoteProperty -Name serviceTypeUrl -Value $svcCall.serviceTypeUrl
        $svcStatus | Add-Member -MemberType NoteProperty -Name port -Value $svcCall.port
        $svcStatus | Add-Member -MemberType NoteProperty -Name servicePort -Value $svcCall.servicePort
        #formats results
        $svcStatus | ft
        $offset++

		$instance.AddProperty("$MPElement[Name='StackAppServiceStatus.Discovery.ProbeService']/PrincipalName$", $computerName)

		$instance.AddProperty("$MPElement[Name='StackAppServiceStatus.Discovery.ProbeService']/Response$", 'Response' + $svcStatus.response)
		$instance.AddProperty("$MPElement[Name='StackAppServiceStatus.Discovery.ProbeService']/Status$", 'Status' + $svcStatus.status)
		$instance.AddProperty("$MPElement[Name='StackAppServiceStatus.Discovery.ProbeService']/Displayname$", 'Displayname' + $svcStatus.displayname)
		$instance.AddProperty("$MPElement[Name='StackAppServiceStatus.Discovery.ProbeService']/Port$", 'Port' + $svcStatus.port)

		#store all variables into instance
		$discoveryData.AddInstance($instance)
            
    }

        if($offset -ge $limit)
        {
            GetServiceStates($offset)
        }
   
} 

$discoveryData


### UNMODIFIED SCRIPTS [parameters for script discovery not yet added] - Works! ####
######### MULTIPLE SERVICES #############
#$user = "darthmaul"
#$pwd = "!deathstar" | ConvertTo-SecureString -asPlainText -Force
#$limit = 1

#function GetServiceStates($offset)
#{
   
#    $defUrl = "https://demo1.galacticempire.co.uk/tie-fighter/api/v2/service_states?limit=$limit&offset=$offset"
#    $cred = New-Object System.Management.Automation.PSCredential($user,$pwd)
#    #$stackStatus = Invoke-WebRequest -Uri $url -Credential $cred
#    $stackStatus = Invoke-RestMethod -Uri $defUrl -Credential $cred

#    if ($stackStatus.Count -ge 1) 
#	{
#        #appends only the service url for an individual service
#        $parsedUrls = $stackStatus.serviceUrl
#        #secure requests required else the call fails
#        $UrlsParsed = $parsedUrls.Replace("http","https")
#        #$UrlsParsed 

#        #for each service found perform an addition call to determine the status of the service. 
#        foreach ($Url in $UrlsParsed)
#        {
#            $sep = Invoke-WebRequest -uri $url -Credential $cred
#            $svcStatus = $sep | select @{name="Response";Expression ={$_.statuscode}}, @{name="Status";Expression ={$_.statusdescription}} 
#            $svcCall = $sep | ConvertFrom-Json | select displayname, serviceTypeUrl, port, serviceport

#            $svcStatus | Add-Member -MemberType NoteProperty -Name displayname -Value $svcCall.displayname
#            $svcStatus | Add-Member -MemberType NoteProperty -Name serviceTypeUrl -Value $svcCall.serviceTypeUrl
#            $svcStatus | Add-Member -MemberType NoteProperty -Name port -Value $svcCall.port
#            $svcStatus | Add-Member -MemberType NoteProperty -Name servicePort -Value $svcCall.servicePort
#            $svcStatus | ft
			
#			#increment offset
#            $offset++

#        }

#            if($offset -ge $limit)
#			{
#                GetServiceStates($offset)
#            }
   
#    } 
#}

#GetServiceStates(0) 

########## MULTIPLE SERVICES #############
#$user = "denniso"
#$pwd = "*******" | ConvertTo-SecureString -asPlainText -Force
#$defUrl = "https://demo1.galacticempire.co.uk/tie-fighter/api/v2/service_states?limit=1000"
#$cred = New-Object System.Management.Automation.PSCredential($user,$pwd)
##$stackStatus = Invoke-WebRequest -Uri $url -Credential $cred
#$stackStatus = Invoke-RestMethod -Uri $defUrl -Credential $cred

##appends only the service url for an individual service
#$parsedUrls = $stackStatus.serviceUrl
##secure requests required else the call fails
#$UrlsParsed = $parsedUrls.Replace("http","https")
##$UrlsParsed 

##for each service found perform an addition call to determine the status of the service. 
#foreach ($Url in $UrlsParsed)
#{
#    $sep = Invoke-WebRequest -uri $url -Credential $cred
#    $svcStatus = $sep | select @{name="Response";Expression ={$_.statuscode}}, @{name="Status";Expression ={$_.statusdescription}} 
#    $svcCall = $sep | ConvertFrom-Json | select displayname, serviceTypeUrl, port, serviceport

#    $svcStatus | Add-Member -MemberType NoteProperty -Name displayname -Value $svcCall.displayname
#    $svcStatus | Add-Member -MemberType NoteProperty -Name serviceTypeUrl -Value $svcCall.serviceTypeUrl
#    $svcStatus | Add-Member -MemberType NoteProperty -Name port -Value $svcCall.port
#    $svcStatus | Add-Member -MemberType NoteProperty -Name servicePort -Value $svcCall.servicePort
    
#    $svcStatus | ft
#}