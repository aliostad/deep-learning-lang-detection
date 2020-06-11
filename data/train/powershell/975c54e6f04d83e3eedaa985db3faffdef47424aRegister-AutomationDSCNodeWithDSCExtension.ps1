<#

    .SYNOPSIS
       Register Azure v2 VM to Azure Automation DSC as Node
       via DSC VM Extension.

    .DESCRIPTION
       Register Azure v2 VM to Azure Automation DSC as Node
       via DSC VM Extension. Azure v2 VM is restarted
       during the process to install WMF 5.0. Azure RM
       cmdlets are used.

    .PARAMETER  VMName
	   Mandatory parameter. This parameter is used for 
       finding the Azure v2 VM.

    .PARAMETER  VMResourceGroup
	   Mandatory parameter. This parameter is used for 
       finding in which Azure Resource Group is the VM.

    .PARAMETER  AutomationAccountName
	   Not mandatory parameter. This parameter is used to 
       add the Azure VM to specific Azure Automation
       Account. If this parameter is not provided
       value will be taken from variable in Automation
       Asset Store.

    .PARAMETER  AutomationAccountResourceGroup
	   Not mandatory parameter. This parameter is used for
       finding in which Resoruce Group the Automation
       Account is located. If this parameter is not provided
       value will be taken from variable in Automation
       Asset Store.
       
    .PARAMETER  AzureSubscriptionID
	   Not mandatory parameter. This parameter is used for
       designating the Azure subscription under which will
       be operated. If this parameter is not specified
       value will be taken from Variable in Automation Asset
       Store.
       
    .PARAMETER  WebhookData
	   Not mandatory parameter. This parameter is used
       if webhook is enabled for the runbook. In that case
       all other parameters are passed through WebhookData
       parameter. To make the runbook more secure there is
       authorization value 'Contoso' that needs to be provided.
       In case that vale is not provided the runbook will fail.
    
    .OUTPUTS
        Outputs result message for the workflow. THIS IS ONLY A TEST, BALH BALH BALH BALH BLHA
