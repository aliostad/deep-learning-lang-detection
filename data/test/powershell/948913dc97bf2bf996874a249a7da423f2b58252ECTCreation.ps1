
Set-ExecutionPolicy Unrestricted 
#set error preference
	$erroractionpreference = "SilentlyContinue"

$HostName=gc env:computername
# Set up the environment
. .\initialize.ps1

# Set SharePoint Environment
 . "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\14\CONFIG\POWERSHELL\Registration\\sharepoint.ps1"
 
cd $currentDirectory
$logfilename=RIInstall.log

[System.Xml.XmlElement]$settings = Get-Settings

if ($settings -eq $null) {
	return $false
}

$WebApp=$settings.WebApp
$RIsite=$settings.Site
$ECTPackage="ExecutionModels.Sandbox.ExternalList.wsp"


$user1=$settings.user1
$user2=$settings.user2
$user3=$settings.user3
$user4=$settings.user4
$CurrentUserName= gc env:username
$ServiceApplication= $settings.ServiceApplication
$ServiceProxy =$settings.ServiceProxy
$targetApp =$settings.TargetApp
$Email =$settings.Email
$AppPool =$settings.AppPool
$normalWeb=$settings.NormalWeb
$machineName = gc env:computername
$ectsubsite="Manufacturing"

WriteHeading "ComputerName:$machineName"
WriteHeading "Enter Password for all users : P2ssw0rd$"

#Manage  Configure managed Users

$userName=$hostname + "\"+ $user1.Name
$check = get-SPManagedAccount|where{$_.UserName -eq $userName}
	if($check -eq $null)
	{
		$cred=Get-Credential -credential $user1.Name
		New-SPManagedAccount -Credential $cred
	}

$userName=$hostname + "\"+ $user2.Name
$check = get-SPManagedAccount|where{$_.UserName -eq $userName}
	if($check -eq $null)
	{
		$cred=Get-Credential -credential $user2.Name
		New-SPManagedAccount -Credential $cred
	}	

$userName=$hostname + "\"+ $user3.Name
$check = get-SPManagedAccount|where{$_.UserName -eq $userName}
	if($check -eq $null)
	{
		$cred=Get-Credential -credential $user3.Name
		New-SPManagedAccount -Credential $cred
	}

	

#configure service account
$error.clear()
	WriteHeading "Update Microsoft SharePoint Foundation Sandboxed Code Service Account..."
	$svc = Get-SPServiceInstance | where {$_.TypeName -eq "Microsoft SharePoint Foundation Sandboxed Code Service"}
	$pi = $svc.Service.ProcessIdentity
	$pi.CurrentIdentityType = "SpecificUser"
	$pi.Username = $user1.Name
	$pi.Update()
	$pi.Deploy()
	if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}
	WriteHeading "Updated Microsoft SharePoint Foundation Sandboxed Code Service Account..."


#CreateAppPool
write-host "pool to be created with name" $AppPool.Name
		$pool=get-SPServiceApplicationPool $AppPool.Name
		$error.clear()
		if ($pool -eq $null)
		{
			$pool=New-SPServiceApplicationPool -Name $AppPool.Name -Account $user3.Name
			if ($error) 
							{
							WriteHeading "entering error in create..."
								writeError $error[0].Exception 
								break;
							}
		write-host "pool created with name" $AppPool.Name
		}

#Create Service Application

	$SSSAName=$ServiceApplication.Name

	WriteHeading "Creating $SSSAName Application"
	$error.clear()
	$serviceapp = new-spsecurestoreserviceapplication -Name $ServiceApplication.Name -partitionmode:$false -sharing:$false  -applicationpool $pool -auditingEnabled:$false
	if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}
			
	WriteHeading "Creating Proxy for $SSSAName Application"
	$proxy = $serviceapp | new-spsecurestoreserviceapplicationproxy -defaultproxygroup:$false -name $ServiceProxy.Name 
	if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}

							

#generate Keys

### Generate and Refresh Key
	WRITEHEADING "Keys generating...."
	Update-SPSecureStoreMasterKey -ServiceApplicationProxy $proxy  -Passphrase P2ssw0rd$
	Start-Sleep -s 10
	Update-SPSecureStoreApplicationServerKey -ServiceApplicationProxy $proxy  -Passphrase P2ssw0rd$
		Start-Sleep -s 10
	if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}


