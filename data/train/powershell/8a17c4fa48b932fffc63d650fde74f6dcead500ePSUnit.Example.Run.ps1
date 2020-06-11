Set-DebugMode



#Launch PSUnit test runner
PSUnit.Run.ps1 -PSUnitTestFile (Join-Path -Path $Env:PSUNIT_HOME -ChildPath PSUnit.Example.Test.ps1) -ShowReportInBrowser

#Launch PSUnit test runner with Category "FastTests"
PSUnit.Run.ps1 -PSUnitTestFile (Join-Path -Path $Env:PSUNIT_HOME -ChildPath PSUnit.Example.Test.ps1) -ShowReportInBrowser -Category "FastTests"
