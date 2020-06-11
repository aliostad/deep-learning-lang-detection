
function BackupConfigs-VSSettings([string] $backupPath)
{
    copyFiletoFolder ($env:userprofile + "\Documents\Visual Studio 2013\Settings\CurrentSettings.vssettings") ($backupPath + "\vs2013settings")
    copyFiletoFolder ($env:userprofile + "\Documents\Visual Studio 2012\Settings\CurrentSettings.vssettings") ($backupPath + "\vs2012settings")
}

function RestoreConfigs-VSSettings([string] $backupPath)
{
    copyFiletoFolder ($backupPath + "\vs2013settings\CurrentSettings.vssettings") ($env:userprofile + "\Documents\Visual Studio 2013\Settings") 
    copyFiletoFolder ($backupPath + "\vs2012settings\CurrentSettings.vssettings") ($env:userprofile + "\Documents\Visual Studio 2012\Settings") 
}
