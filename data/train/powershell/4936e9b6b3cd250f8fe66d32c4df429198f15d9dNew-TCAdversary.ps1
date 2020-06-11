function New-TCAdversary {
<#
.SYNOPSIS
	Creates a new adversary in Threat Connect.

.PARAMETER Name
	Name of the adversary to create.
	
.EXAMPLE
	New-TCAdversary -Name <AdversaryName>
#>
[CmdletBinding()]Param(
	[Parameter(Mandatory=$True)][ValidateNotNullOrEmpty()][String]$Name
)

# Create a Custom Object and add the provided Name and Value variables to the object
$CustomObject = "" | Select-Object -Property  name
$CustomObject.name = $Name

# Convert the Custom Object to JSON format for use with the API
$JSONData = $CustomObject | ConvertTo-Json

# Child URL for Adversary Creation
$APIChildURL = "/v2/groups/adversaries"

# Generate the appropriate Headers for the API Request
$AuthorizationHeaders = Get-ThreatConnectHeaders -RequestMethod "POST" -URL $APIChildURL

# Create the URI using System.URI (This fixes the issues with URL encoding)
$URI = New-Object System.Uri ($Script:APIBaseURL + $APIChildURL)

# Query the API
$Response = Invoke-RestMethod -Method "POST" -Uri $URI -Headers $AuthorizationHeaders -Body $JSONData -ContentType "application/json" -ErrorAction SilentlyContinue

# Verify API Request Status as Success or Print the Error
if ($Response.Status -eq "Success") {
	$Response.data | Get-Member -MemberType NoteProperty | Where-Object { $_.Name -ne "resultCount" } | Select-Object -ExpandProperty Name | ForEach-Object { $Response.data.$_ }
} else {
	Write-Verbose "API Request failed with the following error:`n $($Response.Status)"
}
}
