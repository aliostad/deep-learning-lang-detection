$ShowFwState = cmd /c Netsh AdvFirewall show allprofiles
cls

Write-Host ""
If ($ShowFwState[1] -eq "Une erreur s'est produite lors de la tentative de prise de contact avec"){
    Write-Host "Firewall Windows désactivé"
}
If ($ShowFwState[3] -eq "tat                                  Actif"){ 
    Write-Host "`nProfil de domaine: `t[Actif]"
}
If ($ShowFwState[20] -eq "tat                                  Actif"){ 
    Write-Host "`nProfil privé:`t[Actif]"
}
If ($ShowFwState[37] -eq "tat                                  Actif"){ 
    Write-Host "Profil public:`t`t[Actif]"
}

Write-Host ""