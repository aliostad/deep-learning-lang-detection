$scriptpath = $MyInvocation.MyCommand.Definition
$scriptRoot = Split-Path -Parent -Path $scriptpath
write-host "Script root: $scriptRoot"

$localInetpub = 'C:\inetpub\wwwroot\skoler'

Function Get-SourcePath($RelativePath)
{
	return Join-Path -Path $script:$scriptRoot -ChildPath $RelativePath
}

Function Get-TargetPath($RelativePath)
{
	return Join-Path -Path $script:$localInetpub -ChildPath $RelativePath
}

Function Copy-ItemByRelativePath($RelativePath)
{
	$fullSource = Get-SourcePath($RelativePath)
	
	$fullTarget = Get-TargetPath($RelativePath)
	if (Test-Path $fullSource -PathType Container) 
	{
			$fullTarget = Split-Path -Parent -Path $fullTarget
	}
			
	write-host "copy-item -Path $fullSource -Destination $fullTarget -Force -Recurse"
	copy-item -Path $fullSource -Destination $fullTarget -Force -Recurse
}

Function Copy-FileByRelativePath($RelativePath)
{
	copy-item -Path Get-SourcePath($RelativePath) -Destination Get-TargetPath($RelativePath) -Force
}

Copy-ItemByRelativePath('index.html') 
#Copy-ItemByRelativePath('web.config') it is different
Copy-ItemByRelativePath('script')
Copy-ItemByRelativePath('style')
Copy-ItemByRelativePath('json')
Copy-ItemByRelativePath('images')