[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$XamlPath
)

[xml]$Global:xmlWPF = Get-Content -Path $XamlPath

#Add WPF and Windows Forms assemblies
try{
  Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,system.windows.forms
} catch {
  Throw "Failed to load Windows Presentation Framework assemblies."
}

#Create the XAML reader using a new XML node reader
$Global:xamGUI = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $xmlWPF))

#Create hooks to each named object in the XAML
$xmlWPF.SelectNodes("//*[@Name]") | %{
  Set-Variable -Name ($_.Name) -Value $xamGUI.FindName($_.Name) -Scope Global
}