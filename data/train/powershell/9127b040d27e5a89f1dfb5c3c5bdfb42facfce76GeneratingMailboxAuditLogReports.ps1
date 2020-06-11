#example 1:

Search-MailboxAuditLog -Identity dsmith -ShowDetails

New-MailboxAuditLogSearch -Name Search1 `
-Mailboxes dsmith,bjones `
-LogonTypes admin,delegate `
-StartDate 1/1/11 `
-EndDate 1/15/11 `
-ShowDetails `
-StatusMailRecipients admin@contoso.com


#example 2:

Search-MailboxAuditLog -Identity dsmith `
-StartDate 1/1/2011 `
-EndDate 3/14/11 `
-ShowDetails | ?{$_.Operation -like '*Delete*'}


#example 3:

Search-MailboxAuditLog -Identity dsmith `
-StartDate 1/1/2011 `
-EndDate 3/14/11 `
-ShowDetails | ?{$_.Operation -like '*Delete*'} | 
  select LogonUserDisplayName,Operation,OperationResult,SourceItems


#example 4:

$logs = Search-MailboxAuditLog -Identity dsmith `
        -LogonTypes Delegate,Admin `
        -ShowDetails | ?{$_.Operation -like '*Delete*'}

$logs | Foreach-Object{
  $mailbox = $_.MailboxResolvedOwnerName
  $deletedby = $_.LogonUserDisplayName
  $LastAccessed = $_.LastAccessed
  $operation = $_.Operation
  $_.sourceitems | Foreach-Object {
    New-Object PSObject -Property @{
      Mailbox = $mailbox
      Subject = $_.SourceItemSubject.Trim()
      Operation = $operation
      Folder = $_.SourceItemFolderPathName.Trim()
      DeletedBy = $deletedby
      TimeDeleted = $LastAccessed
    }
  }
}


#example 5:

$mailboxes = Get-Mailbox | ?{$_.AuditEnabled}
$mailboxes | ForEach-Object {
  Search-MailboxAuditLog -Identity $_.name -ShowDetails
}
