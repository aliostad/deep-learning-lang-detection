<#
.PURPOSE
Script will display a output of messages sent/received from within a tenant using
the Exchange Online.

. EXAMPLES
PS> Get-MessageTraceReportPS.ps1

.OUTPUT
RecipientAddress
SenderAddress
Subject
Status
Received
ToIP
FromIP
Size
MessageTraceId
MessageId

.NOTES
Your Office 365 tenant must be running the latest (wave15) version and your account
must have the correct administrative rights to retrieve this data.

.AUTHOR
Dan Rose (Cogmotive)

#>

function ConnectTo-ExchangeOnline
{
<# .SYNOPSIS Connects to Exchange Online with tenant credentials .INPUT Tenant Username/Password .RETURN None #>

# Get Credentials
#$Office365Credentials = Get-Credential

# Create remote Powershell session
# $Script:Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $Office365credentials -Authentication Basic –AllowRedirection

 #$Script:Session = New-PSSession-ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Office365Credentials -Authentication Basic -AllowRedirection

# Import the session
#Import-PSSession $Session -AllowClobber | Out-Null
}

ConnectTo-ExchangeOnline

Write-Host "Retrieving message details. Please Wait.."
$MessageList = @()

try {

#Iterate through all properties
#Get-MessageTrace -SenderAddress user@domain.com -StartDate MM/DD/YYYY -EndDate MM/DD/YYYY -PageSize 5000 | Export-Csv c:\folder\file.csv
#foreach ($node in Get-MessageTrace -StartDate 03/23/2015 -EndDate 03/27/2015 -PageSize 5000 | Export-Csv c:\folder\file.csv)
foreach ($node in Get-MessageTrace -PageSize 5000 | Export-Csv c:\folder\file.csv)
{
$ObjProperties = New-Object PSObject

Add-Member -InputObject $ObjProperties -MemberType NoteProperty -Name "RecipientAddress" -Value $node.RecipientAddress
Add-Member -InputObject $ObjProperties -MemberType NoteProperty -Name "SenderAddress" -Value $node.SenderAddress
Add-Member -InputObject $ObjProperties -MemberType NoteProperty -Name "Subject" -Value $node.Subject
Add-Member -InputObject $ObjProperties -MemberType NoteProperty -Name "Received" -Value $node.Received
Add-Member -InputObject $ObjProperties -MemberType NoteProperty -Name "ToIP" -Value $node.ToIP
Add-Member -InputObject $ObjProperties -MemberType NoteProperty -Name "FromIP" -Value $node.FromIP
Add-Member -InputObject $ObjProperties -MemberType NoteProperty -Name "Size" -Value $node.Size
Add-Member -InputObject $ObjProperties -MemberType NoteProperty -Name "Status" -Value $node.Status
Add-Member -InputObject $ObjProperties -MemberType NoteProperty -Name "MessageTraceId" -Value $node.MessageTraceId
Add-Member -InputObject $ObjProperties -MemberType NoteProperty -Name "MessageId" -Value $node.MessageId

$MessageList += $objProperties

}

$MessageList |
Out-GridView -Title "My Message Status Report"

}
catch {
Write-Host "Error: $($Error[0].Exception)"
}