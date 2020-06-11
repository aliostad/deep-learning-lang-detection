function Get-FileFromDialog {
    # Example: 
    #  $fileName = Get-FileFromDialog -fileFilter 'CSV file (*.csv)|*.csv' -titleDialog "Select A CSV File:"
    [CmdletBinding()] 
    param (
        [Parameter(Position=0)]
        [string]$initialDirectory = './',
        [Parameter(Position=1)]
        [string]$fileFilter = 'All files (*.*)| *.*',
        [Parameter(Position=2)] 
        [string]$titleDialog = '',
        [Parameter(Position=3)] 
        [switch]$AllowMultiSelect=$false
    )
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = $fileFilter
    $OpenFileDialog.Title = $titleDialog
    $OpenFileDialog.ShowHelp = if ($Host.name -eq 'ConsoleHost') {$true} else {$false}
    if ($AllowMultiSelect) { $openFileDialog.MultiSelect = $true } 
    $OpenFileDialog.ShowDialog() | Out-Null
    if ($AllowMultiSelect) { return $openFileDialog.Filenames } else { return $openFileDialog.Filename }
}
