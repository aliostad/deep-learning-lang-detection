ConnectTo-ExchangeOnline

Write-Host "Retrieving message details. Please Wait.."
$MessageList = @()

try {

#Iterate through all properties
foreach ($node in Get-MessageTrace)
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
Out-File -FilePath C:\folder\file-2.csv -Title "My Message Status Report"

}
catch {
Write-Host "Error: $($Error[0].Exception)"
}