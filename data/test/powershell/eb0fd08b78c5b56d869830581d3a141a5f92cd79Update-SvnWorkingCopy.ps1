<#

.SYNOPSIS
 Wrapper function for "svn.exe update"

.DESCRIPTION
 Bring the latest changes from the repository into the working copy (HEAD revision).

.EXAMPLE
 Update-SvnWorkingCopy -Path .\myProject

#>
function Update-SvnWorkingCopy
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param (
        # Identifies the directory of the working copy.
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String]
        $Path
    )
    Begin
    {
    }
    Process
    {
        if ($PSCmdlet.ShouldProcess($Path, 'Update working copy'))
        {
            & $SvnBinary update `"$Path`"
        }
    }
    End
    {
    }
}

Set-Alias -Name udsvnwc -Value Update-SvnWorkingCopy
