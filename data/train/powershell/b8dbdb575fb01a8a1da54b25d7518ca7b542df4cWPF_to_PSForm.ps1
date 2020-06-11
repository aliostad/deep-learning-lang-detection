#Changes WPF input into PS usable form
cls
#Put Window Here
$inputXML = @"
  #### <Window x:Class="MainWindow"                     ####
  #### Some Windows Form Code Here Replace all of this  ####
  #### </Window>                                        ####
"@       
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'

Write-Host $inputXML

#
#Need Below to Read Form
#
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML

#Read XAML
$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
	try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
	catch{Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."}
 
# Load XAML Objects In PowerShell
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}

#Debug Information 
	Function Get-FormVariables{
	if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
	write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
	get-variable WPF*
	}
Get-FormVariables

