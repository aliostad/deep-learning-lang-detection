

# Below is a basic script to grab the API service catalog

$userid = "smbmarquee1" #place the user account here

$apiKey = "3158aea1394d20c5ada8353fa3465e31" #place the account’s API key here.

 

$identity = "https://identity.api.rackspacecloud.com/v2.0/tokens"

$creds = @{"auth" = @{"RAX-KSKEY:apiKeyCredentials" =  @{"username" = $userid; "apiKey" = $apiKey}}} | convertTo-Json –depth 2

$catalog = Invoke-RestMethod -Uri $identity -Method POST -Body $creds -ContentType "application/json"

$authToken = @{"X-Auth-Token"=$catalog.access.token.id}

$catalog.access.serviceCatalog #shows the list of current API endpoints.


#1) List servers
#2) Create Server
#3) Display 'Building' until build is done. Then display Admin password, IP address, server name, and server UUID
#4) Create Load Balancer
#5) Place server created above behind load balancer
#6) Take image of server

#List Servers
$DCs = 'hkg','syd','iad','ord','dfw'
foreach ($region in $DCs)
    {
    Write-host `n`n`n` $region
    $Lsuri =  $Lsuri = (($catalog.access.serviceCatalog | ? name -like "CloudServersO*").endpoints | ? region -like $region).publicURL + '/servers'
    (irm -uri $Lsuri -method GET -Headers $authToken).servers.name

    }

# Create Server
$CSURI = (($catalog.access.serviceCatalog | ? name -like "CloudServersO*").endpoints | where region -like 'DFW').publicURL + '/servers'
$CSDURI = (($catalog.access.serviceCatalog | ? name -like "CloudServersO*").endpoints | where region -like 'DFW').publicURL + '/servers/detail'
$IMURI = (($catalog.access.serviceCatalog | ? name -like "CloudServersO*").endpoints | where region -like 'DFW').publicURL + '/images'
(irm -Uri $IMURI -Headers $authToken -method get).images | ? name -like "*Windows*"
$body = @{server = @{name = 'mswtest'; flavorRef = 'performance1-4'; imageRef = '25f64fd5-4d61-4d4a-8cdb-801de7d9d99b'} } | convertto-json -depth 30
$newserver = irm -Uri $CSURI -Headers $authToken -method POST -Body $body -ContentType application/json

#Building

$building = (irm -Uri $CSDURI -Headers $authToken -method get).servers | ? name -like '*mswtest*' 
while ($building.status -ne 'ACTIVE' )
    {
    write-host Building Server
    sleep 20
    $building = (irm -Uri $CSDURI -Headers $authToken -method get).servers | ? name -like '*mswtest*' 
    }
write-host $newserver.server.name
writehost $newserver.server.id
write-host $newserver.server.adminpass
writehost $building.ipv4address 

#Create LB

$LBURI = (($catalog.access.serviceCatalog | ? name -like "CloudServersO*").endpoints | where region -like 'DFW').publicURL + '/loadbalancers'

$nodes = ""

