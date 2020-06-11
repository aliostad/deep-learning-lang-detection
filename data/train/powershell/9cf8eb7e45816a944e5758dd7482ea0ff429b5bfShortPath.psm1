$Source = @"
using System;
using System.Text;
using System.Runtime.InteropServices;

namespace PSCloudbase
{
    public sealed class Win32GetShortPathNameApi
    {
        [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        public static extern Int32 GetShortPathName(String path, StringBuilder shortPath, Int32 shortPathLength);

        [DllImport("Kernel32.dll")]
        public static extern uint GetLastError();
    }
}
"@

Add-Type -TypeDefinition $Source -Language CSharp

function Get-ShortPathName
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$Path
    )
    process
    {
        $sb = New-Object -TypeName "System.Text.StringBuilder" -ArgumentList 1000
        $retVal = [PSCloudbase.Win32GetShortPathNameApi]::GetShortPathName($Path, $sb, $sb.Capacity)
        if (!$retVal) {
            throw "Error: " + [PSCloudbase.Win32GetShortPathNameApi]::GetLastError()
        }
        return $sb.ToString()
    }
}

Export-ModuleMember Get-ShortPathName
