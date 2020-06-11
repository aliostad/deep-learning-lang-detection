# access GUI dialog from powershell
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

# message box
function Show-MessageBox([string]$message, [string]$title,
    $button = [System.Windows.Forms.MessageBoxButtons]::OK,
    $icon = [System.Windows.Forms.MessageBoxIcon]::None)
{
  [System.Windows.Forms.MessageBox]::Show($message, $title, $button, $icon) > $null
}
 
# input box
function Read-InputBox([string]$label, [string]$title, [string]$initial)
{
  [Microsoft.VisualBasic.Interaction]::InputBox($label, $title, $initial)
}
 
# open file dialog
function Read-OpenFileDialog([string]$initial, [string]$filter = "All files (*.*)|*.*",
    [switch]$AllowMultiSelect = $false)
{  
  $dialog = New-Object System.Windows.Forms.OpenFileDialog
  $dialog.initialDirectory = $initial
  $dialog.filter = $filter
  if ($AllowMultiSelect) {
    $dialog.MultiSelect = $true
  }
  $dialog.ShowDialog() > $null
  if ($AllowMultiSelect) {
    return $dialog.Filenames
  } else {
    return $dialog.Filename
  }
}
 
# open folder dialog
function Read-FolderBrowserDialog([string]$InitialDirectory)
{
  $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
  $dialog.ShowNewFolderButton = $true
  $dialog.RootFolder = $InitialDirectory
  $dialog.ShowDialog()
  return $dialog.SelectedPath
}
 

