Function CopyTo-ProfileAppData {


Param(
        [Parameter(Mandatory = $true)]
        [string[]] $CopyArray,
        [string] $VendorFolder
    ) 

    <#
.SYNOPSIS
Copies any file(s) into the UserProfile\AppData\Roaming folder from the SupportFiles directory.
.DESCRIPTION
Just type in file names and vendor folder name in the parameter.
.EXAMPLE
CopyTo-RoamingProfiles -CopyArray "somefile.txt", "somefile.xlsx" -VendorFolder "Visual Cactus"
.EXAMPLE
This is an example if you needed to copy files into a nested folder inside the vendor folder.
CopyTo-RoamingProfiles -CopyArray "somefile.txt", "somefile.xlsx" -VendorFolder "Visual Cactus\Config"
This files you specified will get copied in the Config folder.
.PARAMETER $CopyArray
The name of the files you want to copy form the SupportFiles directory.
.PARAMETER $VendorFolder
The name of the vendor folder you want to copy to inside the Profile\AppData\ folder
.NOTES
v 0.5 Alpha  Ty Stallard & Kevin Doran  11/12/2014
#>


$profilenames = Get-ChildItem -Attributes d,h -Path c:\users -Name *
$PROFILEDIR = "C:\Users"
$AppDataExceptions = "Administrator", "Public", "All Users", "Defualt User", "Desktop.ini", "pfuser"



Write-Log -Message "|COPY TO APPDATA PROFILE|*** START ***"
foreach ($profilename in $profilenames) {
If ($AppDataExceptions -contains $profilename)
{}
    Else{
         Write-Log -Message "Info:Copying $FilesToCopy to the $PROFILEDIR\$PROFILENAME\AppData\$VendorFolder directory"
         New-Item -ItemType directory -Path "$PROFILEDIR\$PROFILENAME\AppData\$VendorFolder"
         foreach ($FileItem in $CopyArray)
         {
         Copy-File -Path $dirSupportFiles\$FileItem -Destination "$PROFILEDIR\$PROFILENAME\AppData\$VendorFolder"   
         }
         
         }
        
}
Write-Log -Message "|COPY TO APPDATA PROFILE |*** END ***"
}