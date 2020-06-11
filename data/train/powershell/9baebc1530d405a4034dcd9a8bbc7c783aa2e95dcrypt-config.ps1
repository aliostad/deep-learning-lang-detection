# Crypt-Config -- Decrypt-Config
# By Joannes Vermorel, 2007
# 
# Utility to secure configuration files (based on DpapiProtectedConfigurationProvider)
# 
# Usage: 	Crypt-Config 'MyApp.exe' 'connectionStrings'
# 		Decrypt-Config 'MyApp.exe' 'connectionStrings'

[System.Reflection.Assembly]::LoadWithPartialName("System.Configuration");

function Crypt-Config {

param( [string] $configPath = $(throw "Missing: Indicate the path of the configuration file."), 
	[string] $sectionName = $(throw "Missing: Indicate the section to be encrypted.") ) ;

begin {
}

process {
  $config = [System.Configuration.ConfigurationManager]::OpenExeConfiguration( (Convert-Path $configPath) );
  $section = $config.GetSection( $sectionName );

  if(-not $section.SectionInformation.IsProtected) {
    if(-not $section.SectionInformation.IsLocked) {
      $section.SectionInformation.ProtectSection("DataProtectionConfigurationProvider");
      $section.SectionInformation.ForceSave = $true;
      $config.Save( [System.Configuration.ConfigurationSaveMode]::Modified );
    }
  }
}

end {
}

}


function Decrypt-Config {

param( [string] $configPath = $(throw "Missing: Indicate the path of the configuration file."), 
	[string] $sectionName = $(throw "Missing: Indicate the section to be encrypted.") ) ;

begin {
}

process {
  $config = [System.Configuration.ConfigurationManager]::OpenExeConfiguration( (Convert-Path $configPath) );
  $section = $config.GetSection( $sectionName );

  if($section.SectionInformation.IsProtected) {
    if(-not $section.SectionInformation.IsLocked) {
      $section.SectionInformation.UnprotectSection();
      $section.SectionInformation.ForceSave = $true;
      $config.Save( [System.Configuration.ConfigurationSaveMode]::Modified );
    }
  }
}

end {
}

}

