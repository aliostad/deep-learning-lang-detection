try
{
	$thisFolderDI = (New-Object system.IO.DirectoryInfo $PWD)

	foreach($thisFolderNuSpecFile in $thisFolderDI.GetFiles("*.nuspec"))
	{
		[Reflection.Assembly]::LoadWithPartialName("System.Xml.Linq")
		$xDocNuspecFile = [System.Xml.Linq.XDocument]::Load($thisFolderNuSpecFile.FullName)

		foreach($item in $xDocNuspecFile.Descendants())
		{
			if($item.Name.LocalName -eq "version")
			{
				$valueString = $item.Value
				$valueArray = $item.Value.Split('.')
				$lastIncrementalValue = [Int]::Parse($valueArray[3])
				
				$item.Value = $valueArray[0].ToString() + "." + $valueArray[1].ToString() + "." + $valueArray[2].ToString() + "." + ($lastIncrementalValue+1).ToString()
			}	
		}
		
		$xDocNuspecFile.Save($thisFolderNuSpecFile.FullName)
	}
}
catch [Exception]
{
	throw $_.Exception
}