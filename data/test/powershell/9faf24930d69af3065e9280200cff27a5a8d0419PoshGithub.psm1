#######################################################################################################################
# File:             PoshGithub.psm1                                                                                   #
# Author:           Thomas Krause                                                                                     #
# Publisher:                                                                                                          #
# Copyright:        © 2012 . All rights reserved.                                                                     #
# Usage:            To load this module in your Script Editor:                                                        #
#                   1. Open the Script Editor.                                                                        #
#                   2. Select "PowerShell Libraries" from the File menu.                                              #
#                   3. Check the PoshGithub module.                                                                   #
#                   4. Click on OK to close the "PowerShell Libraries" dialog.                                        #
#                   Alternatively you can load the module from the embedded console by invoking this:                 #
#                       Import-Module -Name PoshGithub                                                                #
#                   Please provide feedback on the PowerGUI Forums.                                                   #
#######################################################################################################################

Set-StrictMode -Version 2

# TODO: Define your module here.
. $psScriptRoot\SharedScripts.ps1

. $psScriptRoot\Enter-GithubSession.ps1
. $psScriptRoot\Get-GithubSession.ps1
. $psScriptRoot\Invoke-GithubItem.ps1

. $psScriptRoot\Get-GithubGist.ps1
. $psScriptRoot\New-GithubGist.ps1
. $psScriptRoot\Remove-GithubGist.ps1


