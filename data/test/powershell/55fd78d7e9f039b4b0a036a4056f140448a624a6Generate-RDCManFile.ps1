<#
.SYNOPSIS 
    Generates a remote desktop connection manager file to manage remote connections to all the VMs in a resource group

.DESCRIPTION
    Generates a remote desktop connection manager file for a resource group and uploads it to the given storage account.
    You can manage can manage remote connections to all VMs in the resource group from this file.
    
    This runbook has a dependency on Connect-Azure runbook. The Connect-Azure runbook must be published for this runbook to run correctly

.PARAMETER OrgIDCredential
    Name of the Azure credential asset that was created in the Automation service.
    This credential asset contains the user id & passowrd for the user who is having access to
    the azure subscription.
            
.PARAMETER ResourceGroupName
    Name of the resource group that contains the VMs to be managed

.PARAMETER StorageAccountName
    Name of the storage account where the generated file should be uploaded
    
.PARAMETER StorageContainerName
    Name of the storage container where the generated file should be uploaded

.PARAMETER AdminUser
    Name of the admin user for the VMs. If the VMs have difference credentials, you can give admin name for any one of the VM. The file
    will be generated with the same credentials for all VMs. You can then later change the credentials after opening the file.

.PARAMETER AdminPwd
    Password for the user account given in AdminUser parameters. If the VMs have difference credentials, you can give credentials for any one of the VM. The file
    will be generated with the same credentials for all VMs. You can then later change the credentials after opening the file.

.PARAMETER Domain
    Domain name for the user account given in AdminUser parameter. If the VMs have difference credentials, you can give credentials for any one of the VM. The file
    will be generated with the same credentials for all VMs. You can then later change the credentials after opening the file.

.EXAMPLE
    Generate-RDCManFile -OrgIDCredential "AutomationUser" -ResourceGroupName "WebAppDevTeam" -StorageAccountName "WebAppDevStorage" 
    -StorageContainerName "managementfiles" -AdminUser "webadminstrator" -AdminPwd "P@ssw0rd" -Domain "appdev"

.NOTES
    AUTHOR: MSGD
#>
workflow Generate-RDCManFile
{
    [OutputType("system.string")]
  	Param 
    (             
        [parameter(Mandatory=$true)]
        [String] 
        $OrgIDCredential = "AutomationUser",
		
        [parameter(Mandatory=$true)] 
        [String] 
        $ResourceGroupName = "TestARMResourceGroup",
        
        [parameter(Mandatory=$true)] 
        [String] 
        $StorageAccountName = "gopitestarmstorage",
        
        [parameter(Mandatory=$true)] 
        [String] 
        $StorageContainerName = "storagearm",
		
        [parameter(Mandatory=$true)] 
        [String]
        $AdminUser = "gopinatm",
		
        [parameter(Mandatory=$false)] 
        [String] 
        $AdminPwd = "P@ssw0rd123",
		
        [parameter(Mandatory=$false)] 
        [String] 
        $Domain = ""
    )

    $ErrorState = 0
    $ErrorMessage = ""     
    try
    {
        # Connect to Azure Subscription using the orgid credential
	    #Connect-Azure -OrgIDCredential $OrgIDCredential 

       	InlineScript
    	{
    		#Create a template XML
            Write-Verbose "Creating xml template for the RDCMan file"
    		$template = '<?xml version="1.0" encoding="utf-8"?>
    		<RDCMan schemaVersion="1">
    			<version>2.2</version>
    			<file>
    				<properties>
    					<name></name>
    					<expanded>True</expanded>
    				</properties>
    				<group>
    					<properties>
    						<name></name>
    						<expanded>True</expanded>
    						<logonCredentials inherit="None">
    							<userName></userName>
    							<domain></domain>
    							<password storeAsClearText="True"></password>
    						</logonCredentials>
    					</properties>
    					<server>
    						<name></name>
    						<displayName></displayName>
    						<connectionSettings inherit="None">
    							<port></port>
    						</connectionSettings>
    					</server>
    				</group>
    			</file>
    		</RDCMan>'
    
    		#Load template into XML object
    		$xml = New-Object xml
    		$xml.LoadXml($template)
    
    		#Set file properties
    		$file = (@($xml.RDCMan.file.properties)[0]).Clone()
    		$file.name = $Using:ResourceGroupName
    		$xml.RDCMan.file.properties | Where-Object { $_.Name -eq "" } | ForEach-Object  { [void]$xml.RDCMan.file.ReplaceChild($file,$_) }
    
    		#Set group properties
    		$group = (@($xml.RDCMan.file.group.properties)[0]).Clone()
    		$group.name = $Using:ResourceGroupName
    		$group.logonCredentials.Username = $Using:AdminUser
    		$group.logonCredentials.Password.InnerText = $Using:AdminPwd
    		$group.logonCredentials.Domain = $Using:Domain
    		$xml.RDCMan.file.group.properties | Where-Object { $_.Name -eq "" } | ForEach-Object  { [void]$xml.RDCMan.file.group.ReplaceChild($group,$_) }
    		$server = (@($xml.RDCMan.file.group.server)[0]).Clone()
            
            Write-Verbose "Xml template for the RDCMan file created"
            
            # Get all VMs in the resource group
            $VMs = Get-AzureVM -ResourceGroupName $Using:ResourceGroupName

            # Add each VM details into the xml template
            $fileName = "RDP.rdp"
    		ForEach ($vm in $VMs) 
    		{ 
				Write-Verbose "Generating the details for VM : $($vm.Name)"	
                Get-AzureRemoteDesktopFile -ResourceGroupName $Using:ResourceGroupName -Name $vm.Name -LocalPath $fileName
                $txt = Get-Content $fileName -First 1
                $arr = $txt.Split(':')
    			$server = $server.clone()	            
    			$server.DisplayName = $vm.Name            
                $server.Name = $arr.Get($arr.Count-2)
                $server.connectionSettings.port = $arr.Get($arr.Count-1)
    			$xml.RDCMan.file.group.AppendChild($server) > $null 
                           
    			#Remove template server
    			$xml.RDCMan.file.group.server | Where-Object { $_.Name -eq "" } | ForEach-Object  { [void]$xml.RDCMan.file.group.RemoveChild($_) }            
    		}

			Write-Verbose "Writing into a local file"
			$env:SystemDrive
			$outFile = "ConnectVM.rdg"
            $xml.OuterXml | Out-File -filepath $outFile -Encoding utf8 -Force
            $key = Get-AzureStorageAccountKey -ResourceGroupName $Using:ResourceGroupName -Name $Using:StorageAccountName
            $context = New-AzureStorageContext -StorageAccountName $Using:StorageAccountName -StorageAccountKey $key.key1
			Write-Verbose "Uploading into the storage account as $outFile"
			Get-Item -Path $outFile | Set-AzureStorageBlobContent -Container $Using:StorageContainerName -Context $context -Force
            Write-Output "Generated RDCMan file and uploaded to storage account as $outFile"
            $xml.OuterXml
    	}
    }
    catch
    {
        $ErrorState = 2        
        Write-Verbose ($Error[0].Exception.tostring())
        Write-Verbose ($ErrorState)
        Throw($Error[0].Exception.tostring())
    }
}