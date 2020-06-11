# get-allmailboxes.ps1
#
# Script that retrieves a list of all mailboxes through the Rackspace Email Api.  This requires multiple API calls since
# mailboxes exist across multiple customers and domains.
# 
# Usage:
# PS > .\get-allmailboxes.ps1

#Retrieve all domains
.\get-alldomains.ps1 |
	#Filter domains by type
	where { ($_.serviceType -eq 'exchange') -or ($_.serviceType -eq 'both') }  |
	%{
		Write-Host "Retrieving mailboxes for domain $($_.name)" -BackgroundColor Yellow -ForegroundColor Black
		
		.\get-mailboxes.ps1 $_.accountNumber $_.name
	}
