#Run unit tests in current script file
function Global:Run-CurrentTestFile
{
    
    PSUnit.Run.ps1 -PSUnitTestFile $($psISE.CurrentOpenedFile.FullPath) -ShowReportInBrowser
}
$null = $psISE.CustomMenu.Submenus.Add("Run Unit Tests", {Run-CurrentTestFile}, 'Ctrl+SHIFT+R')