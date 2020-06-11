function Save-FileFromDialog {
    # Example: 
    #  $fileName = Save-FileFromDialog -defaultfilename 'backup.csv' -titleDialog 'Backup to a CSV file:'
    [CmdletBinding()] 
    param (
        [Parameter(Position=0)]
        [string]$initialDirectory = './',
        [Parameter(Position=1)]
        [string]$defaultfilename = '',
        [Parameter(Position=2)]
        [string]$fileFilter = 'All files (*.*)| *.*',
        [Parameter(Position=3)] 
        [string]$titleDialog = ''
    )
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $SetBackupLocation = New-Object System.Windows.Forms.SaveFileDialog
    $SetBackupLocation.initialDirectory = $initialDirectory
    $SetBackupLocation.filter = $fileFilter
    $SetBackupLocation.FilterIndex = 2
    $SetBackupLocation.Title = $titleDialog
    $SetBackupLocation.RestoreDirectory = $true
    $SetBackupLocation.ShowHelp = if ($Host.name -eq 'ConsoleHost') {$true} else {$false}
    $SetBackupLocation.filename = $defaultfilename
    $SetBackupLocation.ShowDialog() | Out-Null
    return $SetBackupLocation.Filename
}
