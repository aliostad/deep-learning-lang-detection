<#  
    .NOTES
    ===========================================================================
     Created on:    19-06-2014 15:38
     Created by:    admcso
     Organization:  Helsingor Kommune
     Filename:      CreateManageServiceAccounts.ps1
    ===========================================================================
    .DESCRIPTION
        
#>
#requires -Version 2

<#
.SYNOPSIS 

.DESCRIPTION
    
.PARAMETER p 
    
.EXAMPLE
    
.LINK
    http://msdn.microsoft.com/en-us/library/ms147785(v=vs.90).aspx
#>
New-ADServiceAccount -Name "service01" -ServicePrincipalNames "MSSQLSVC/Machine3.corp.contoso.com" -DNSHostName "service01.contoso.com" -Path "OU=SQL2012,OU=SQL,OU=ServiceAccounts,DC=helsingor,DC=kom"
#Associate the new MSA to the computer account by running the following command: 

Add-ADComputerServiceAccount [-Identity] <ADComputer> <ADServiceAccount[]>

