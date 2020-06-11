Set-ExecutionPolicy RemoteSigned
Set-AdServerSettings -ViewEntireForest $true

# Uncomment this to make it take effect for all Shared MBs in the listed OU
$sharedOU = "ou=Shared Mailbox Objects,ou=[Global Security Objects],dc=CONTOSO,dc=com"
Write-Host "All shared MBs in " -foregroundcolor green -BackgroundColor black
Write-Host $sharedOU -foregroundcolor red -BackgroundColor black
Write-Host "will have MessageCopyForSentAsEnabled set to True" -foregroundcolor green -BackgroundColor black
Get-Mailbox -ResultSize unlimited -OrganizationalUnit $sharedOU -Filter {(RecipientTypeDetails -eq 'SharedMailbox')} | Set-Mailbox -MessageCopyForSentAsEnabled $true -MessageCopyForSendOnBehalfEnabled $true

# $sharedMB = "exmaple@CONTOSO.com"
# Get-Mailbox -identity $sharedMB | Set-Mailbox -MessageCopyForSentAsEnabled $true -MessageCopyForSendOnBehalfEnabled $true

Write-Host "Completed" -foregroundcolor green -BackgroundColor black