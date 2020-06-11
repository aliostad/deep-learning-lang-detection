###########################################################
# .FILE		: LOADDIALOG.PS1
# .AUTHOR  	: A. Cassidy (nicked from internet)
# .DATE    	: 2015-05-21
# .EDIT    	: 
# .FILE_ID	: PSCBM003
# .COMMENT 	: Loads XAML file for CBM GUI
# .INPUT		: 
# .OUTPUT	:
#			  	
#           
# .VERSION : 0.1
###########################################################
###########################################################
# .CHANGELOG
# 
#
#
###########################################################
# .INSTRUCTIONS FOR USE
#
#
#
###########################################################
# .CONTENTS
# 
#
#
###########################################################

[CmdletBinding()]

	Param(
	[Parameter(Mandatory=$True,Position=1)]
	[System.String]
	$XamlPath
	)

# Read the xaml style file
[xml]$Global:xmlWPF = Get-Content -Path $XamlPath

 

# Add WPF and Windows Forms assemblies
Try {

	Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,system.windows.forms

} Catch {

	Throw "Failed to load Windows Presentation Framework assemblies."

}

 

# Create the XAML reader using a new XML node reader
$Global:xamGUI = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $xmlWPF))

 

#Create hooks to each named object in the XAML
$xmlWPF.SelectNodes("//*[@Name]") | %{

	Set-Variable -Name ($_.Name) -Value $xamGUI.FindName($_.Name) -Scope Global

 }
