Function Copy-ZipContent
{<#
    .SYNOPSIS
        Copies content out of a zip file
#>
    Param ([parameter(mandatory = $true)][ValidateNotNullOrEmpty()]
           [string]$zipFile, 

           [parameter(mandatory = $true)][ValidateNotNullOrEmpty()]
           [string]$Path
    )
    if(test-path($zipFile)) {$shell = new-object -com Shell.Application
                             $destFolder = $shell.NameSpace($Path)
                             $destFolder.CopyHere(($shell.NameSpace($zipFile).Items()))
    }        
}


