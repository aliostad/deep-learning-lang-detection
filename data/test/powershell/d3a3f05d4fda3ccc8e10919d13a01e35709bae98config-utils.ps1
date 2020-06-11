#inspired from http://www.protosystem.net/post/2009/06/01/Using-Powershell-to-manage-application-configuration.aspx
function Set-ConnectionString {
	param(
		[string]$fileName = $(throw "file is a required parameter."),
		[string]$name,
		[string]$value
	)

	$fileName = Resolve-Path($fileName)

	if($fileName){
		# Load the config file up in memory
		[xml]$configFile = Get-Content $fileName;

		if($configFile.configuration -eq $null){
			Write-Host "configuration element not found in $fileName" -foregroundcolor red -backgroundcolor yellow
			return;
		}
		if($configFile.configuration.connectionStrings -eq $null){
			Write-Host "connectionStrings element not found in $fileName" -foregroundcolor red -backgroundcolor yellow
			return;
		}
		if($configFile.configuration.connectionStrings.add -eq $null){
			Write-Host "no connection strings elements exist in $fileName" -foregroundcolor red -backgroundcolor yellow
			return;
		}

		# Find the connection string to change
		if($configFile.configuration.connectionStrings.SelectSingleNode("add[@name='" + $name + "']")){
			Write-Host "Setting named connection string $name to $value in $fileName"
			$configFile.configuration.connectionStrings.SelectSingleNode("add[@name='" + $name + "']").connectionString = $value
		} else {
			Write-Host "Connection string not found"
			throw New-Object System.Exception ("Connection string not found")
		}

		# Write it out to the new file
		Format-XML $configFile | Out-File -FilePath $fileName -encoding "UTF8"
	} else {
		Write-Host "File $fileName does not exist"
		throw New-Object System.IO.FileNotFoundException
	}
}

function Set-ApplicationSetting {
	param(
		[string]$fileName = $(throw "file is a required parameter."),
		[string]$name,
		[string]$value
	)

	$fileName = Resolve-Path($fileName)

	if($fileName){
		# Load the config file up in memory
		[xml]$configFile = Get-Content $fileName;

		# Find the app settings item to change
		$configFile.configuration.appSettings.selectsinglenode("add[@key='" + $name + "']").value = $value

		Write-Host - setting app settings $name $value in $fileName -ForegroundColor Cyan

		# Write it out to the new file
		Format-XML $configFile | Out-File -FilePath $fileName -encoding "UTF8"
	} else {
		Write-Host "File $fileName does not exist"
		throw New-Object System.IO.FileNotFoundException
	}
}

function Format-XML ([xml]$xml, $indent=2)
{
    $StringWriter = New-Object System.IO.StringWriter
    $XmlWriter = New-Object System.Xml.XmlTextWriter $StringWriter
    $xmlWriter.Formatting = "indented"
    $xmlWriter.Indentation = $Indent
    $xml.WriteContentTo($XmlWriter)
    $XmlWriter.Flush()
    $StringWriter.Flush()
    Write-Output $StringWriter.ToString()
}
