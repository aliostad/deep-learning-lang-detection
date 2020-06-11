function showLoginWindow {
    param([string]$CallPath)

    Add-Type –assemblyName PresentationFramework
    Add-Type –assemblyName PresentationCore
    Add-Type –assemblyName WindowsBase

    $xaml = Get-Content -Path $CallPath\LoginWindow.xaml

    $Window = [Windows.Markup.XamlReader]::Parse($xaml)

    $btnConnect = $Window.FindName("btnConnect")

    $btnConnect.Add_Click({
        $Window.Close()
        . $CallPath\MainWindow.ps1
        showMainWindow $CallPath "Salut"
    })

    $Window.ShowDialog()
}
