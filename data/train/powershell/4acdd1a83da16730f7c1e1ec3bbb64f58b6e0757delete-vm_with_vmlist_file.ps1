###### Variables definition
$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

    # Création d'un fichier Log $ScriptDir\[SCRIPTNAME]_[YYYY_MM_DD].log
$dateDuJour = Get-Date -uformat %Y_%m_%d
$ScriptLogFile = "$ScriptDir\$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Definition))" + "_" + $dateDuJour + ".log"

$VMLoc = "D:\Hyper-V\GAIA"

###### Functions definition

function Stop-TranscriptOnLog
 {   
 	Stop-Transcript
   # On met dans le transcript les retour à la ligne nécessaire à notepad
    [string]::Join("`r`n",(Get-Content $ScriptLogFile)) | Out-File $ScriptLogFile
 }

function Select-FileDialog
{
    param([string]$Titre,[string]$Filtre="Tous les fichiers *.*|*.*")
	[System.Reflection.Assembly]::LoadWithPartialName( 'System.Windows.Forms' ) | Out-Null
	$fileDialogBox = New-Object Windows.Forms.OpenFileDialog
	$fileDialogBox.ShowHelp = $false
	$fileDialogBox.initialDirectory = $ScriptDir
	$fileDialogBox.filter = $Filtre
    $fileDialogBox.Title = $Titre
	$Show = $fileDialogBox.ShowDialog( )

If ($Show -eq "OK")
    {
        Return $fileDialogBox.FileName
    }
    Else
    {
        Write-Error "Opération annulé"
		[System.Windows.Forms.MessageBox]::Show("Le script ne peut continuer. Arrêt de l'opération." , "Opération annulé" , 0, [Windows.Forms.MessageBoxIcon]::Error)
        Stop-TranscriptOnLog
		Exit
    }

}


###### Démarrage du log et du script
Start-Transcript $ScriptLogFile | Out-Null

   # Import CSV file
[System.Windows.Forms.MessageBox]::Show("Merci de sélectionner dans la fenêtre suivante le fichier CSV contenant la configuration des VM à supprimer.
Son contenu doit ressembler à ceci :

Name
VM01
VM02
VM03
" , "Configuration des VM" , 0, [Windows.Forms.MessageBoxIcon]::Question)

	$CSVVMConfigFile = Select-FileDialog -Titre "Choisir le fichier CSV" -Filtre "Fichier CSV (*.csv) |*.csv"
    $VMList = Import-Csv $CSVVMConfigFile -Delimiter ';'

# Delete Virtual Machines
foreach($VMList in $VMList)
{
                               $VMName = $VMList.Name
# Stop, Delete VM & VHDX
Get-VM $VMName | %{ Stop-VM -VM $_ -Force; Remove-VM -vm $_ -Force ; Remove-Item -Path $_.Path -Recurse -Force}
}

# Get VM
Get-VM | Sort-Object Name | Select Name, State, CPUUsage, MemoryAssigned |Export-CliXML $ScriptDir\Get-VM.xml
Import-CliXML $ScriptDir\Get-VM.xml | Out-GridView -Title Get-VM -PassThru

###### Arrêt du log
	Stop-TranscriptOnLog