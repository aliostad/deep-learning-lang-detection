<#

Microsoft Lync Server 2013 Powershell cmdlets

#>


#====================================================================================================
# Force the management store to replicate
# Handy once you've made a change 

Invoke-CsManagementStoreReplication -Force

#====================================================================================================
# Displays all users line URI's
# Can also be piped to save to csv/txt.

Get-CSUser | Where { $_.EnterpriseVoiceEnabled } | Select-Object DisplayName,LineURI

#====================================================================================================