$sourceWeb = Get-SPWeb http://intranet
$xmlFilePath = "C:\Temp\Script-SiteContentTypes.xml"

#Create Export File
New-Item $xmlFilePath -type file -force

#Export Content Types to XML file
Add-Content $xmlFilePath "<?xml version=`"1.0`" encoding=`"utf-8`"?>"
$sourceWeb.ContentTypes | ForEach-Object {
		if ($_.Group -eq "Sukul.Demo") {

			Add-Content $xmlFilePath "<ContentType ID='$($_.Id)' Name='$($_.Name)' Group='$($_.Group)' Description='$($_.Description)' Overwrite='TRUE' Inherits='FALSE'>"
			Add-Content $xmlFilePath "`t<FieldRefs>"
			ForEach ($field in $_.Fields)
			{
					$output = "`t`t<FieldRef ID='{$($field.Id)}' Name='$($field.InternalName)' Required='$($field.Required.ToString().ToUpper())' Hidden='$($field.Hidden.ToString().ToUpper())'"
					if ($field.ShowInNewForm -ne $null) {
						$output = $output + " ShowInNewForm='$($field.ShowInNewForm.ToString().ToUpper())'"
					 } 
					 if ($field.ShowInEditForm -ne $null) {
						$output = $output + " ShowInEditForm='$($field.ShowInEditForm.ToString().ToUpper())'"
					 } 
					 $output = $output + " />"
					Add-Content $xmlFilePath  $output
				}

				Add-Content $xmlFilePath "`t</FieldRefs>"
				Add-Content $xmlFilePath "</ContentType>"
				#if ($_.Group -eq "Sukul.Demo") {
				# Add-Content $xmlFilePath $_.SchemaXml
				# }
	 }
}

$sourceWeb.Dispose()