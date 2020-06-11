##
##    PsGet helper module installation stuff.
##    URL: https://github.com/psget/psget_kit
##

#requires -Version 2.0

function Submit-Module {
[CmdletBinding()]
Param(    
    [Parameter(Mandatory=$true, ParameterSetName="GutHub")]    
    [String]$GitHubURL,
    [String]$ApiUrl = "http://psget.net/api"
)

    #Dependencies
    Install-Module PsUrl

    Send-WebContent "$ApiUrl/submissions/githubmodule" -Data @{GitHubURL=$GitHubURL}
<#
.Synopsis
    Submits a module to the central directory
.Description 
    [TBD]    
.Parameter GitHubURL
    URL tp GitHub repository of the module. Should be something like https://github.com/chaliy/psget
.Link
    http://psget.net       
        
.Example
    # Submit-Module -GitHubURL https://github.com/chaliy/psget

    Description
    -----------
    Submits PsGet module to the cetrnal directory
    
#>
}

Export-ModuleMember Submit-Module