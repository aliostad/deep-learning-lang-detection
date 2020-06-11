<#
  .SYNOPSIS
  Accepts pipeline of TypeLib Guid Strings and looks them up in the registry and then checks existence of file 
  Useful if you have a load of broken links and can run this script on a machine where the files exist.
  Helps to identify them

  .PARAMETER input
  Pipeline Strings with GUID string 
  

  .Example 1
  remove-module Get-TypeLib
  import-module .\Get-TypeLib.ps1
  $guids = import-csv -path mypath\myfile.csv
  $guids|%{@($_.guid)}|Get-TypeLib

  .Notes

#>

function Get-TypeLib {
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)] $value

    )

    begin {

        ###########################################################################
        function LoadMcdfLibrary {
            if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent){
                Write-Host "Loading MSOVBA Library"
            }
            [void][Reflection.Assembly]::LoadFile("${PSScriptRoot}\euclib.dll")

        }
    
        if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent){
            Write-Host "Initialising...."
        }

        LoadMcdfLibrary

    }

    process {
        $guid = [Guid]$value;
        $count++;
        $result = [System.Collections.arrayList]@()

        if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent){
            Write-host  "${count}: Reading typelib for  " $guid
        }

        $paths = [com.redpixie.euc.mcdf.PsWrapper]::GetLibraryForTypeLibGuid($guid)

        if ( $paths.Count -gt 0 ){
            $path = $paths[0]
            if ( test-Path $path ){
                [void]$result.Add(@{guid=$guid;path=$path; IsBroken=$false})
            }
            else {
                # This cant really happen!
                [void]$result.Add(@{guid=$guid;path=$path; IsBroken=$true})
            }
        }
        else {
            [void]$result.Add(@{guid=$guid; path=""; IsBroken=$true})
        }

        $result
    }

    end {
    }
}

