param(
  [String] $appPath = $(throw "Application exe file path is mandatory"),
  [String] $sectionName = $(throw "Configuration section is mandatory"),
  [String] $dataProtectionProvider = "DataProtectionConfigurationProvider"
)
 
#The System.Configuration assembly must be loaded
$configurationAssembly = "System.Configuration, Version=2.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a"
[void] [Reflection.Assembly]::Load($configurationAssembly)
 
Write-Host "Encrypting configuration section..."
 
$configuration = [System.Configuration.ConfigurationManager]::OpenExeConfiguration($appPath)
$section = $configuration.GetSection($sectionName)
 
if (-not $section.SectionInformation.IsProtected)
{
  $section.SectionInformation.ProtectSection($dataProtectionProvider);
  $section.SectionInformation.ForceSave = [System.Boolean]::True;
  $configuration.Save([System.Configuration.ConfigurationSaveMode]::Modified);
}
 
Write-Host "Succeeded!"