
$User = "eamon@eamonoreillyhotmail.onmicrosoft.com"
$Password = Get-AutomationVariable -Name 'Password'
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force

$credentials = Get-AutomationPSCredential -Name AzureCred


# Azure AD domain to authenticate against
$AzureADDomain = "eamonoreillyhotmail.onmicrosoft.com"

    
# Generate a JWT token that can manage Azure resources. 
# Use management.core.windows.net for service management API & ARM. Use mangement.azure.com for ARM only API
$AppIdURI = "https://management.core.windows.net/"

# Set up connection object to pass into Invoke-AzureADMethod
$ADConnection = @{"Username"=$User;"AzureADDomain"=$AzureADDomain;"Password"=$Password;"APPIdURI"=$AppIdURI;}


$Token = Get-AzureADToken -Connection $ADConnection

$SubID = "a0968138-bb95-4d6e-8e83-ddb706025359"

$WorkSpace = "eamondemo"
$ResourceGroup = "OI-Default-East-US"

$Query = 'Type=W3CIISLog sSiteName=ignite Computer=IgniteDemo'
$WorkspaceInfo = Get-OMSWorkspace -Token $Token -SubscriptionID $SubID -ResourceGroup $ResourceGroup
$WorkSpaceInfo.Name

$Results = Search-OMSWorkspace -Token $Token -Query $Query -SubscriptionID $SubID -WorkSpace $WorkSpace -ResourceGroup $ResourceGroup
$Results 
