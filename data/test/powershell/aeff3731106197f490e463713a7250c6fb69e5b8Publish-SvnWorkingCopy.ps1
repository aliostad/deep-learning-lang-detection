<#

.SYNOPSIS
 Wrapper function for "svn.exe commit"

.DESCRIPTION
 Send changes from your working copy to the repository.

.EXAMPLE
 Publish-SvnWorkingCopy -Path .\myProject -Message 'Fixed bug #456'

#>
function Publish-SvnWorkingCopy
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param (
        # Identifies the directory of the working copy.
        [Parameter(Mandatory=$true)]
        [String]
        $Path
        ,
        # Identifies a mandatory log message.
        [Parameter(Mandatory=$true)]
        [String]
        $Message
    )
    if ($PSCmdlet.ShouldProcess($Path, 'Commit changes to repository'))
    {
        & $SvnBinary commit `"$Path`" --message `"$Message`"
    }
}

Set-Alias -Name pbsvnwc -Value Publish-SvnWorkingCopy
