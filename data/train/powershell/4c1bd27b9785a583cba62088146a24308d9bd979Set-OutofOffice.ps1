Clear-Host
$Cred = Get-Credential
Add-PSSnapin Quest.ActiveRoles.ADManagement -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Connect-QADService -Service 'DC1.DOMAIN.LOCAL' -Credential $Cred
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://ExchangeServer/PowerShell/ -Authentication Kerberos -Credential $Cred
Import-PSSession $Session -AllowClobber

$OOOUser = Read-Host "Enter user's alias/opID to have the Out Of Office Message Set:"
$OOOMessage = Read-Host "Enter the Out Of Office Message:"
Set-MailboxAutoReplyConfiguration -Identity $OOOUser -autoreplystate enabled -InternalMessage $OOOMessage -ExternalMessage $OOOMessage
