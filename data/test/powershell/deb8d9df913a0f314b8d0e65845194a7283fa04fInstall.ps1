#install.ps1-v2

param(
	[string]$installationUrl = $(throw "please specify the url of a SharePoint site to install to!"),
	[string]$mySiteHost = $(throw "please specify the url of a SharePoint site to install to!")
)

"Install Invoked..."

if (-not $installationUrl.EndsWith("/")) { $installationUrl += "/"; }


### Add the snap in if it's not already added
if ((Get-PSSnapin | where { $_.Name -eq "Microsoft.SharePoint.PowerShell" } | Measure-Object).Count -lt 1) { Add-PSSnapIn Microsoft.SharePoint.PowerShell }


#--------------------------------------------------------------------
# AutoSetup Stuff
#--------------------------------------------------------------------
cd AutoSetup

cmd /c "AutoSetup32 demo32.xml"
if (!$LASTEXITCODE -eq 0) { throw "AutoSetup32 did not complete successfully."; }

cd ..

write-progress -percentcomplete 10 -Activity Installing -Status Installing


#--------------------------------------------------------------------
# Add Registry Key
#--------------------------------------------------------------------
"Adding Registry Key for People Picture Load into AD..."
cd SystemRegistryKeys
cmd /c "regedit.exe /s ""RegKeys.reg""";
cd ..

write-progress -percentcomplete 12 -Activity Installing -Status Installing

#--------------------------------------------------------------------
# Load Profile Pictures into Active Directory
#--------------------------------------------------------------------
#"Loading Profile Pictures into Active Directory..."
#cd ProfilePicturesLoad
#cmd /c "ProfilePicturesLoad.vbs"
#cmd /c "GlobalCatalogAttributeReplication.vbs"
#cd ..


write-progress -percentcomplete 30 -Activity Installing -Status Installing

#--------------------------------------------------------------------
# Load Profile Pictures into SharePoint and Set Profile Information
#--------------------------------------------------------------------
"Loading Profile Pictures into SharePoint and Seting Profile Information..."

# pipe each record from the xml file to the setup-user script with the $site argument:
.\ReadXml.ps1 ".\People.xml" ".\CreateUser.ps1" $installationUrl $mySiteHost
.\ReadXml.ps1 ".\People.xml" ".\SetupUser.ps1" $installationUrl $mySiteHost

write-progress -percentcomplete 70 -Activity Installing -Status Installing

#--------------------------------------------------------------------
# Update Profile Pictures to re-size correctly 
#--------------------------------------------------------------------
"Resizing Profile Pictures..."

#$mySiteHost = $installationUrl + "my/";

Update-SPProfilePhotoStore -MySiteHostLocation $mySiteHost

#--------------------------------------------------------------------
# Installation Complete!
#--------------------------------------------------------------------
"Installation Complete!";
write-progress -percentcomplete 100 -Activity Installing -Status Installing
