$manageBDE = 
{
param ([String]$recoveryKey, [String]$stdoutput, [String]$bitlockerLetter)
 
 $manageBDEParameters = "-unlock " + $bitlockerLetter + " -recoverypassword " + $recoveryKey
 Start-Process "manage-bde.exe" -argumentlist $manageBDEParameters -nonewwindow -redirectStandardoutput $stdoutput -wait
}

$joinPath = "C:", "D:", "E:", "F:", "G:"
$assignUSBLetter = ""
foreach($unit in $joinPath){
    $pathToTest = $unit + "\os.vhd"
    $findUSB = Test-Path $pathToTest
    if ($findUSB){
        $assignUSBLetter = $unit
    }
}

##[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
#[System.Windows.Forms.MessageBox]::Show($assignUSBLetter)

$pathToVHD = $assignUSBLetter + "\os.vhd"

$findVHD = Test-Path $pathToVHD


if ($findVHD){
    $mountedLetter = mount-diskimage -ImagePath $pathToVHD -StorageType VHD -NoDriveLetter
    
    $gettingDisks = Get-Disk | Where-Object –FilterScript {$_.FriendlyName -Eq "Microsoft Virtual Disk"}

    $vhdDiskNumber = $gettingDisks.Number

    Add-PartitionAccessPath -DiskNumber $vhdDiskNumber -PartitionNumber 1 -AccessPath "W:"

    $manageBdeOutput = $assignUSBLetter + "\manageBdeResult.txt"

    $computerObtainedName = ""
    $hasBeenDecoded = $false
    $result = $false
    $alreadyUnlocked = $false

    do{
            [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
            [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

            $objForm = New-Object System.Windows.Forms.Form 
            $objForm.Text = "Digite Clave de Cifrado"
            $objForm.Size = New-Object System.Drawing.Size(300,200) 
            $objForm.StartPosition = "CenterScreen"

            $objForm.KeyPreview = $True
            $objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
                {$newComputerName=$objTextBox.Text;$objForm.Close()}})
            $objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
                {$objForm.Close()}})

        
            $OKButton = New-Object System.Windows.Forms.Button
            $OKButton.Location = New-Object System.Drawing.Size(75,120)
            $OKButton.Size = New-Object System.Drawing.Size(75,23)
            $OKButton.Text = "OK"
            $OKButton.Add_Click{
            if(!$objTextBox.Text){
                        [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
                        [System.Windows.Forms.MessageBox]::Show("Debe ingresar una Clave")
                    }else{
                        $manageBDEParameters = "-unlock W: -recoverypassword " + $objTextBox.Text
                        #[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
                        #[System.Windows.Forms.MessageBox]::Show($manageBDEParameters)
                        Start-Process "manage-bde.exe" -argumentlist $manageBDEParameters -nonewwindow -RedirectStandardOutput $manageBdeOutput -wait
                        
                        $decryptResult = get-content $manageBdeOutput
                        
                        foreach ($line in $decryptResult){
                            $result = $line | Select-String -Pattern "successfully unlocked" -quiet

                            if ($result){
                                [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
                                [System.Windows.Forms.MessageBox]::Show("Correctamente Descifrado")
                                #$global:hasBeenDecoded = $True
                                #set-variable -name hasBeenDecoded -value $true -scope global
                                $hasBeenDecoded = $true
                                $objForm.Close()
                                
                            }   
                        }
                        if ($result -eq $false){
                            [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
                            [System.Windows.Forms.MessageBox]::Show("Hubo un Error Descrifrando el archivo comience el proceso nuevamente")
            
                        }
                         }
                        
                    
            }

            $objForm.Controls.Add($OKButton)

            $objLabel = New-Object System.Windows.Forms.Label
            $objLabel.Location = New-Object System.Drawing.Size(10,20) 
            $objLabel.Size = New-Object System.Drawing.Size(280,20) 
            $objLabel.Text = "Escriba la clave:"
            $objForm.Controls.Add($objLabel) 

            $objTextBox = New-Object System.Windows.Forms.TextBox 
            $objTextBox.Location = New-Object System.Drawing.Size(10,40) 
            $objTextBox.Size = New-Object System.Drawing.Size(260,20) 
            $objForm.Controls.Add($objTextBox) 
            $objForm.Topmost = $True
            $objForm.Add_Shown({$objForm.Activate()})
            [void] $objForm.ShowDialog()

       
        
            }while ($hasBeenDecoded)

             

            $decryptResult = get-content $manageBdeOutput
            $result = $false
            $foundAndDecrypt = $false
            foreach ($line in $decryptResult ){
                            $result = $line | Select-String -Pattern "successfully unlocked" -quiet
                            if ($result){
                                $foundAndDecrypt = $True
                                }
                    }
            if ($foundAndDecrypt){
                
                                #$manageBDEDisableParameters = "-protectors -disable W:"
                                
                
                                #Start-Process "manage-bde.exe" -argumentlist $manageBDEDisableParameters -nonewwindow -wait

                                $osPath = "W:\*"
                                $usbOSPath = $operatingSystemsFolder

                                $copyingScripts = "W:\*.ps1"
                                $scriptsFolder = $assignUSBLetter + "\Deploy\Scripts"

                                Copy-Item $copyingScripts -Destination $scriptsFolder -Force


                                cd $assignUSBLetter
                                $deployUSB = $assignUSBLetter + "\deploy"
                                cd $deployUSB 
                                $OSUSB = $deployUSB + "\Operating Systems"
                                cd $OSUSB
                                $finalImagePath = $OSUSB + "\3202015"
                                cd $finalImagePath
                                pwd
                                $dir = dir

                                #$scriptsDir = $deployUSB +"\Scripts"

                                copy-Item $osPath -Destination ".\" -force
                                #move-Item ".\" -Destination $scriptsDir -force

                                [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
                                [System.Windows.Forms.MessageBox]::Show("Descifrado Exitoso")
            }


    }

    Dismount-DiskImage -ImagePath $pathToVHD -StorageType VHD
    
    