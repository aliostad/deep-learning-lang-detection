<#
.SYNOPSIS
    Connects to Azure and retrieves the names of all VMs in the specified Azure subscription

.DESCRIPTION
   This runbook sample demonstrates how to connect to Azure using organization id credential
   based authentication. Before using this runbook, you must create an Azure Active Directory
   user and allow that user to manage the Azure subscription you want to work against. You must
   also place this user's username / password in an Azure Automation credential asset.
   
   You can find more information on configuring Azure so that Azure Automation can manage your
   Azure subscription(s) here: http://aka.ms/Sspv1l

   After configuring Azure and creating the Azure Automation credential asset, make sure to
   update this runbook to contain your Azure subscription name and credential asset name.

.NOTES
	Author: System Center Automation Team 
	Last Updated: 12/9/2014
#>

workflow MKBT-Get-AzureVMNamesSample
{   
	# By default, errors in PowerShell do not cause workflows to suspend, like exceptions do.
	# This means a runbook can still reach 'completed' state, even if it encounters errors
	# during execution. The below command will cause all errors in the runbook to be thrown as
	# exceptions, therefore causing the runbook to suspend when an error is hit.
	$ErrorActionPreference = "Stop"
	
	# Grab the credential to use to authenticate to Azure. 
	# TODO: Fill in the -Name parameter with the name of the Automation PSCredential asset
	# that has has access to your Azure subscription
	$Cred = Get-AutomationPSCredential -Name 'DefaultCredential'

	# Connect to Azure
	Add-AzureAccount -Credential $Cred | Write-Verbose

	# Select the Azure subscription you want to work against
	# TODO: Fill in the -SubscriptionName parameter with the name of your Azure subscription
	$SubscriptionName = Get-AutomationVariable -Name 'DefaultSubscriptionName'
	Select-AzureSubscription -SubscriptionName $SubscriptionName | Write-Verbose

	# Get all Azure VMs in the subscription, and output each VM's name
	Get-AzureVM | select InstanceName
}
