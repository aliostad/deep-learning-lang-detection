param (
	[string]$Deploy,
	[switch]$SkipBackup,
	[string]$Settings = "settings.xml"	
)
$success = $false

function writeError($message) {
	Write-Host $message -Foreground Red
	break;
}
function writeSuccess($message) {
	Write-Host $message -Foreground Green
}
function writeMessage($message) {
	Write-Host $message -Foreground White
}

function deploy($site) {
try {
	writeMessage ("Removing existing files at {0}." -f $site.path)
	rm -force -recurse $site.path
	writeMessage ("Copying new release to {0}." -f $site.path)
	cp -recurse -exclude thumbs.db  $releaseDirectory $site.path
	$originalCount = (gci -recurse $releaseDirectory).count
	$siteCount = (gci -recurse $site.path).count
	
	if ($originalCount -ne $siteCount)
	{
		writeError ( "Deployment failed; attempted to copy {0} file(s) and only copied {1} file(s)." -f $originalCount, $siteCount)
	}
	else {
		writeSuccess ("Deployment succeeded.")
	}
	}
	
	catch {
		writeError ("Could not deploy. EXCEPTION: {1}" -f $_)
	}
}

function backup($site) {
	try {
	$currentDate = (Get-Date).ToString("yyyy-MM-dd-HHmmss");
	$backupPath = $site.path + "-" + $currentDate;
	$originalCount = (gci -recurse $site.path).count
	writeMessage ("Making backup of {0} file(s) at {1} to {2}." -f $originalCount, $site.path, $backupPath)
	cp -recurse -exclude thumbs.db $site.path $backupPath
	$backupCount = (gci -recurse $backupPath).count	
	if ($originalCount -ne $backupCount)
	{
		writeError ("Backup failed; attempted to copy {0} file(s) and only copied {1} file(s)." -f $originalCount, $backupCount)
	}
	else {
		writeSuccess ("Backup succeeded.")
	}
	}
	catch
	{
		writeError ("Could not complete backup. EXCEPTION: {1}" -f $_)
	}
}

writeMessage ("Reading settings file at {0}." -f $settings)
if ((test-path $settings) -eq $false) {
	writeError ("Could not find settings file at {0}." -f $settings)
}
$xml = new-object System.Xml.XmlDocument
try {
	$xml.LoadXml( (gc $settings) )
	if ($xml.site.count -gt -0) {
			writeError ("Could not read settings file at {0} or no <site> sections found." -f $settings)
	}
}
catch {
	writeError ("Could not parse {0}. EXCEPTION: {1}" -f $settings, $_)
}
$releaseDirectory = $xml.settings.common.release;
writeMessage ("Testing release path at {0}." -f $releaseDirectory)
if ((test-path $releaseDirectory) -eq $false -and $releaseDirectory -ne "") {
	writeError ("Could not find release path at {0}." -f $releaseDirectory)
}

foreach ($site in $xml.settings.site) {
	if ($site.name.ToLower() -eq $deploy.ToLower()) {
		writeMessage ("Found deployment plan for {0} -> {1}." -f $site.name, $site.path)
		if ($SkipBackup -eq $false) {
			backup($site)
		}
		deploy($site)
		$success = $true
		break;
	}
}
if ($success) {
		writeSuccess "SUCCESS!"
}		
else {
		writeError "FAILURE: Could not find a site matching '$deploy'"
}
