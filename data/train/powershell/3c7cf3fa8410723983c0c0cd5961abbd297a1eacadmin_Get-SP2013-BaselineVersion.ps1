# PowerShell script to display SharePoint products from the registry.

Param(
  # decide on whether all the sub-components belonging to the product should be shown as well
  [switch]$ShowComponents
)

# location in registry to get info about installed software

$RegLoc = Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall

# Get SharePoint Products and language packs

write-host "Products and Language Packs"
write-host "-------------------------------------------"

$Programs = $RegLoc | 
	where-object { $_.PsPath -like "*\Office*" } | 
	foreach {Get-ItemProperty $_.PsPath} 
$Components = $RegLoc | 
	where-object { $_.PsPath -like "*1000-0000000FF1CE}" } | 
	foreach {Get-ItemProperty $_.PsPath} 

# output either just the info about Products and Language Packs
# or also for sub components

if ($ShowComponents.IsPresent)
{
	$Programs | foreach { 
		$_ | fl  DisplayName, DisplayVersion; 

		$productCodes = $_.ProductCodes;
		$Comp = @() + ($Components | 
			where-object { $_.PSChildName -in $productCodes } | 
			foreach {Get-ItemProperty $_.PsPath});
		$Comp | Sort-Object DisplayName | ft DisplayName, DisplayVersion -Autosize
	}
}
else
{
	$Programs | fl DisplayName, DisplayVersion
}