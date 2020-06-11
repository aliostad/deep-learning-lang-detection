#
# This script allows the Term store to be created from an XML file created via Export.Taxonomy.ps1
# Author: Shailen Sukul
# http://shailensukul.com
# INPUT FILE: Taxonomy.xml
# INPUT FILE: Input.Destination.xml

# these aren't required for the script to run, but help to develop
Add-Type -Path "Microsoft.SharePoint.Client.dll"
Add-Type -Path "Microsoft.SharePoint.Client.Runtime.dll"
Add-Type -Path "Microsoft.SharePoint.Client.Taxonomy.dll"

function SetTermsRecursive ([Microsoft.SharePoint.Taxonomy.TermSetItem] $termsetitem, $parentnode)
{
	 $parentnode.Term |
	 ForEach-Object {
	  ## create the term
	  $newterm = $termsetitem.CreateTerm($_.Name, 1033)
	  Write-Host -ForegroundColor Cyan "Added term $_.Name"
	  SetTermsRecursive($termsetitem, $_)
 }

}
$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
[string] $xmlFilePath = "$($executingScriptDirectory)\Taxonomy.xml"
## Change locale here
$lcid = "1033"

cls
if (Test-Path $xmlFilePath) {
	Write-Host Found Taxonomy.xml..... processing -ForegroundColor Green
	
	[xml]$taxFile = Get-Content $xmlFilePath
	[xml]$inputFile = Get-Content Input.Destination.xml 

	$url = $inputFile.SharePointSettings.Url;
	$admin = $inputFile.SharePointSettings.UserID;
	$pwd = $inputFile.SharePointSettings.Password
	$securePwd = ConvertTo-SecureString $pwd -AsPlainText -Force

	#Bind to MMS
	$Context = New-Object Microsoft.SharePoint.Client.ClientContext($url)
	$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($admin,$securePwd)
	$Context.Credentials = $Creds
	$MMS = [Microsoft.SharePoint.Client.Taxonomy.TaxonomySession]::GetTaxonomySession($Context)
	$Context.Load($MMS)
	$Context.ExecuteQuery()

	#Retrieve Term Stores
	$TermStores = $MMS.TermStores
	$Context.Load($TermStores)
	$Context.ExecuteQuery()

	#Bind to Term Store
	$TermStore = $TermStores[0]
	$Context.Load($TermStore)
	$Context.ExecuteQuery()

	Foreach ($Group in $taxFile.TermStore.Group)
	{
		#Create Groups
		Write-Host Creating group $Group.Name -ForegroundColor Green
		$NewGroup = $TermStore.CreateGroup($Group.Name, $Group.Id)
		$Context.Load($NewGroup)
		$Context.ExecuteQuery()
		Foreach ($TermSet in $Group.TermSet)
		{
			#Create Term Sets
			Write-Host Creating TermSet $Term.Name  -ForegroundColor Cyan
			$NewTermSet = $NewGroup.CreateTermSet($TermSet.Name, $TermSet.Id, $TermSet.Lcid)
			$Context.Load($NewTermSet)
			$Context.ExecuteQuery()
			Foreach ($Term in $TermSet.Term)
			{
				#Create Terms
				Write-Host Creating Term $Term.Name  -ForegroundColor Yellow
				$NewTerm = $NewTermSet.CreateTerm($Term.Name, $Term.Lcid, $Term.Id)
				$Context.Load($NewTerm)
				$Context.ExecuteQuery()
			}
		}
	}
} else {
	Write-Host Please provide an input file called Taxonomy.xml -ForegroundColor Red
}