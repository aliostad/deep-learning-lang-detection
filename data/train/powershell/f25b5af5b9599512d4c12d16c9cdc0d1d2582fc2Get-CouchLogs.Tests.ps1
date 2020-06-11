$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Import-Module "$here\..\NZB-Powershell" -Force


Describe "Get-CouchLogs" {
    It "Should return log entries" {
        (Get-CouchLogs -couchURL $CouchURL -couchApiKey $couchKey) | Should not be $null
    }
    It "Should change entries into objects" {
        ((Get-CouchLogs -couchURL $CouchURL -couchApiKey $couchKey -lines 7)[0] | Get-Member | Where-Object {$_.MemberType -like "Property"}).count | Should Be 4
    }
    It "Should return the correct number of entries" {
        (Get-CouchLogs -couchURL $CouchURL -couchApiKey $couchKey -lines 7).count | Should Be 7
    }
    It "Should return the correct type of entries" {
        (Get-CouchLogs -couchURL $CouchURL -couchApiKey $couchKey -logtype ERROR)[0].type | Should match "ERROR"
    }
}
