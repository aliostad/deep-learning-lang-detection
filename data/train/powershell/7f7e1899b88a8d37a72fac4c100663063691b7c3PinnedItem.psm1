$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

#region Define Custom Object
Add-Type -TypeDefinition @"
using System;
using System.Text;
using System.Runtime.InteropServices;

public enum PinnedType
{
    StartMenu,
    TaskBar
}

public enum PinnedTypeVerb
{
    PintoStartMenu = 5381,
    UnpinfromStartMenu = 5382,
    PintoTaskbar = 5386,
    UnpinfromTaskbar = 5387
}

namespace System.File.PSItem
{
    public class MUIHelper
    {
        [DllImport("user32.dll")]public static extern int LoadString(IntPtr h,uint id, System.Text.StringBuilder sb,int maxBuffer);
        [DllImport("kernel32.dll")]public static extern IntPtr LoadLibrary(string s);
    }

    public class PinnedItem
    {
        public string Name;
        public string FullName;
        public string Destination;
        public PinnedType Type;
    }
}
"@ -Language CSharpVersion3
#endregion Define Custom Object

#region Load Functions
Try {
    Get-ChildItem "$ScriptPath\Scripts" -Filter *.ps1 | Select -Expand FullName | ForEach {
        $Function = Split-Path $_ -Leaf
        . $_
    }
} Catch {
    Write-Warning ("{0}: {1}" -f $Function,$_.Exception.Message)
    Continue
}
#endregion Load Functions

#region Helper Functions
Function ConvertToVerb {
    Param (        
        [PinnedTypeVerb]$Action
    )
    $Shell32 = [System.File.PSItem.MuiHelper]::LoadLibrary('shell32.dll')
    $StringBuilder = New-Object System.Text.StringBuilder -ArgumentList '', 255

    [void][System.File.PSItem.MuiHelper]::LoadString(
        $Shell32,
        $Action.value__,
        $StringBuilder,
        $StringBuilder.Capacity
    )
    Write-Output $StringBuilder.ToString()
}
#endregion Helper Functions

#region Aliases
New-Alias -Name gpi -Value Get-PinnedItem
New-Alias -Name rpi -Value Remove-PinnedItem
New-Alias -Name npi -Value New-PinnedItem
#endregion Aliases

Export-ModuleMember -Alias * -Function *-pinned*