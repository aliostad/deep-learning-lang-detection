#example 1:

Get-Queue -Server tlex01


#example 2:

Get-TransportService | Get-Queue


#example 3:

Get-TransportService | 
  Get-Queue -Filter {DeliveryType -eq 'DnsConnectorDelivery'}

  
#example 4:

Get-Queue -Server tlex01 -Filter {MessageCount -gt 25}


#example 5:

Get-Queue -Server tlex01 -Filter {Status -eq 'Retry'}


#example 6:

Get-TransportService | 
  Get-Queue -Filter {Status -eq 'Retry'} | 
    Get-Message

	  
#example 7:

Get-TransportService | 
  Get-Message -Filter {FromAddress -like '*contoso.com'}

  
#example 8:

Get-Message -Server tlex01 -Filter {Subject -eq 'test'} | Format-List


#example 9:

Get-Message -Server tlex01 -Filter {Subject -eq 'test'} | 
  Suspend-Message -Confirm:$false


#example 10:

Get-Queue -Identity tlex01\7 | 
  Get-Message | 
    Suspend-Message -Confirm:$false

	  
#example 11:

Get-Message -Server mb1 -Filter {Subject -eq 'test'} | 
  Resume-Message

  
#example 12:

Get-Queue -Identity tlex01\7 | 
  Get-Message | 
    Resume-Message

	  
#example 13:

Get-Queue -Identity tlex01\7 | Retry-Queue


#example 14:

Get-TransportService | 
  Get-Queue -Filter {Status -eq 'Retry'} | 
    Retry-Queue -Resubmit $true

	  
#example 15:

Retry-Queue -Identity tlex01\Unreachable -Resubmit $true


#example 16:

Get-TransportService | 
  Get-Queue -Filter {DeliveryType -eq 'DnsConnectorDelivery'} | 
    Get-Message | Remove-Message -Confirm:$false

	  
#example 17:

Remove-Message -Identity tlex01\10\13 -WithNDR $false -Confirm:$false
