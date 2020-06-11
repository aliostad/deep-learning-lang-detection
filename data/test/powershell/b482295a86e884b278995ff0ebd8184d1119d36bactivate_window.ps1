#Set-WindowStyle
#Hint from: http://stackoverflow.com/questions/29496172/how-to-execute-a-powershell-script-without-stealing-focus

Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class Tricks {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
}
"@


function Set-WindowStyle {
param(
    [Parameter()]
    [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE',
                 'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED',
                 'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
    $Style = 'SHOW',
    [Parameter()]
    $MainWindowHandle = (Get-Process -Id $pid).MainWindowHandle
)
    $WindowStates = @{
        FORCEMINIMIZE   = 11; HIDE            = 0
        MAXIMIZE        = 3;  MINIMIZE        = 6
        RESTORE         = 9;  SHOW            = 5
        SHOWDEFAULT     = 10; SHOWMAXIMIZED   = 3
        SHOWMINIMIZED   = 2;  SHOWMINNOACTIVE = 7
        SHOWNA          = 8;  SHOWNOACTIVATE  = 4
        SHOWNORMAL      = 1
    }
    Write-Verbose ("Set Window Style {1} on handle {0}" -f $MainWindowHandle, $($WindowStates[$style]))

    $Win32ShowWindowAsync = Add-Type -memberDefinition @"
    [DllImport("user32.dll")]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"@ -name "Win32ShowWindowAsync" -namespace Win32Functions -passThru

    $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$Style]) | Out-Null
}


function a($str)
{
    $str="*$str*"
    #Based on a simple online comand with above type
    # [void] [Tricks]::SetForegroundWindow((Get-Process  notepad++).MainWindowHandle)
    echo "Searching for '$str'"
        Get-Process|Where-Object {$_.ProcessName -like "$str" -and $_.MainWindowHandle -ne 0 -or $_.MainWindowTitle -like "$str"}|select ProcessName, Id,MainWindowTitle, MainWindowHandle,Path,Description|format-list|echo
    $processes=Get-Process|Where-Object {$_.ProcessName -like "$str" -and $_MainWindowHandle -ne 0 -or $_MainWindowTitle -like "$str"}
    
    foreach( $P in $processes){
        $m=$p.MainWindowHandle
        echo "MainWindowHandle=$m"
        #Set-WindowStyle RESTORE $m
        Set-WindowStyle SHOW $m
        [void] [Tricks]::SetForegroundWindow($m)
    }
    echo " "
    echo "hit [Enter] and maybe ALT TAB to make it show up"
}

