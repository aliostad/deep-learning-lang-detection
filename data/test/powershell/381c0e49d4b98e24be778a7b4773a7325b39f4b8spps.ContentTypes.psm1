#----------------------------------------------------------------------------- 
# Filename : spps.ContentTypes.ps1 
#----------------------------------------------------------------------------- 
# Author : Ryan Yates
#----------------------------------------------------------------------------- 
# Contains methods to manage Content Types Across Web or Lists.

# General Content Type Functions


function Get-ListContentTypes
{
$Global:listcts = $list.ContentTypes
$spps.Load($listcts)
$spps.ExecuteQuery()

}
function Show-ListContentTypes
{
Get-ListContentTypes
$listcts | Select Name,ID
#Plan in here to sort out foreach about all CT's and get the fields for each CT
}
function Enable-ListContentTypes
{
$list.ContentTypesEnabled = $True
$list.Update()
$spps.ExecuteQuery()
}
function Disable-ListContentTypes
{
$list.ContentTypesEnabled = $False
$list.Update()
$spps.ExecuteQuery()
}
Function Get-ListContentTypeEnabled
{
$list.ContentTypesEnabled
}
function Get-ContentTypes
{
$Global:contenttypes = $web.ContentTypes
$spps.Load($contenttypes)
$spps.ExecuteQuery()

$Global:ctnIDs = $contenttypes | select Name, ID 
Write-host "Variable created" -ForegroundColor Green -NoNewline
Write-host "  CTnIDs  " -ForegroundColor Red -NoNewline
Write-host "which contains the Content Type Names and ID's for the Current Web" -ForegroundColor Green -NoNewline
}
# Create Content Type or Adding Content Type Functions
Function New-ContentType
{
[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true, Position=1)]
		[string] $Name,
		
		[Parameter(Mandatory=$true, Position=2)]
		[string] $Description,
		
		[Parameter(Mandatory=$true, Position=3)]
		[string] $Group,

        [Parameter(Mandatory=$true, Position=3)]
		[string] $ParentContentTypeName

	)

Get-ContentTypes
$ctsName = $ctnids.GetEnumerator() | Where-Object {$_.Name -eq $ParentContentTypeName}
$ParentContentTypeID = $ctsName.id.ToString()

$ParentContentType = $contenttypes.GetById($ParentContentTypeID)
$spps.Load($ParentContentType)
$spps.ExecuteQuery()


$ct = New-Object Microsoft.SharePoint.Client.ContentTypeCreationInformation
$ct.Description = $Description
$ct.Name = $name
$ct.Group = $group
$ct.ParentContentType = $ParentContentType


$contenttypes = $web.ContentTypes
$spps.Load($contenttypes)
$spps.ExecuteQuery()
$ctreturn = $contenttypes.add($ct) 
$spps.load($ctreturn)
$spps.ExecuteQuery()
Write-Host "Content Type "$name" Created"
}
function Add-ContentTypeToList
{

[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true,helpMessage="Please Provide List Name", Position=1)]
		[string]$ListTitle,
	
        [Parameter(Mandatory=$true, helpMessage="Please Provide Content Type Name", Position=2)]
	    [string]$CtName
    )        

Get-List $listTitle

if((Get-ListContentTypeEnabled) -eq $False)
    {
    Enable-ListContentTypes
    Write-host "Content Types Now Enabled on"$ListTitle" List/Library" -ForegroundColor Green
    Get-List $ListTitle
    }
$cts1 = $contenttypes | select Name, ID 
$ctsName = $cts1.GetEnumerator() | Where-Object {$_.Name -eq $ctname}
$ctsid = $ctsName.id.ToString()
$ct = $web.ContentTypes.GetById($CtsID)
$spps.Load($ct)
$list = $web.Lists.GetByTitle($Listtitle)
$cts = $list.ContentTypes
$spps.Load($cts)
$ctReturn = $cts.AddExistingContentType($ct)
$spps.Load($ctReturn)
$spps.ExecuteQuery()
Write-host "Content Type" -ForegroundColor Green -NoNewline
Write-host " $ctname " -ForegroundColor Red -NoNewline
Write-host "Added to $listTitle" -ForegroundColor Green -NoNewline
}
Function New-ContentTypesFromCSV
{
[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true, Position=1)]
		[string] $CSVfile
    )
$csv = Import-Csv $CSVfile    

foreach($row in $csv)
{
New-ContentType -Name $Row.Name -Description $row.Description -Group $Row.Group -ParentContentTypeName $row.ParentContentTypeName
}

}
#    Remove Content Types Functions
Function Remove-ContentTypeFromList
{
[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true,helpMessage="Please Provide List Name", Position=1)]
		[string]$ListTitle,
	
        [Parameter(Mandatory=$true, helpMessage="Please Provide Content Type Name", Position=2)]
	    [string]$CtName
    ) 

Get-List $listTitle
$cts = $list.ContentTypes
$spps.Load($cts)
$spps.ExecuteQuery()
$ctToRemove = $cts | Where-Object {$_.Name -eq $ctname}
$ctToRemove.DeleteObject()
$spps.ExecuteQuery()
Write-host "Content Type"$ctToRemove.Name"Removed From"$list.Title"" -ForegroundColor Green
}
function Remove-ContentTypeFromSite
{
    [CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true, Position=1)]
		[string] $Name
    )
Get-ContentTypes
$ctsName = $ctnIDs.GetEnumerator() | Where-Object {$_.Name -eq $Name}
$ContentTypeID = $ctsName.id.ToString()

$contentypetodelete = $contenttypes.GetById($ContentTypeID)
$spps.Load($contentypetodelete)
$contentypetodelete.deleteObject()
$spps.ExecuteQuery()
Write-Host "Content Type"$name" Removed From Site" -ForegroundColor Green
}
function Remove-ContentTypeFromCSV
{
[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true, Position=1)]
		[string] $CSVfile
    )
$csv = Import-Csv $CSVfile  
foreach($row in $CSV)
{
Remove-ContentTypeFromSite -Name $row.name
}
}