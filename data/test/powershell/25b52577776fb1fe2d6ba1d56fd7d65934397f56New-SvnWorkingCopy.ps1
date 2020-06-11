<#

.SYNOPSIS
 Wrapper function for "svn.exe checkout"

.DESCRIPTION
 Check out a working copy from a repository (HEAD revision).

.EXAMPLE
 New-SvnWorkingCopy -Url https://myserver/svn/myrepo -Path .\myProject

#>
function New-SvnWorkingCopy
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param (
        # Identifies the URL of the Subversion repository.
        [Parameter(Mandatory=$true)]
        [String]
        $Url
        ,
        # Identifies an non-existing directory for the working copy.
        [Parameter(Mandatory=$true)]
        [String]
        $Path
    )
    if ($PSCmdlet.ShouldProcess($Path, "Check out a working copy from $Url"))
    {
        & $SvnBinary checkout `"$Url`" `"$Path`"
    }
}

Set-Alias -Name nsvnwc -Value New-SvnWorkingCopy
