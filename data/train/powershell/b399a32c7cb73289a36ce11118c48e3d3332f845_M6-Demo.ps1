# 1.Parameterized configuration - REusable configurations
ise C:\Scripts\DSC1\Mod6\1.config_param.ps1

# 2. Credentials 
ise C:\Scripts\DSC1\Mod6\2.config_Credentials.ps1 # Will Fail
ise C:\Scripts\dsc1\mod6\2a.config_data.psd1 # Configuration Data
ise C:\Scripts\dsc1\Mod6\2a.Config_credential.ps1
# Show it worked and Bad things in MOF
explorer \\s1\c$
ise C:\DSCSecure\S1.mof
# need proper certificate script
# certificate is already issued - however can show
# 1. Certificate authority on DC - issue Workstation Authentication (Client Auth) Certificate Template
# 2. Open MMC add Certificates for Local Computer -- create AND EXPORT certificate in personal store named ClientAuth.Cer
# 3. Copy .Cer to DC - c:\cert
ise C:\Scripts\dsc1\mod6\2b.config_data.psd1 # Configuration Data
ise C:\Scripts\dsc1\Mod6\2b.Config_credential.ps1
# Show it worked and Bad things in MOF
explorer \\s1\c$
ise C:\DSCSecure\S1.mof


# 3. DependsOn
ise C:\Scripts\DSC1\Mod6\3.config_DependsOn.ps1