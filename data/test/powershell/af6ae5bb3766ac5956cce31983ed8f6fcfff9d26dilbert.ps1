$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
add-type -name win -member $t -namespace native
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)

$Date = Get-Date -Format "yyyy-MM-dd"
$Uri = "http://dilbert.com/strip/" + $Date
$Filename = "Dilbert-" + $Date + ".gif"
$Response = Invoke-WebRequest -Uri $Uri -UseBasicParsing
$ImageUri = ($Response.Images | Where {$_.class -like "*img-comic*"}).src
Invoke-WebRequest -Uri $ImageUri -OutFile $Filename
Invoke-Item $Filename
