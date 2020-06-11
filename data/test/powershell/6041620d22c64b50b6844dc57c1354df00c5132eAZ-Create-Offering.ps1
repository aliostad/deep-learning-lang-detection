param
(	[ValidateSet("PrivateDeliverySite", "PrivateDeliveryGroup", "SharedDeliveryGroup")]
	$IsolationMode = "PrivateDeliverySite",
    [int]$startCount,
	[int]$numofOfferings
)
$ErrorActionPreference = "Stop"
Import-Module "C:\CitrixCamApi\CitrixCamApi.psm1" -Verbose:0 -ea 0
Import-Module "C:\CitrixCamApi\CitrixCamSql.psm1" -Verbose:0 -ea 0



$catId = Get-SessionMachineCatalogs -NAME "Azure-RDS" | Select -First 1 | Select -Expand Id
$apps = Get-SessionMachineCatalogsDiscoveredApplications -Id $catId | ?{ $_.Origin -ne "Desktop" } 
foreach ($i in $startCount..($startCount+$numofOfferings))
{
	$Suffix = $i.tostring("000")
        $randomindex = get-random -minimum 1 -maximum $apps.count
	$item = New-CreateOfferingItemModel `
	    -Origin                     $apps[$randomindex].Origin `
	    -DiscoveredApplicationId    $apps[$randomindex].Id `
	    -Name                       "SYS2-PD-Offering$suffix"

	$offdata = New-CreateOfferingModel `
	    -IsolationMode              $IsolationMode `
	    -SessionMachineCatalogId    $catId `
	    -Items                      @($item) 

	Write-Host "Creating $IsolationMode offering..." -fore green
	#($offering = Get-Offerings -Name $app.Name)
	#if (!$offering)
	#{
	    New-Offerings $offdata
	#}
}