$DefaultDirectoryFile = "${ENV:APPDATA}\.directories.xml"

function Update-SpecialDirectories
{
<#
.SYNOPSIS

	Updates the PowerShell functions for each special directory.

.PARAMETER SaveLocation

	The path where the special directories are saved.

.LINK 
about_SpecialDirectories

.LINK 
Get-SpecialDirectories

.LINK 
New-SpecialDirectory

.LINK 
Remove-SpecialDirectory

.LINK
Invoke-SpecialDirectories
#>
	[CmdletBinding(SupportsShouldProcess=$true)]
	param(
		[string]$SaveLocation = $DefaultDirectoryFile
	)
	
	process
	{
		$SpecialDirectories = Get-SpecialDirectories $SaveLocation

		foreach ($key in $SpecialDirectories.keys)
		{
			if ($pscmdlet.ShouldProcess($key))
			{
				Write-Verbose "$key -> $($SpecialDirectories[$key])"
				new-item "function:global:$key" -value "set-location '$($SpecialDirectories[$key])'" -force
			}
		}
	}
}

function Get-SpecialDirectories
{
<#
.SYNOPSIS

    Get-SpecialDirectories

.DESCRIPTION

    The Get-SpecialDirectories cmdlet returns all of the currently
    active special directories. The New-SpecialDirectory and
    Remove-SpecialDirectory scripts will update the set of active
	special directories.

.PARAMETER SaveLocation

	The path where the special directories are saved.

.LINK    

about_SpecialDirectories

.LINK    

New-SpecialDirectory

.LINK    

Remove-SpecialDirectory

.LINK    

Update-SpecialDirectories

.LINK
Invoke-SpecialDirectories

#>

	[CmdletBinding()]
	
	param(
		[Parameter()]
		[string]$SaveLocation = $DefaultDirectoryFile
		)
		
	process
	{
		if (-not $(Test-Path $SaveLocation))
		{
			new-object System.Collections.Hashtable
		}
		else
		{
			Import-Clixml $SaveLocation
		}
	}
}

function New-SpecialDirectory
{
<#
.SYNOPSIS

    Creates a new "special directory" for fast namespace navigation.

.DESCRIPTION

    New-SpecialDirectory creates a new "special directory" for fast
    namespace navigation. A special directory consists of an
    identifier and a directory. When you define a special directory, a
    function gets created using the name of the special directory
    identifier; the function uses set-location to navigate you to the
    special directory.

.PARAMETER Key

        This is the identifier for the special directory. The key must
        conform to PowerShell identifier syntax.

.PARAMETER Directory

        This is the directory to navigate to. Defaults to the current
        directory.

.PARAMETER SaveLocation

	The path where the special directories are saved.

.LINK    

about_SpecialDirectories

.LINK    

New-SpecialDirectory

.LINK    

Remove-SpecialDirectory

.LINK    

Update-SpecialDirectories

.LINK
Invoke-SpecialDirectories

	
#>
	[CmdletBinding(SupportsShouldProcess=$true)]
	param( 
		[Parameter(Position=0,Mandatory=$true)]
		[string]$Key,
		[Parameter(Position=1)]
		[string]$Directory = $(pwd).Path,
		[Parameter()]
		[string]$SaveLocation = $DefaultDirectoryFile
		)
		
	process
	{
		if ($pscmdlet.ShouldProcess($key))
		{
			$directories = Get-SpecialDirectories $SaveLocation
			$directories[$key] = $directory
			$directories | Export-CliXml -path $SaveLocation
			Update-SpecialDirectories -SaveLocation $SaveLocation
		}
	}
}

function Remove-SpecialDirectory
{
<#
.SYNOPSIS

    Removes a directory from the list of special directories.

.DESCRIPTION

    Removes one of the special directory key<->directory pairs.

.PARAMETER Key

        The key that identifies the special directory to remove.

.PARAMETER SaveLocation

	The path where the special directories are saved.

.LINK    

about_SpecialDirectories

.LINK    

New-SpecialDirectory

.LINK    

Remove-SpecialDirectory

.LINK    

Update-SpecialDirectories

.LINK
Invoke-SpecialDirectories

#>

	[CmdletBinding(SupportsShouldProcess=$true)]
	
	param(
		[Parameter(Position=0,Mandatory=$true)]
		[string]$Key,
		[Parameter()]
		[string]$SaveLocation = $DefaultDirectoryFile
	)
	
	process
	{
		if ($pscmdlet.ShouldProcess($key))
		{
			$directories = Get-SpecialDirectories $SaveLocation
			$directories.remove( $key )

			$directories | Export-CliXml -path $SaveLocation
			remove-item "function:$key"
		}
	}
}

function Invoke-SpecialDirectories
{
<#
.SYNOPSIS

Performs commands in each special directory.

.DESCRIPTION

This function lets you iterate over every special directory and execute
a script block.

.PARAMETER Block

The code to execute within each directory.

.PARAMETER Filter

An optional filter to evaluate in each directory. If the filter returns
$false, then Block will not be invoked in the directory.

.PARAMETER SaveLocation

	The path where the special directories are saved.

.LINK    

about_SpecialDirectories

.LINK    

New-SpecialDirectory

.LINK    

Remove-SpecialDirectory

.LINK    

Update-SpecialDirectories

.LINK
Get-SpecialDirectories

#>

    [CmdletBinding(SupportsShouldProcess=$true)]
    
    param(
        [Parameter(Position=0,Mandatory=$true)]
        [ScriptBlock]$Block,
        [Parameter(Position=1)]
        [ScriptBlock]$Filter,
        [Parameter()]
        [string]$SaveLocation = $DefaultDirectoryFile
    )
    
    push-location
    $(Get-SpecialDirectories $SaveLocation).Values | foreach {
        if ($pscmdlet.ShouldProcess($_))
        {
            Set-Location $_
            if ($Filter)
            {
                $precondition = & $Filter
            }
            else
            {
                $precondition = $true
            }
            if ($precondition)
            {
                write-host "In $_..." -fore green -back black
                & $Block
            }
            else
            {
                write-verbose "Skipping $_ (precondition failed)"
            }
        }
    }
    pop-location
}

new-alias gsd Get-SpecialDirectories
new-alias usd Update-SpecialDirectories
new-alias nsd New-SpecialDirectory
new-alias rsd Remove-SpecialDirectory
new-alias isd Invoke-SpecialDirectories

Update-SpecialDirectories

Export-ModuleMember -function Get-SpecialDirectories, New-SpecialDirectory, Update-SpecialDirectories, Remove-SpecialDirectory, Invoke-SpecialDirectories
Export-ModuleMember -variable DefaultDirectoryFile
Export-ModuleMember -alias gsd, usd, nsd, rsd, isd
