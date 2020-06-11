<#
[String]$StartupString = $input
$StartupObject = $StartupString.split("|")

[String]$Action = $StartupObject[0]
[String]$ScriptPath = $StartupObject[1]
[String]$LogFile = $StartupObject[2]
#>
$ScriptPath="C:\Users\epierce\Documents\GitHub\MessageServiceWorker-Posh"

Import-Module $ScriptPath\Include\MessageServiceClient.psm1 -Force
Import-Module $ScriptPath\Include\Import-INI.psm1 -Force

$config = Import-INI $ScriptPath\Config\ProvisionAccounts.ini

if ($config["ActiveDirectory"]["Verbose"] -eq "true"){
	$Verbose = $true
} else {
	$Verbose = $false
}

#Set up the credentials we're going to use
$MessageServicePassword = Get-Content $config["MessageService"]["CredentialFile"] | ConvertTo-SecureString
$MessageServiceCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $config["MessageService"]["User"],$MessageServicePassword

$QueueName = $config["MessageService"]["AzureQueueName"]

if ($Verbose){ Write-Host "Resetting In-Process Messages in queue " $QueueName }

$TotalMessages = 0

$InProgressMessages = Get-InProgress -Queue $QueueName -Credentials $MessageServiceCredential

foreach ($message in $InProgressMessages) {
	Set-QueueMessageStatus -Credentials $MessageServiceCredential -Queue $QueueName -Id $message.id -Status "pending" -Verbose $Verbose
}