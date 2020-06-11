<#
.SYNOPSIS
This will launch a heat stack in openstack.
.DESCRIPTION
   This script will launch a openstack stack, if the template is provide.
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>

param (
	[string]$heat_api =	"http://199.66.81.59:8004/v1",
	[string]$keystone_api = "http://199.66.81.59:5000/v2.0",
	[string]$template_url = "http://www.cossindia.net/axiomio.template"
)	

# Prompt user to provide the user-id and password.
$user_id = Read-Host "OpenstackID"
$password = Read-Host "Password"
$tenant_name = Read-Host "ProjectName"
$stack_name = Read-Host "StackName"

# Make a keystone connection to get the token id.
$a_req_body = '{"auth":{"tenantName":' + '"' + "$tenant_name" + '"' +  ', "passwordCredentials":{"username":' + '"' + "$user_id" + '"' +  ' , "password":' + '"' + "$password" + '"' + ' }}}'
$auth_request = Invoke-RestMethod -Uri "$keystone_api/tokens/"  -Method POST -Body $a_req_body -ContentType application/json
$tenant_id = $auth_request.access.token.tenant.id
$token_id = $auth_request.access.token.id
$token_expiry = $auth_request.access.token.expires |Get-Date

#Set Header with Auth-Token
$headers = @{}
$headers["X-Auth-Token"] = $token_id

#Form the heat api submit data
$heat_req_body = '{"tenant_id":' + '"' + $tenant_id + '"' + ', "stack_name":' + '"' + $stack_name + '"' + ', "template_url":' + '"' + $template_url + '"' + '}'

#Call heat Api and submit stack data to launch stack
$heat_request = Invoke-RestMethod -Headers $headers -Uri "$heat_api/$tenant_id/stacks" -Method POST -Body $heat_req_body -ContentType application/json