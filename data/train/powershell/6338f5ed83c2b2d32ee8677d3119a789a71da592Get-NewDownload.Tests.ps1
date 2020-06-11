$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
Import-Module "$here\..\NZB-Powershell" -Force

Describe "Get-NewDownload" {
    It "Respects Maximum Size" {
        $cancelled = "Download cancelled due to being too large"
       (Get-NewDownload -searchString "Daily Show" -GetLatest -maxSize 1 -documentDBLocation $documentDBLocation) | Should match $cancelled
    }
    It "Finds Latest Item" {
        $match = "The.Daily.Show."
       Get-NewDownload -searchString "Daily Show" -GetLatest -maxSize 1 -documentDBLocation $documentDBLocation | Should match $cancelled
    }
}


