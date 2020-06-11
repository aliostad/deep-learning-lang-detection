[Reflection.Assembly]::LoadWithPartialName("System.Xml.Linq") | Out-Null
function Sync-Version {
	$version = Get-Content .\CommonAssemblyInfo.cs |% { if ($_ -match '.*AssemblyInformationalVersion\("(.+)"\).*') { $Matches[1] } }
	$files = Get-ChildItem -Recurse VirtualPath*.nuspec | select $_.Name
	$files | Foreach-Object { Update-Version $version $_ }
}

function Update-Version {
	param($version, $file)

	Write-Host "Update version of $file to $version"
	
	$doc = [System.Xml.Linq.XDocument]::Load($file)
	$ns = $doc.Root.Attribute("xmlns").Value

	$doc.Descendants("{$ns}version") | Foreach-Object { $_.Value = $version }

	$doc.Descendants("{$ns}dependency") `
		| Foreach-Object {
			if ( $_.Attribute("id").Value -eq "VirtualPath" ) { 
				$_.Attribute("version").Value = $version
			}
		}

	$doc.Save($file)
}

Sync-Version