# template file aanmaken
Get-AzureRmRoleDefinition -Name "RuleName" | ConvertTo-Json | Out-File C:\temp\Roles.json
# poviders nakijken vb
Get-AzureRmProviderOperation -OperationSearchString Microsoft.Compute/* | fl Operation
# nieuwe rol aanmaken
New-AzureRmRoleDefinition -InputFile C:\temp\Roles.json

# all roles list
(Get-AzureRmRoleDefinition).Actions


# search AD group
Get-AzureRmADGroup -SearchString <group name in quotes>



# URL

https://azure.microsoft.com/en-us/documentation/articles/role-based-access-control-manage-access-powershell/


