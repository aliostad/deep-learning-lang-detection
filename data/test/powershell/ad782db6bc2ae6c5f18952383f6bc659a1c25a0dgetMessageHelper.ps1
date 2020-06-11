Param 
(
	[Parameter(Mandatory = $true, Position = 0)]
	[ValidateNotNullorEmpty()]
	[string] $Path
	, 
	[Parameter(Mandatory = $false, Position = 1)]
	[ValidateNotNullorEmpty()]
	[string] $ReceiverName
	, 
	[Parameter(Mandatory = $false, Position = 2)]
	[ValidateNotNullorEmpty()]
	[string] $WaitTimeoutSec = 60
	, 
	[Parameter(Mandatory = $false, Position = 3)]
	[ValidateNotNullorEmpty()]
	[string] $Receivemode = 'PeekLock'
)

$moduleName = "biz.dfch.PS.Azure.ServiceBus.Client";			
Import-Module $moduleName -ErrorAction:SilentlyContinue -Force;



$biz_dfch_PS_Azure_ServiceBus_Client.EndpointServerName = (Get-SBFarm).Hosts[0].Name;
$biz_dfch_PS_Azure_ServiceBus_Client.NameSpace = (Get-SBNamespace).Name;
$biz_dfch_PS_Azure_ServiceBus_Client.SharedAccessKeyName = (Get-SBAuthorizationRule -NamespaceName $biz_dfch_PS_Azure_ServiceBus_Client.NameSpace -Name RootManageSharedAccessKey).KeyName;
$biz_dfch_PS_Azure_ServiceBus_Client.SharedAccessKey = (Get-SBAuthorizationRule -NamespaceName $biz_dfch_PS_Azure_ServiceBus_Client.NameSpace -Name RootManageSharedAccessKey).PrimaryKey;
$biz_dfch_PS_Azure_ServiceBus_Client.Factory = Enter-SBServer;

Get-SBMessage -Facility $Path -Receivemode $Receivemode -WaitTimeoutSec $WaitTimeoutSec -BodyAsProperty;
