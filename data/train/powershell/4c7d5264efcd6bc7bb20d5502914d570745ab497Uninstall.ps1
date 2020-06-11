# Uninstall.ps1
param($installPath, $toolsPath, $package, $project)

function Remove-AppSettings() {

    $xml = New-Object xml

    # find the Web.config file
    $config = $project.ProjectItems | where {$_.Name -eq "Web.config"}

    if (!$config) {
        return;
    }
    # find its path on the file system
    $localPath = $config.Properties | where {$_.Name -eq "LocalPath"}

    # load Web.config as XML
    $xml.Load($localPath.Value)

    $existing = $xml.SelectSingleNode("configuration/appSettings/add[@key = 'DiagDash.CookieSecret']")
    if (!$existing) {
        # already removed.
        return;
    }

    # select the node
    $node = $xml.SelectSingleNode("configuration/appSettings")
    
	if (!$node)	{
		Write-Warning "Skipping '$($project.Name)', can't find appSettings tag."
        return;
	}
	
	$node.RemoveChild($existing)

	# save the Web.config file
	$xml.Save($localPath.Value)
}

try {
    Remove-AppSettings
} catch {
    Write_Warning $_
}