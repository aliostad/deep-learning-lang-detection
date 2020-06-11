<##################################################################################################
    Load Script from Object Store

    This module will load a script from the PSNativeDataStore repository stored in the Inspector1
    project.  If the script does not exist, it is created. This is for your convenience.  No setup
    required.

    NOTE:  When you specify an NDS object, you simply supply the name.
           When you specify a script, you provide both the file name and the extension
##################################################################################################>
clear-host

$prj = 'Inspector1'
$script = "Tester.ps1"  #####  NOTE that scripts REQUIRE an extension.

### Load PSNativeDataStore functionality

Import-Module -Name PSNativeDataStore -DisableNameChecking


## This section will create a script file in the specified project.  Doing this allows you to run this 
## script without the need to copy the script file to the repository first. (that ease and simplicity model we keep mentioning!!!!)
$scriptdir = Get-NDSProjectScriptPath -projectname $prj
Make-NDSSafeDIR -path $scriptdir
Set-Content -Path "$scriptdir\$script" -Value "Write-Host 'You have successfully loaded $script!!!!!'"


### Load script from repository. Script will write message indicating success
Load-NDSScript -projectname $prj -scriptname $script

