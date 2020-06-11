#Function for open file dialog, gets string of file location to pass onto the script
function Read-OpenFileDialog([string]$WindowTitle, [string]$InitialDirectory, [string]$Filter = "All files (*.*)|*.*")
{  
	Add-Type -AssemblyName System.Windows.Forms
	$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	$openFileDialog.Title = $WindowTitle
	if (![string]::IsNullOrWhiteSpace($InitialDirectory)) { $openFileDialog.InitialDirectory = $InitialDirectory }
	$openFileDialog.Filter = $Filter
	$openFileDialog.ShowDialog() > $null
	$openFileDialog.ShowHelp = $true	# Without this line the ShowDialog() function may hang depending on system configuration and running from console vs. ISE.
    $openFileDialog.FileName
}

#function for save file dialog to get create CSV file if does not exist or prompt if going to overwrite existing file
function Get-SaveFileDialog([string]$WindowTitle, [string]$InitialDirectory, [string]$Filter = "All files (*.*)|*.*")
{  
	Add-Type -AssemblyName System.Windows.Forms
	$saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
	$saveFileDialog.Title = $WindowTitle
	if (![string]::IsNullOrWhiteSpace($InitialDirectory)) { $saveFileDialog.InitialDirectory = $InitialDirectory }
	$saveFileDialog.Filter = $Filter
    $saveFileDialog.createPrompt = $true
    $saveFileDialog.overwritePrompt = $true
    $saveFileDialog.ShowDialog() > $null
    $saveFileDialog.ShowHelp = $true	# Without this line the ShowDialog() function may hang depending on system configuration and running from console vs. ISE.
    $saveFileDialog.FileName
}

#open file dialog
$filePath = Read-OpenFileDialog -WindowTitle "Select CSV File To Import " -InitialDirectory 'C:\' -Filter "CSV (*.csv)|*.csv"

#save file dialog
$exportPath = Get-SaveFileDialog -WindowTitle "Save CSV Output To..." -InitialDirectory 'C:\' -Filter "CSV (*.csv)|*.csv"

$Names = Import-Csv $filePath
#loop to go through each name in CSV file
$Names | foreach {
    $First = $_.FirstName
    $Last = $_.LastName
    ForEach-Object {$findName = Get-ADUser -Filter "(GivenName -like '$First*') -and (SurName -like '$Last*')" -Properties title | Select-Object -Property Name,SamAccountName,Enabled,title
        If($findName) {$findName}
        else {[PSCustomObject]@{Name=$First + ' ' + $Last; SAMAccountName='Not found'; Enabled=$null; Title=$null}} #If no name found, creates custom object to return the full name back to list with null data
    }
} | Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "Finished looking up the list of names."
