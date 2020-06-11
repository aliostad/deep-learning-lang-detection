#example 1:

Set-Mailbox -Identity dsmith `
-MaxSendSize 10mb `
-MaxReceiveSize 10mb `
-RecipientLimits 100

#example 2:

Get-Mailbox -OrganizationalUnit contoso.com/Marketing | 
  Set-Mailbox -MaxSendSize 10mb `
  -MaxReceiveSize 20mb `
  -RecipientLimits 100

#example 3:

Set-TransportConfig -MaxReceiveSize 10mb `
-MaxRecipientEnvelopeLimit 1000 `
-MaxSendSize 10mb

#example 4:

Set-ReceiveConnector -Identity HUB1\Internet `
-MaxMessageSize 20mb `
-MaxRecipientsPerMessage 100


#example 5:

Get-ReceiveConnector -Identity *\Internet | 
  Set-ReceiveConnector 
  -MaxMessageSize 20mb `
  -MaxRecipientsPerMessage 100

#example 6:

Set-SendConnector -Identity Internet -MaxMessageSize 5mb
