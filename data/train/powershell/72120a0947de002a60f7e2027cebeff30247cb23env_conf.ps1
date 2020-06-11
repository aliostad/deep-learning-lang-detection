
function BackupConfigs-Env_Conf([string] $backupPath)
{
    copyFiletoFolder ($env:userprofile + "\Documents\WindowsPowerShell\env-conf_profile.ps1") ($backupPath + "\env-conf")
    copy-item -rec -filter *.ps1 ($env:userprofile + "\Documents\WindowsPowerShell\env-conf\") ($backupPath) -force
}


function RestoreConfigs-Env_Conf([string] $backupPath)
{
    copyFiletoFolder ($backupPath + "\env-conf\env-conf_profile.ps1") ($env:userprofile + "\Documents\WindowsPowerShell")
    copy-item -rec -filter *.ps1 ($backupPath + "\env-conf\") ($env:userprofile + "\Documents\WindowsPowerShell") -force
}
