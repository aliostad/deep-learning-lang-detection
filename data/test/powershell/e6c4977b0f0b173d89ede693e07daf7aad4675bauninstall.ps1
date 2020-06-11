param($installPath, $toolsPath, $package, $project)

	# Revert the issuer registry
	$web = $project.ProjectItems | Where-Object { $_.Name -eq "Web.config" };
	if ($web -ne $null)
	{
		$xml = new-object System.Xml.XmlDocument
		$xml.Load($web.FileNames(0))
		$registry = $xml.SelectSingleNode("/configuration/microsoft.identityModel/service/issuerNameRegistry")

		if ($registry -ne $null)
		{
			$registry.type = "Microsoft.IdentityModel.Tokens.ConfigurationBasedIssuerNameRegistry, Microsoft.IdentityModel, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
			$xml.Save($web.FileNames(0))
		}
	}