#Claims
		WRITEHEADING "Creating Claims...."

		WRITEHEADING "Creating Secure String ....$machinename\impersonationacct "
		$credentialTypes = "UserName","Password"
		$farmUserSecureString = ConvertTo-SecureString "$machinename\impersonationacct" -AsPlainText -Force
		$farmPasswordSecureString = ConvertTo-SecureString "P2ssw0rd$" -AsPlainText -Force

		 $userClaims = New-SPClaimsPrincipal -identity $user4.Name -identityType WindowsSamAccountName
		 $groupClaims = New-SPClaimsPrincipal -identity $user1.Name -identityType WindowsSamAccountName
 $CurrentUserClaims = New-SPClaimsPrincipal -identity $CurrentUserName -identityType WindowsSamAccountName
		 if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}

### Common variables

	$pw = new-spsecurestoreapplicationfield -Name "Password" -Type WindowsPassword -Masked:$true
	$un = new-spsecurestoreapplicationfield -Name "User Name" -Type WindowsUserName -Masked:$false

	$fields = $un, $pw
	$fieldTypes = "UserName", "Password"

### get context

$context = Get-SPSite | Get-SPServiceContext

#Create Target App
	Writeheading "Creating Target Application.."
	 $targetApp = New-SPSecureStoreTargetApplication -Name $targetApp.Name -FriendlyName $targetApp.Name -ContactEmail "my@spg.com" -ApplicationType group
	
	 if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}

#remove existing Secure Store Service and add our Proxy, to make it default
#add removed proxy
$group = Get-SPServiceApplicationProxyGroup –Default
 #here is where you set a variable to the proxy group.
$new = $proxy


# note that you can also ‘where’ on the objects type if you do not want to hardcode a guid
$old = $group.DefaultProxies | where { $_.DisplayName -eq 'Secure Store Service' }

if ($old -ne $null)
{
	Remove-SPServiceApplicationProxyGroupMember $group $old -Confirm:$false
}

Add-SPServiceApplicationProxyGroupMember $group $new

if ($old -ne $null)
{
	Add-SPServiceApplicationProxyGroupMember $group $old
}



Writeheading "Creating SecureStoreApplication.."
	 $sssapp = New-SPSecureStoreApplication -TargetApplication $targetApp -ServiceContext http://$machineName  -Administrator $userClaims -CredentialsOwnerGroup $groupClaims -Fields $fields
	 if ($error) 
							{
							
								writeError $error[0].Exception 
								break;
			}

 $tar=Get-SPSecureStoreApplication -ServiceContext http://$machinename -Name $targetApp.Name

 Set-SPSecureStoreApplication -identity $tar -CredentialsOwnerGroup $CurrentUserClaims,$groupClaims
	
$credentialValues = $farmUserSecureString ,$farmPasswordSecureString 
$ssoapp =  Get-SPSecureStoreApplication -ServiceContext http://$machineName -Name $targetApp.Name

Update-SPSecureStoreGroupCredentialMapping -Identity $ssoapp -Values $credentialValues
 if ($error) 
							{
						
								writeError $error[0].Exception 
								break;
							}
 
write-host "Created target app"
#


#Import BDC


 $MetadataStore = Get-SPBusinessDataCatalogMetadataObject -BdcObjectType "Catalog" -ServiceContext http://$machineName
 Import-SPBusinessDataCatalogModel -Path "VendorTransactionsBDCModel.bdcm" -Identity $MetadataStore -Force


#BDC permissions

#Vendors Entity (ECT)
$sandboxsvcacct = $machineName+"\"+ $user1.Name
$Impersonatacct = $machineName +"\"+ $user2.Name
$admin = $machineName+ "\Administrator"
$currentusername = $CurrentUserName
writeheading $sandboxsvcacct
$claims = new-spclaimsPrincipal -identity $sandboxsvcacct -identitytype windowssamaccountname
$Impersonationclaims = new-spclaimsPrincipal -identity $Impersonatacct -identitytype windowssamaccountname
$AdminClaims = new-spclaimsPrincipal -identity $admin -identitytype windowssamaccountname
$currentuserclaims = new-spclaimsPrincipal -identity $currentusername -identitytype windowssamaccountname

$scontext="http://$machineName"

 

WriteHeading "Create(Remove if already exists) new site Collection: " + $RIsite.Name
		#check for any exists with that name:
			$newsite ="http://"+ $HostName+":"+$WebApp.Port+"/sites/" + $RIsite.Name
			 if ($error) 
					{
						writeError $error[0].Exception 
						break;
					}
			$site = get-spsite -identity $newsite
			
			if ($site -ne $null)
				{
					WriteHeading "Removing existing $newsite.."
					remove-spsite -identity $newsite -confirm:$false
				}
		WriteHeading "Creating new site Collection:$newsite"

		$error.clear()
			New-SPSite -URL $newsite -OwnerAlias $currentuser.Name -Name $RIsite.Title -Template "STS#1"
	     if ($error) 
			{
				writeError $error[0].Exception 
				break;
			}	
			
			
		

		