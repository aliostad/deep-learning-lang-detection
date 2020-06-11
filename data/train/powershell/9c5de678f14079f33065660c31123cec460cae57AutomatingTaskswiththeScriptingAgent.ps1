#example 1:

<?xml version="1.0" encoding="utf-8" ?>
<Configuration version="1.0">
 <Feature Name="MailboxProvisioning" Cmdlets="New-Mailbox">
  <ApiCall Name="OnComplete">
   if($succeeded) {
    $mailbox = $provisioningHandler.UserSpecifiedParameters["Name"]
    Set-Mailbox $mailbox -SingleItemRecoveryEnabled $true
   }
  </ApiCall>
 </Feature>
</Configuration>


#example 2:


<?xml version="1.0" encoding="utf-8" ?>
<Configuration version="1.0">
  <Feature Name="Mailboxes" Cmdlets="new-mailbox,enable-mailbox">
    <ApiCall Name="OnComplete">
      if($succeeded) {
        $id = $provisioningHandler.UserSpecifiedParameters["Alias"]
        Set-Mailbox $id -SingleItemRecoveryEnabled $true
        Set-CASMailbox $id -ActiveSyncEnabled $false
      }
    </ApiCall>
  </Feature>
</Configuration>
