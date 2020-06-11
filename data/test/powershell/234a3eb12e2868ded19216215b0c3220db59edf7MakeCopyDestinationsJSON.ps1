clear

$starttime = [datetime]::Now

. C:\Github\PoSh\spsomlib.ps1
. C:\Scripts\SPSAuthData.ps1 # redefine $sitename, $username, $password 

$cont = ConnectSPS -siteurl $sitename -user $username -password $password

#clear current destinations
function ClearList($listname) {
	$items = RetrieveListItems -web $cont.Web -list $listname
	foreach ($item in $items) { 
		$item.DeleteObject()
	}
	$cont.ExecuteQuery()
}

# Get collection of subsites
$cont.Web.Webs.RetrieveItems().Retrieve()
$cont.ExecuteQuery()


#$baseweb = $cont.Web.Webs | where { $_.ServerRelativeURL -eq "/funds" } | Select -First 1
$baseweb = $cont.Web

$dest = @()
$stop = @("SiteAssets", "SitePages", "Style_x0020_Library")

function ScanLibraries($web) {
#	$destination.Value
	$cont.Load($web)
	$cont.ExecuteQuery()
		
	$sitemenu = @{}
	$sitemenu["title"] = $web.Title
	$sitemenu["absoluteSiteUrl"] = $web.Url
	$sitemenu["libraries"] = @()
	$sitemenu["subsites"] = @()

	LoadObjectItems -cont $web.Context -object ([ref]$web.Lists) |
		where {(-not  $_.Hidden) -and ($_.BaseType -eq "DocumentLibrary")} |
		where {$stop -notcontains $_.EntityTypeName} |
		foreach {
			Write-Host $_.EntityTypeName
			$destlist = $_
			$cont.Load($destlist)
			$cont.Load($destlist.RootFolder)
			$cont.ExecuteQuery()

			$sitemenu["libraries"] += @{"title" = $destlist.Title; "relativeFolderUrl" = $destlist.RootFolder.ServerRelativeUrl }
	}
	LoadObjectItems -cont $cont -object ([ref]$web.Webs) | 
#	select -first 3 | 
	foreach {
		$sitemenu["subsites"] += ,(ScanLibraries -web $_ )
#		ScanLibraries -web $_ -destination ([ref]($sitemenu["subsites"]))
	}
	return $sitemenu
}

#ClearList -listname "Настройки"
#$li = GetListInformation -web $cont.Web -list "Настройки"

$dest = ,(ScanLibraries -web $baseweb)

(ConvertTo-Json -InputObject $dest -Depth 10) -replace "(?sim)^\s+","" | Out-File -FilePath c:\temp\menu.json -Encoding utf8


