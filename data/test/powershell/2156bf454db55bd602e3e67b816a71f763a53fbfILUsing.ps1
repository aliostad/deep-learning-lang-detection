#
# This is Keith Dalby's script from
# http://solutionizing.net/2008/09/21/multi-purpose-powershell-using-function/
#
# ... with some additions by H.Kutschbach (ilnumerics.net) and Gerd Heber (hdfgroup.org)
#

Function ILUsing {
    param (
        $inputObject = $(throw "The parameter -inputObject is required."),
        [ScriptBlock] $scriptBlock
    )

    if ($inputObject -is [string]) {
        if (Test-Path $inputObject) {
            [system.reflection.assembly]::LoadFrom($inputObject)
        } elseif($null -ne (
              new-object System.Reflection.AssemblyName($inputObject)
              ).GetPublicKeyToken()) {
            [system.reflection.assembly]::Load($inputObject)
        } else {
            [system.reflection.assembly]::LoadWithPartialName($inputObject)
        }
    } elseif ($inputObject -is [System.IDisposable] -and $scriptBlock -ne $null) {
        Try {
            &$scriptBlock
        } Finally {
            if ($inputObject -ne $null) {
                $inputObject.Dispose()
            }
            Get-Variable -scope script |
                Where-Object {
                    [object]::ReferenceEquals($_.Value.PSBase, $inputObject.PSBase)
                } |
                Foreach-Object {
                    Remove-Variable $_.Name -scope script
                }
        }
    } else {
        $inputObject
    }
}
