function showMainWindow{
    param([string]$CallPath, [string]$targetComputerIp)

    Add-Type –assemblyName PresentationFramework
    Add-Type –assemblyName PresentationCore
    Add-Type –assemblyName WindowsBase

    $xaml = Get-Content -Path $CallPath\MainWindow.xaml

    Write $xaml

    $Window = [Windows.Markup.XamlReader]::Parse($xaml)

    $btnDisconnect = $Window.FindName("btnDisconnect")
    $lblPcName = $Window.FindName("lblPcName")

    $lblPcName.Content = "Nom du PC: " + $targetComputerIp

    $btnDisconnect.Add_Click({
        [System.Windows.MessageBox]::Show("Comment t'as pu te connecter si l'emplémentation de la connexion n'est pas encore faite ?", "LOL", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Question)
    })

    $Window.ShowDialog()
}