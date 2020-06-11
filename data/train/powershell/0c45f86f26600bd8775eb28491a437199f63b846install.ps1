param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath forms.psm1)

	$web = $project.ProjectItems | Where-Object { $_.Name -eq "Web.config" };
	if ($web -ne $null)
	{
		$foundprovider = 0
		[xml]$xml = Get-Content $web.FileNames(1)

		foreach ($key in $xml.SelectNodes("configuration/system.web/membership/providers/add"))
		{
		write-host $key.name
			$foundprovider = 1
		}
		
		if (!$foundprovider)
		{
			$nl= [System.Environment]::NewLine
			$message = "We have not detected a Membership Provider configured." + $nl
			$message = $message + "Please make sure to configure one before running your application." + $nl + $nl
			$caption = "Membership Provider Not Found"

			Show-MessageBox $caption $message
		}
	}
