# Create function Get-OpenFile
# This allows us to actually select a file we would like to manipulate

  Function Get-OpenFile
    { 
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
    Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.ShowHelp = $true
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "All Files (*.*)| *.*"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
    }

        #Stores information in the file to a variable for later processing.
        $varfile = Get-OpenFile

#What you do here is up to you!
        
        cmd /c pause | out-null
