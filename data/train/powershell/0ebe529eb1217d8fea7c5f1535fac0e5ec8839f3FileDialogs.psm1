<#
    .Synopsis
    Displays a GUI prompting the user to select files.
    
    .Parameter InitialDirectory
    The initial directory displayed by the file dialog box
     
    .Parameter Filter
    The file name filter string, which determines the choices that
    appear in the "Save as file type" or "Files of type" box in the dialog box.
    
    .Parameter Multiselect 
    A value indicating whether the dialog box allows multiple files to be selected.
    
    .Parameter Title
    The file dialog box title
#>
function Open-Files ([string]$initialDirectory, $filter = 'All Files (*.*)|*.*', [bool]$multiselect = $false, [string]$title) {
    add-type -Assembly System.Windows.Forms
    
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.InitialDirectory = $initialDirectory
    $dlg.Filter = $filter
    $dlg.Multiselect = $multiselect
    $dlg.Title = $title
    
    $result = $dlg.ShowDialog()
    if($result -eq 'OK') {
        if($multiselect){
            return $dlg.FileNames
        } else {
            return $dlg.FileName
        }
    } else {
        Write-Debug 'User cancelled operation'
    }
}

<#
    .Synopsis
    Displays a GUI prompting the user to select a directory.
    
    .Parameter RootFolder
    The root folder where the browsing starts from.
    
    .Parameter InitialDirectory
    The initial directory displayed by the file dialog box
    
    .Parameter ShowNewFolderButton
    A value indicating whether the New Folder button appears in the folder browser dialog box.
    
    .Parameter Description
    The descriptive text displayed above the tree view control in the dialog box.
#>
function Get-Directory([System.Environment+SpecialFolder]$rootFolder = 'MyComputer', [string]$initialDirectory, [bool]$showNewFolderButton = $false, [string]$description) {
    add-type -Assembly System.Windows.Forms

    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    $dlg.RootFolder = $rootFolder
    $dlg.SelectedPath = $initialDirectory
    $dlg.ShowNewFolderButton = $showNewFolderButton
    $dlg.Description = $description
    
    $result = $dlg.ShowDialog()
    if($result -eq 'OK') {
        return $dlg.SelectedPath
    } else {
        Write-Debug 'User cancelled operation'
    }
}

Export-ModuleMember -Function Open-Files
Export-ModuleMember -Function Get-Directory