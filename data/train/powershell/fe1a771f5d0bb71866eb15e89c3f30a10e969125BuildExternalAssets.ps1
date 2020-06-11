#Requires -Version 2

function GetExternalAssetsListToCopyToBin
{
	AddExternalAssets Nunit              nunit.framework.*
	AddExternalAssets Nunit-Silverlight  *.dll
	AddExternalAssets RhinoMocks         *.dll,  *.xml
	AddExternalAssets SilverlightToolkit *.dll
	AddExternalAssets SpecFlow           *.dll
}

Task CopyExternalAssets { 
	GetExternalAssetsListToCopyToBin |
		GetCopyTargets |
		Where-Object { $_.SrcIsNewer } |
		Foreach-Object { 
			Write-Verbose "Copying '$($_.SrcFile)' to '$($_.DstPath)'"; 
			Copy-Item $_.SrcFile $_.DstPath -force
		}
}

Task CleanExternalAssets { 
	GetExternalAssetsListToCopyToBin |
		GetCopyTargets |
		Where-Object { $_.DstFile -ne $null } |
		Foreach-Object { 
			Write-Verbose "Deleting '$($_.DstFile)'"
			Remove-Item $_.DstFile -force 
		}
}

function GetCopyTargets
{
	param
	(
		[Parameter(ValueFromPipeline = $true)]
		$Src
	)

	process {
		$DstPath = "$BinDir\$($Src.Name)"
		$DstFile = if(Test-Path $DstPath) { Get-ChildItem $DstPath } 
				   else { $null }
	
		@{
			SrcFile = $Src;
			DstPath = $DstPath;
			DstFile = $DstFile;
			SrcIsNewer = ($DstFile -eq $Null) -or 
					   ($SrcFile.LastWriteTime -gt $DstFile.LastWriteTime)
		}	
	}
}

function AddExternalAssets([string] $Asset, [string[]] $Include)
{
	Get-ChildItem $ExternalAssetsDir\$Asset\* -Include $Include
}