#>
workflow Register-AutomationDSCNodeWithDSCExtension
{
    param (
        [Parameter(Mandatory=$true)]
        [String] 
        $VMName,

        [Parameter(Mandatory=$true)]
        [String] 
        $VMResourceGroup,

        [Parameter(Mandatory=$false)]
        [String] 
        $AutomationAccountName,

        [Parameter(Mandatory=$false)]
        [String] 
        $AutomationAccountResourceGroup,

        [Parameter(Mandatory=$false)]
        [String] 
        $AzureSubscriptionID,

        [Parameter(Mandatory=$false)]
        [object] 
        $WebhookData
                   
    )

    # Set Error Preference	
	$ErrorActionPreference = "Stop"

    # When webhook is used
    if ($WebhookData -ne $null) 
    {
        # Collect properties of WebhookData
        $WebhookName    =   $WebhookData.WebhookName
        $WebhookHeaders =   $WebhookData.RequestHeader
        $WebhookBody    =   $WebhookData.RequestBody

        $AuthorizationValue = $WebhookHeaders.AuthorizationValue
        If ($AuthorizationValue -eq 'Contoso')
        {
            # Convert webhook body
            $WebhookBodyObj = ConvertFrom-Json `
                                -InputObject $WebhookBody `
                                -ErrorAction Stop
        
            # Get webhook input data
            $VMName                         = $WebhookBodyObj.VMName
            $VMResourceGroup                = $WebhookBodyObj.VMResourceGroup
            $AutomationAccountName          = $WebhookBodyObj.AutomationAccountName
            $AutomationAccountResourceGroup = $WebhookBodyObj.AutomationAccountResourceGroup
            $AzureSubscriptionID            = $WebhookBodyObj.AzureSubscriptionID
        }
        Else
        {
            $ErrorMessage = 'Webhook was executed without authorization.'
            Write-Error -Message $ErrorMessage `
                        -ErrorAction Stop
        }
        
    }

    # Check if AzureSubscriptionID exists
    If ($AzureSubscriptionID -eq $null)
    {
        $AzureSubscriptionID = Get-AutomationVariable `
                               -Name 'AzureSubscriptionID'
    }

    # Check if AutomationAccountName exists
    If ($AutomationAccountName -eq $null)
    {
        $AutomationAccountName = Get-AutomationVariable `
                                 -Name 'AutomationAccountName'
    }

    # Check if AutomationAccountResourceGroup exists
    If ($AutomationAccountResourceGroup -eq $null)
    {
        $AutomationAccountResourceGroup = Get-AutomationVariable `
                                          -Name 'AutomationAccountResourceGroup'
    }
    
    # Get Credentials to Azure Subscription
    $AzureCreds = Get-AutomationPSCredential `
                  -Name 'AzureCredentials'
    inlinescript
    {
        Try
        {
            # Connect to Azure
            $AzureAccount = Add-AzureRmAccount `
                            -Credential $Using:AzureCreds `
                            -SubscriptionId $Using:AzureSubscriptionID `
                            -ErrorAction Stop
            Write-Output -InputObject 'Successfuly connected to Azure.'
        }
        Catch
        {
            $ErrorMessage = 'Login to Azure failed.'
            $ErrorMessage += " `n"
            $ErrorMessage += 'Error: '
            $ErrorMessage += $_
            Write-Error -Message $ErrorMessage `
                        -ErrorAction Stop
        }





        # Node Configuration Name
        $NodeConfigName = $Using:VMName

        Try
        {
            # get Azure Automation DSC registration info
            $Account = Get-AzureRmAutomationAccount `
                       -ResourceGroupName $Using:AutomationAccountResourceGroup `
                       -Name $Using:AutomationAccountName `
                       -ErrorAction Stop
            $RegistrationInfo = $Account | `
                                Get-AzureRmAutomationRegistrationInfo `
                                -ErrorAction Stop
            Write-Output -InputObject 'Automation Account information was successfully retrieved.'
    
        }
        Catch
        {
            $ErrorMessage = 'Failed to get Automation Account information.'
            $ErrorMessage += " `n"
            $ErrorMessage += 'Error: '
            $ErrorMessage += $_
            Write-Error -Message $ErrorMessage `
                        -ErrorAction Stop
    
        }
    
        Try
        {
            # use the DSC extension to onboard the VM for management with Azure Automation DSC
            $VM = Get-AzureRmVM `
                  -Name $Using:VMName `
                  -ResourceGroupName $Using:VMResourceGroup `
                  -ErrorAction Stop
            Write-Output -InputObject 'Successfully found Azure VM to apply DSC Extension.'
    
        }
        Catch
        {
            $ErrorMessage = 'Failed to find Azure v2 VM.'
            $ErrorMessage += " `n"
            $ErrorMessage += 'Error: '
            $ErrorMessage += $_
            Write-Error -Message $ErrorMessage `
                        -ErrorAction Stop
        }
    

        $PublicConfiguration = @{
          SasToken = ""
          ModulesUrl = "https://eus2oaasibizamarketprod1.blob.core.windows.net/automationdscpreview/RegistrationMetaConfigV2.zip"
          ConfigurationFunction = "RegistrationMetaConfigV2.ps1\RegistrationMetaConfigV2"

        # update these DSC agent Local Configuration Manager defaults if they do not match your use case.
        Properties = @{
           RegistrationKey = @{
             UserName = 'notused'
             Password = 'PrivateSettingsRef:RegistrationKey'
        }
          RegistrationUrl = $RegistrationInfo.Endpoint
          NodeConfigurationName = $NodeConfigName
          ConfigurationMode = "ApplyAndMonitor"
          ConfigurationModeFrequencyMins = 15
          RefreshFrequencyMins = 30
          RebootNodeIfNeeded = $True
          ActionAfterReboot = "ContinueConfiguration"
          AllowModuleOverwrite = $False
          }
        }

        $PrivateConfiguration =  @{
          Items = @{
             RegistrationKey = $RegistrationInfo.PrimaryKey
          }
        }


        Try
        {
            $VmExtension = Set-AzureRmVMExtension `
                           -VMName $Using:VMName `
                           -ResourceGroupName $Using:VMResourceGroup `
                           -Publisher Microsoft.Powershell `
                           -Name DSC `
                           -ExtensionType DSC `
                           -TypeHandlerVersion 2.7 `
                           -Settings $PublicConfiguration `
                           -ProtectedSettings $PrivateConfiguration `
                           -Location $VM.Location
    
            If ($VmExtension.Status -eq 'Succeeded')
            {
                Write-Output -InputObject 'Successfully installed and configured DSC Extension.'
                Write-Output -InputObject 'Check Automation account to see if node is connected successfully to Automation DSC.'
            }
            Else
            {
                $ErrorMessage = 'DSC Extension is with status '
                $ErrorMessage += $VmExtension.Status
                $ErrorMessage += '.'
                $ErrorMessage += " `n"
                $ErrorMessage += 'DSC Extension Error Details: '
                $ErrorMessage += $VmExtension.Error
                Write-Error -Message $ErrorMessage `
                            -ErrorAction Stop
            }
    
        }
        Catch
        {
            $ErrorMessage = 'Failed to install DSC Extension.'
            $ErrorMessage += " `n"
            $ErrorMessage += 'Error: '
            $ErrorMessage += $_
            Write-Error -Message $ErrorMessage `
                        -ErrorAction Stop
    
        }
    }
    
    

}