  Add-Type -AssemblyName PresentationFramework
  $window = New-Object Windows.Window
  $label = New-Object Windows.Controls.Label

  $label.Content = 'Printing... 
  Please do not click or use keyboard Wait'
  $label.FontSize = 60
  $label.FontFamily = 'Consolas'
  $label.Background = 'Transparent'
  $label.Foreground = 'Black'
  $label.HorizontalAlignment = 'Center'
  $label.VerticalAlignment = 'Center'

  $Window.AllowsTransparency = $True
  $Window.Opacity = .7
  $window.WindowStyle = 'None'
  $window.Content = $label
  $window.Left = $window.Top = 0
  $window.WindowState = 'Maximized'
  $window.Top = $true


  $null = $window.Show()
  Start-Sleep -Seconds 10
  $window.Close()