#Handle dependencies here

$depsCachePath=".\PSDeps"

#PSDepend bootstrap - Note must be running as Admin
if($PSVersionTable.PSEdition -eq "Desktop")
{
    $dependAvailable=(Get-Module -ListAvailable | Where-Object { $_.Name -eq "PSDepend" })
    if(!($dependAvailable)){
        Install-Module -Name PSDepend 
    }
    Import-Module PSDepend
    Invoke-PSDepend -Path .\requirements.psd1 -Target $depsCachePath -Force -Install -Import
}
else {
    # Manual deps handling, braindead for now
    #Foreach item
    # Is in deps cache path? 
    #  If so, load
    #  If not, Save to deps cache path and load
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Install-Module PFCore
    Install-Module PFDockerCore
}