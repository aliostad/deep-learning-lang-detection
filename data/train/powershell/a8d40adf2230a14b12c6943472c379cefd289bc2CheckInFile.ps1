
$script:ErrorActionPreference = "Stop"
$computerName = .\Get-ConfigurationPropertyValue.ps1 SutComputerName
$requestUrl= .\Get-ConfigurationPropertyValue.ps1 TargetSiteCollectionUrl

$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$credential = new-object Management.Automation.PSCredential(($domain+"\"+$userName),$securePassword)

# sent scripts to server.
$ret = invoke-command -computer $computerName -Credential $credential -scriptblock{
  param(
      [string]$siteUrl,
      [string]$fileUrl,
      [string]$checkInCommnets
      )
  
  # load assemblies.
  [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") | out-null
  
  try
  {
	  $spSite = new-object Microsoft.SharePoint.SPSite($siteUrl)
	  $spWeb = $spSite.RootWeb
	  $spFile = $spWeb.GetFile($fileUrl)
	  $spFile.CheckIn($checkInCommnets);
	  $spWeb.Close();
	  $spSite.Close();
  }
  finally
  {
	$spSite.Dispose()
  }
} -argumentlist $requestUrl,$fileUrl, $checkInComments
  
if(!$?)
{
	return $false
}

return $true