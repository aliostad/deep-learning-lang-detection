[Reflection.Assembly]::LoadFile("C:\Program Files (x86)\Microsoft\Exchange\Web Services\2.0\Microsoft.Exchange.WebServices.dll") | Out-Null
$s = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService([Microsoft.Exchange.WebServices.Data.ExchangeVersion]::Exchange2007_SP1)
$s.Credentials = New-Object Net.NetworkCredential('email@domain', 'password')
$s.Url = new-object Uri("https://red001.mail.microsoftonline.com/ews/exchange.asmx")

$inbox = [Microsoft.Exchange.WebServices.Data.Folder]::Bind($s,[Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Inbox)
$mails = $inbox.FindItems(5) 
$mails | % {$_.Load()}
$mails