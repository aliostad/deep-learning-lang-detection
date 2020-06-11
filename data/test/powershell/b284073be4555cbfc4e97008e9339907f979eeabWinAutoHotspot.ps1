# Functions
# Based on https://community.spiceworks.com/topic/664020-maximize-an-open-window-with-powershell-win7
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

    $Win32ShowWindowAsync = Add-Type –memberDefinition @” 
    [DllImport("user32.dll")] 
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
“@ -name “Win32ShowWindowAsync” -namespace Win32Functions –passThru

    $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$Style]) | Out-Null
}

## Include
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

## Main
$net = Test-NetConnection
If ($net.PingSucceeded -eq $True) {
    Start-Process -WindowStyle Minimized -FilePath ms-settings:network-mobilehotspot
    $wshell = New-Object -ComObject wscript.shell; 
    Get-Process | ? { $_.MainWindowTitle -eq "Settings" } | % {
        Set-WindowStyle -Style MINIMIZE -MainWindowHandle $_.MainWindowHandle
    }
    Sleep 1
    # First position is after 6x TAB
    Get-Process | ? { $_.MainWindowTitle -eq "Settings" } | % {
        Set-WindowStyle -Style RESTORE -MainWindowHandle $_.MainWindowHandle
    }
    $wshell.AppActivate('Settings')
    [System.Windows.Forms.SendKeys]::SendWait("`t`t`t`t`t`t ")
    Sleep 1
    $wshell.AppActivate('Settings')
    [System.Windows.Forms.SendKeys]::SendWait("%{F4}") #ALT+F4
}