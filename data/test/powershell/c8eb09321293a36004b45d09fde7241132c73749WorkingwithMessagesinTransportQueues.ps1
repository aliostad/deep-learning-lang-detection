#example 1:

Get-Queue -Server ex01

#example 2:

Get-TransportServer | Get-Queue

#example 3:

Get-TransportServer | 
  Get-Queue -Filter {DeliveryType -eq 'DnsConnectorDelivery'}

#example 4:

Get-Queue -Server ex01 -Filter {MessageCount -gt 25}

#example 5:

Get-Queue -Server ex01 -Filter {Status -eq 'Retry'}

#example 6:

Get-TransportServer | 
  Get-Queue -Filter {Status -eq 'Retry'} | 
      Get-Message

#example 7:

Get-TransportServer | 
  Get-Message -Filter {FromAddress -like '*contoso.com'}

#example 8:

Get-Message -Server ex01 -Filter {Subject -eq 'test'} | Format-List

#example 9:

Get-Message -Server ex01 -Filter {Subject -eq 'test'} | 
  Suspend-Message -Confirm:$false


#example 10:

Get-Queue -Identity ex01\7 | 
  Get-Message | 
      Suspend-Message -Confirm:$false

#example 11:

Get-Message -Server hub1 -Filter {Subject -eq 'test'} | 
  Resume-Message

#example 12:

Get-Queue -Identity ex01\7 | 
  Get-Message | 
      Resume-Message

#example 13:

Get-Queue -Identity ex01\7 | Retry-Queue

#example 14:

Get-TransportServer | 
  Get-Queue -Filter {Status -eq 'Retry'} | 
      Retry-Queue -Resubmit $true

#example 15:

Retry-Queue -Identity ex01\Unreachable -Resubmit $true

#example 16:

Get-TransportServer | 
  Get-Queue -Filter {DeliveryType -eq 'DnsConnectorDelivery'} | 
      Get-Message | Remove-Message -Confirm:$false

#example 17:

Remove-Message -Identity ex01\10\13 -WithNDR $false -Confirm:$false
