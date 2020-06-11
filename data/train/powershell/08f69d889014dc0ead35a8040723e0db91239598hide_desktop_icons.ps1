$signature = @"
[DllImport("user32.dll")] 
public static extern IntPtr FindWindow(string lpClassName, string lpWindowName); 
[DllImport("user32.dll")] 
public static extern bool ShowWindow(IntPtr hWnd,int nCmdShow);
"@

$icons = Add-Type -MemberDefinition $signature -Name Win32Window `
         -Namespace ScriptFanatic.WinAPI -passThru

$hWnd=$icons::FindWindow("Progman","Program Manager")

function Hide-DesktopIcons{$null = $icons::ShowWindow($hWnd,0) }
function Show-DesktopIcons{$null = $icons::ShowWindow($hWnd,5) } 

Hide-DesktopIcons
