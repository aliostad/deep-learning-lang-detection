<#

.SYNOPSIS
 Fix a working copy that has been modified by non-svn commands in terms of
 adding and removing files.

.DESCRIPTION
 Identify items that are not under version control and items that are missing
 (i.e. removed by non-svn command). Put non-versioned items under version
 control (i.e. schedule for adding upon next commit). Remove missing items from
 version control (i.e. schedule for deletion upon next commit).

.EXAMPLE
 Repair-SvnWorkingCopy -Path .\myProject

#>
function Repair-SvnWorkingCopy
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param (
        # Identifies the directory of the working copy.
        [Parameter(ValueFromPipeline=$true)]
        [String]
        $Path = '.'
    )
    Begin
    {
    }
    Process
    {
        $wc = $Path | Get-SvnWorkingCopy

        $wc | Where-Object {$_.Status -eq $SvnStatus.Missing} | ForEach-Object {
            $_.Name | Remove-SvnWorkingCopyItem
        }

        $wc | Where-Object {$_.Status -eq $SvnStatus.UnversionedItem} | ForEach-Object {
            $_.Name | Add-SvnWorkingCopyItem
        }
    }
    End
    {
    }
}
