$Title = 'Waiting for APPX! to uninstall'
$Delay = 10
$window = New-Object Windows.Window
$label = New-Object Windows.Controls.Label

$label.Content = $Title
$label.FontSize = 60
$label.FontFamily = 'Consolas'
$label.Background = 'Transparent'
$label.Foreground = 'Red'
$label.HorizontalAlignment = 'Center'
$label.VerticalAlignment = 'Center'

$Window.AllowsTransparency = $True
$Window.Opacity = .7
$window.WindowStyle = 'None'
$window.Content = $label
$window.Left = $window.Top = 0
$window.WindowState = 'Maximized'
$window.Topmost = $true

$null = $window.Show()
Start-Sleep -Seconds $Delay
$window.Close()
