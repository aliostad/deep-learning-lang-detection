

#$machinelist =@("H3R-IOLWEB2","H3R-IOLWEB4","H3R-IOLWEB6","H3R-IOLWEB8")

#$machinelist =@("H3R-IOLWEB1","H3R-IOLWEB3","H3R-IOLWEB5","H3R-IOLWEB7","H3R-IOLWEB9")

$machinelist =@("DEV1-WEB1")

#The meat

$machinelist | foreach {
    $webmachine = $_ 
    $Username = 'HOMENET\autobuilder'
    $Password = 'stupidpassword'
    $pass = ConvertTo-SecureString -AsPlainText $Password -Force
    $Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass
    $appPoolPath="IIS:\AppPools\WebIOL"
    
    echo "******************************************************"
    echo $webmachine " - Setting Load User Profile Setting"
    echo "******************************************************"

    $Res = (Invoke-command -ComputerName $webmachine -ScriptBlock { import-module webadministration; Get-ItemProperty -Path "IIS:\AppPools\WebIOL"-Name "processModel.loadUserProfile"} -Credential $Cred)
    echo "Current load user profile set to " $Res.value
    
    Invoke-command -ComputerName $webmachine -ScriptBlock { import-module webadministration; Set-ItemProperty -Path "IIS:\AppPools\WebIOL"-Name "processModel.loadUserProfile" -Value true} -Credential $Cred

    $Res = (Invoke-command -ComputerName $webmachine -ScriptBlock { import-module webadministration; Get-ItemProperty -Path "IIS:\AppPools\WebIOL"-Name "processModel.loadUserProfile"} -Credential $Cred)
    echo "New load user profile set to " $Res.value

}