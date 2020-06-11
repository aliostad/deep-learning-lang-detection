function MaKoe_SearchInAllObjects($databaseServer, $database, $objectPath, $objectsFilter,$SearchString, $LogPath, $showGrid)
{
    $sourcepath = Join-Path $objectPath '\MyObjects' 
    $NAVobjects = Join-Path $objectPath 'NAVobjects.txt'
    # $LogPath = Join-Path $objectPath '\log\whereused.txt'

    Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1"

    if ($objectsFilter -eq '')
    {
        Export-NAVApplicationObject -ExportTxtSkipUnlicensed -DatabaseName $database -DatabaseServer $databaseServer -Path $NAVobjects 
    } else
    {
        Export-NAVApplicationObject -ExportTxtSkipUnlicensed -DatabaseName $database -DatabaseServer $databaseServer -Path $NAVobjects -Filter $objectsFilter 
    }

    # objectsplit
    split-navapplicationobjectfile -Source $NAVobjects -Destination $sourcepath -PassThru -Force
    $myobjects = Get-ChildItem -Path $sourcepath -Filter *txt -File

    # cls 
    if ($LogPath)
    {
        $myobjects | Select-String $SearchString | Out-File –Filepath $LogPath
    }

    if ($showGrid)
    {
        $myobjects | Select-String $SearchString | Out-GridView 
    }
}




