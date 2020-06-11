#Requires -Version 3.0

Function DownloadZipAndExtract {
Param (
	[string]$RootDir,
	[string]$SavePath,
	[string]$URL
)
	Add-Type -AssemblyName System.IO.Compression.FileSystem

	(New-Object Net.WebClient).DownloadFile($URL, $SavePath)
	[System.IO.Compression.ZipFile]::ExtractToDirectory($SavePath, $RootDir)
}

Function GetLatestRelease {
Param(
	[string]$RootDir,
	[string]$Owner,
	[string]$Repo,
	[switch]$Scrape
)

	$ZipName = "$($Repo)_latest.zip"

	If ($Scrape) {
		# scrape the html (avoids rate limit in cloud)
		$SavePath = Join-Path -Path $RootDir -ChildPath $ZipName
		$html = Invoke-WebRequest -Uri "https://github.com/$Owner/$Repo/releases/latest"
		$url = ($html.ParsedHtml.getElementsByTagName('a') | Where { $_.href -like '*releases/download*' }).href.Replace('about:', 'https://github.com')
		DownloadZipAndExtract $RootDir $SavePath $url
	} else {
		# use github api
		$Json = Invoke-WebRequest -Uri "https://api.github.com/repos/$Owner/$Repo/releases/latest"

		# get the name of the asset (assuming only one and its a zip)
		If ($Json -match '"name"\s*:\s*"([^"]+?\.zip)"') {
			$ZipName = $matches[1]
		}
		$SavePath = Join-Path -Path $RootDir -ChildPath $ZipName

		# get the location of the asset, download and extract
		If ($Json -match '"browser_download_url"\s*:\s*"(http[^"]+?)"') {
			DownloadZipAndExtract $RootDir $SavePath $matches[1]
		}
	}
}
