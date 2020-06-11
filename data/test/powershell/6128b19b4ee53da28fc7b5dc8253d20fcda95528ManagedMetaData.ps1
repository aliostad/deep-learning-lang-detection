##########################################################################################
#	Name:			SPO_ProvisionTaxonomy
#	Description:	This script deploys a Taxonomy XML file on a Office 365 SP Online tenant
#	Usage:			.\ManagedMetaData.ps1 -User user@sp.com -Password P4ssw0rd -Url https://spo.spo.com -PathToXmlFile c:\temp\taxonomy.xml
##########################################################################################

param([string]$User, [string]$Password, [string]$Url, [string]$PathToXmlFile)

if ($User -eq "") {
	Write-Host "User parameter not provided, exiting" -ForegroundColor Red
	exit 1;
}
if ($Password -eq "") {
	Write-Host "Password parameter not provided, exiting" -ForegroundColor Red
	exit 1;
}
if ($Url -eq "") {
	Write-Host "Url parameter not provided, exiting" -ForegroundColor Red
	exit 1;
}
if ($PathToXmlFile -eq "") {
	Write-Host "PathToXmlFile parameter not provided, exiting" -ForegroundColor Red
	exit 1;
}

$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force

[Reflection.Assembly]::LoadFile("C:\Digital Workspace\Deployment\SiteProvisioning\Lib\Microsoft.SharePoint.Client.dll")
[Reflection.Assembly]::LoadFile("C:\Digital Workspace\Deployment\SiteProvisioning\Lib\Microsoft.SharePoint.Client.Runtime.dll")
[Reflection.Assembly]::LoadFile("C:\Digital Workspace\Deployment\SiteProvisioning\Lib\Microsoft.SharePoint.Client.Publishing.dll")
[Reflection.Assembly]::LoadFile("C:\Digital Workspace\Deployment\SiteProvisioning\Lib\Microsoft.SharePoint.Client.Taxonomy.dll")
[Reflection.Assembly]::LoadFile("C:\Digital Workspace\Deployment\SiteProvisioning\Lib\ContentAndCode.SharePointOnline.dll")

function CreateTerm($termNode, $parentTerm, $termSet, $store, $lcid, $context) {
	$id = [System.Guid]::Parse($termNode.Attribute("Id").Value)
    $name = $termNode.Attribute("Name").Value;

    $IsReused = $termNode.Attribute("IsReused").Value;
    $term = $null;
	write-host "Inserting Term $name" -NoNewLine
	
	if ($parentTerm -ne $null) {
        $term = $parentTerm.CreateTerm($name, $lcid, $id);
    }
    else 
    {
		# condition to reuse a term from different term set
        if($IsReused -eq "True")
        {
            $reusableTerm = $termStore.GetTerm($id)
            $context.Load($reusableTerm)
            $context.ExecuteQuery()
            write-host $reusableTerm.id
            $term = $termSet.ReuseTerm($reusableTerm, $true)
        }
        else
        {
            $term = $termSet.CreateTerm($name, $lcid, $id);
        }
    }
    $description = $termNode.Element("Descriptions").Element("Description").Attribute("Value").Value;
    $term.SetDescription($description, $lcid);
    $term.IsAvailableForTagging = [bool]::Parse($termNode.Attribute("IsAvailableForTagging").Value);
    
    $context.Load($term);

	write-host " created" -ForegroundColor Green	
	
	if ($termNode.Element("Terms") -ne $null) {
        foreach ($childTermNode in $termNode.Element("Terms").Elements("Term")) {
            CreateTerm $childTermNode $term $termSet $store $lcid $context
        }
    }
}


function CreateTermSets($xDoc, $group, $termStore, $context) {
	$termSets = $xDoc.Descendants("TermSet") | Where { $_.Parent.Parent.Attribute("Name").Value -eq $group.Name }
	foreach ($termSetNode in $termSets) {
		$name = $termSetNode.Attribute("Name").Value;
        $id = [System.Guid]::Parse($termSetNode.Attribute("Id").Value);
        $description = $termSetNode.Attribute("Description").Value;
		write-host "Processing TermSet $name ... " -NoNewLine
		try
        {
		    $termSet = $termStore.GetTermSet($id);
            $context.Load($termSet);
            $context.ExecuteQuery();
		}
        catch
        {
            Write-Host $_
        }
		if ($termSet.ServerObjectIsNull) {
			$termSet = $group.CreateTermSet($name, $id, $termStore.DefaultLanguage);
            $termSet.Description = $description;
            $termSet.IsAvailableForTagging = [bool]::Parse($termSetNode.Attribute("IsAvailableForTagging").Value);
            
			write-host "created" -ForegroundColor Green
			
			if ($termSetNode.Element("Terms") -ne $null) {
                foreach ($termNode in $termSetNode.Element("Terms").Elements("Term"))
                {
                    CreateTerm $termNode $null $termSet $termStore $termStore.DefaultLanguage $context
                }
            }							
		}
		else {
			write-host "Already exists" -ForegroundColor Green
		}
	}
}

$context = New-Object Microsoft.SharePoint.Client.ClientContext($url) 
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($user, $securePassword) 
$context.Credentials = $credentials

if (!$context.ServerObjectIsNull.Value) { write-host "Connection to SharePoint Online $Url OK" -ForegroundColor Green }

$taxonomySession = [Microsoft.SharePoint.Client.Taxonomy.TaxonomySession]::GetTaxonomySession($context);
$taxonomySession.UpdateCache();
$context.Load($taxonomySession);
$context.ExecuteQuery();

if ($taxonomySession.TermStores.Count -eq 0) {
    write-host "The Taxonomy Service is offline or missing" -ForegroundColor Red
	exit 1
}

$termStores = $taxonomySession.TermStores
$context.Load($termStores) 
$context.ExecuteQuery()

$termStore = $termStores[0]
$context.Load($termStore) 
write-host "Connected to TermStore: $($termStore.Name) ID: $($termStore.Id)"

[Reflection.Assembly]::LoadWithPartialName("System.Xml.Linq") | Out-Null
$xDoc = [System.Xml.Linq.XDocument]::Load($PathToXmlFile, [System.Xml.Linq.LoadOptions]::None)

foreach ($groupNode in $xDoc.Descendants("Group"))
{
	$name = $groupNode.Attribute("Name").Value;
    $description = $groupNode.Attribute("Description").Value;
    $groupId = $groupNode.Attribute("Id").Value;
    $groupGuid = [System.Guid]::Parse($groupId);	
	write-host "Processing Group: $name ID: $groupId ..." -NoNewLine
	
	$group = $termStore.GetGroup($groupGuid);
    $context.Load($group);
    $context.ExecuteQuery();
	
	if ($group.ServerObjectIsNull -and $name -ne "People") {
        $group = $termStore.CreateGroup($name, $groupGuid);
        $context.Load($group);
        $context.ExecuteQuery();
		write-host "Inserted" -ForegroundColor Green
    }
	else {
		write-host "Already exists" -ForegroundColor Green
	}
	
	CreateTermSets $xDoc $group $termStore $context
}

$termStore.CommitAll();
$context.ExecuteQuery();



