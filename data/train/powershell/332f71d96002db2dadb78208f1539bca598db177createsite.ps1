
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







$error.clear()
$WebApp=$settings.WebApp

#Check  Normal web and Central Admin are running
	$siteURL="http://"+$HostName+":" + $WebApp.Port
	if ($error) 
			{
	          writeError $error[0].Exception 
			  break;
			}
	WriteHeading "Connecting to $siteURL"
	$web=Get-SPWeb -site $siteURL
	if ($web -eq $null)
		{
			WriteError "Unable to Connect $siteURL. Please check settings.xml for Web Application Port information."
			break;
		}

. "$ExeModelDir\Shared Code\Setup\ps\Commoncreatesite.ps1"



$error.clear()
# call test data script to populate
$settings.Sites.Site | ForEach-Object {
		$RISite=$_
		# call to populate test data
		. "$ExeModelDir\Shared Code\Setup\ps\testdata.ps1"

		$newsite="http://"+$HostName+":" + $WebApp.Port+"/sites/"+ $RISite.Name
		if ($error) 
				{
				  writeError $error[0].Exception 
				  break;
				}

		# check if Sandbox Webpart need to add webpart need to add
			if ($RISite.SandWebPart -eq "True")
			{
			    #add webpart to default page
				
				WriteHeading  "Adding WebPart to default page."
				$error.clear()
				$WebScope=Start-SPAssignment
					  $site=Get-SPSite($newsite)
					  $web=$WebScope|Get-SPWeb($newsite)
					  if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}
					  $file=$web.GetFile("default.aspx")
				  #get the webpart manager

					  $manager=$file.GetLimitedWebPartManager([System.Web.UI.WebControls.WebParts.PersonalizationScope]::Shared)

					   $webpart = new-object Microsoft.SharePoint.WebPartPages.SPUserCodeWebPart

					   $webpart.AssemblyFullName="ExecutionModels.Sandboxed, Version=1.0.0.0, Culture=neutral, PublicKeyToken=9ae6d3a07c1fb8de"
					   $webpart.SolutionId="eef6447a-4f05-47fe-9e8a-7c2886671008"
					   $webpart.TypeFullName="ExecutionModels.Sandboxed.AggregateView.AggregateView"
					   $webpart.Title="P&P SPG V3 - Execution Models Sandbox Aggregate View"
					   $manager.AddWebPart($webpart,"left",0)
					   if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}

				Stop-SPAssignment $WebScope
				

			}

			if ($RISite.ProxyWebPart -eq "True")
			{
					#add FullTrustProxy Registration package to farm solutions
					WriteHeading "Step : Add Package($FullTrustPackage) to solutions."
						$checkSolution=Get-SPSolution -Identity $FullTrustPackage
						if ($checkSolution -ne $null)
						{
							if($checkSolution.deployed -eq $True)
							{
								WriteHeading "Uninstall $FullTrustPackage"
								Uninstall-SPSolution -Identity $FullTrustPackage -Confirm:$false -Local:$true
								if ($error) 
								{
									writeError $error[0].Exception 
									break;
								}
							}
							
							WriteHeading "Remove $FullTrustPackage from form"	
							REmove-SPSolution -Identity $FullTrustPackage -force:$true -Confirm:$false
								if ($error) 
								{
									writeError $error[0].Exception 
									break;
								}
						}
						$error.clear()
                        $packagePathName="$HybridRIsolPath" + "VendorSystemProxy\bin\Debug\$FullTrustPackage"
						WriteHeading "Adding Solution " + $packagePathName
						ADD-SPSolution -LiteralPath $packagePathName
						if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}
						WriteHeading "Install Solution : $FullTrustPackage"
						
						Install-SPsolution -Identity $FullTrustPackage -GACDeployment:$true -Local:$true
						if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}
						#add solution to solution gallary
						WriteHeading "Step : Add Package($HybridRIPackage) to solution Gallary."

						#check of if any existing with that name
						$error.clear()

						$exitpackage= get-SPUserSolution -Identity $HybridRIPackage -site $newsite

						$packagefullpath= $HybridRIsolPath +"\ExecutionModels.Sandboxed.Proxy\bin\Debug\"+$HybridRIPackage
						
						if ($exitpackage -ne $null)
						{	
							WriteHeading "Removing Existing Package."
							Remove-SPUserSolution -Identity $HybridRIPackage -site $newsite -Confirm:$false
							if ($error) 
								{
									writeError $error[0].Exception 
									break;
								}
						}

						$error.clear()
						WriteHeading "Adding Package from $packagefullpath to $newsite"
						Add-SPUserSolution -LiteralPath $packagefullpath  -Site $newsite  >>$logfilename
						if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}

					#install Hybrid RI Package
					$error.clear()
						
						WriteHeading "Step : Activate :$HybridRIPackage"

					 	Install-SPUserSolution -Identity $HybridRIPackage -Site $newsite

						if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}


					#add webpart to default page
					WriteHeading  "Adding WebParts to default page."
					$error.clear()
					$WebScope=Start-SPAssignment
						  $site=Get-SPSite($newsite)
						  $web=$WebScope|Get-SPWeb($newsite)
						  if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}
						  $file=$web.GetFile("default.aspx")
					  #get the webpart manager
					  $error.clear()
						  $manager=$file.GetLimitedWebPartManager([System.Web.UI.WebControls.WebParts.PersonalizationScope]::Shared)
					  #adding aggregate view webpart
					 WriteHeading  "Adding aggregate view webpart"
						   $webpart = new-object Microsoft.SharePoint.WebPartPages.SPUserCodeWebPart
						   
						   $webpart.AssemblyFullName="ExecutionModels.Sandboxed.Proxy, Version=1.0.0.0, Culture=neutral, PublicKeyToken=f1af6200ac9749a6"
						   $webpart.SolutionId="d822a399-f4d6-4c8b-8ace-c745422a230c"
						   $webpart.TypeFullName="ExecutionModels.Sandboxed.Proxy.AggregateView.AggregateView"
						   $webpart.Title="Execution Models Proxy Aggregate View"
						   $manager.AddWebPart($webpart,"left",1)
						   if ($error) 
							{
						       writeError $error[0].Exception 
						       break;
					        }
					  #adding Client detail webpart to home page

					Stop-SPAssignment $WebScope



			}
		}


#Manage  Configure managed Users

	$user1="$HostName\SandboxSvcAcct"
	$check = get-SPManagedAccount|where{$_.UserName -eq $user1}
	if($check -eq $null)
	{
		$cred=Get-Credential -credential $user1
		New-SPManagedAccount -Credential $cred
	}


#configure service account
$error.clear()
	WriteHeading "Updating Microsoft SharePoint Foundation Sandboxed Code Service Account..."
	$svc = Get-SPServiceInstance | where {$_.TypeName -eq "Microsoft SharePoint Foundation Sandboxed Code Service"}
	$pi = $svc.Service.ProcessIdentity
	$pi.CurrentIdentityType = "SpecificUser"
	$pi.Username = $user1
	$pi.Update()
	$pi.Deploy()
	if ($error) 
							{
								writeError $error[0].Exception 
								break;
							}
	WriteHeading "Updated Microsoft SharePoint Foundation Sandboxed Code Service Account..."
cd $currentDirectory

