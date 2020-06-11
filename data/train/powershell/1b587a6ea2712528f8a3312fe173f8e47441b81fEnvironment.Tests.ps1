Describe -Tag "Environment" "Making sure the environment is ready to run the build scripts" {
    It @"
Is Powershell Version 3.0?
    This project requires Powershell 3.0.
    
    You can download the installer here: 
    (http://www.microsoft.com/en-us/download/details.aspx?id=34595)
"@  {
        $PSVersionTable["PSVersion"].Major | should be 3
    }

    It @"
Is the Java executable available?
    We'll need java in order to run Liquibase.
    (http://www.java.com/en/download/index.jsp)
"@  {
        @($env:Path.Split(";") | where {
            Test-Path (Join-Path $_ "java.Exe")
        }).Length -gt 0 | should be $true
    }

    It @"
Is MSBuild available?
    If this test fails, it is because the msbuild.exe has not been included in this machine's
    'Path' environment variable.  
    
    Add the location of msbuild.exe to the machine's 'Path' environment variable and run
    this test again.
"@  {
        @($env:Path.Split(";") | where {
            Test-Path (Join-Path $_ "MSBuild.Exe")
        }).Length -gt 0 | should be $true
    }

    It @"
Is MSBuild version 4.0?
    If this test fails, it is because the msbuild.exe that is available to the command line
    is not version 4.0.  This project needs access to the 4.0 version of msbuild.exe.
"@  {
        (msbuild /nologo /version) | out-file "TestDrive:\msbuildversion.txt"
        $version = get-content "TestDrive:\msbuildversion.txt"
        
        $version.StartsWith("4.0") | should be $true
    }

    It @"
Is SqlPS Available?
    SQLPS is the powershell module used to manage and interact with sql.
    
    http://msdn.microsoft.com/en-us/library/hh231286.aspx
"@  {
        @(get-module SQLPS -listavailable).Length -gt 0 | should be $true
    }

    It @"
Does an SQLExpress instance of MS SQL exist on this box?
    We need to be able to test our database stuff, and we'll do that against the local
    instance of MS SQL on this machine.
"@  {
        if(@(get-module SQLPS -listavailable).Length -gt 0)
        {
            $location = get-location
            import-module SQLPS 3> $null #Notice I'm supressing the warning message on import.
            set-location $location
        }
        Test-Path "SQLSERVER:\SQL\localhost\default\" | should be $true
    }

    It @"
Is Doxygen available?

If this test fails it is because Doxygen.exe needs to be added to the Path environment variable.
http://www.stack.nl/~dimitri/doxygen/download.html#srcbin
"@  {
        @($env:Path.Split(";") | where {
            Test-Path (Join-Path $_ "Doxygen.Exe")
        }).Length -gt 0 | should be $true
    }

    It @"
Is NuGet Available?

If this test fails, then you need to make sure that nuget.exe is available via the Path environment variable.
http://nuget.codeplex.com/downloads/get/697144
"@  {
        @($env:Path.Split(";") | where {
            Test-Path (Join-Path $_ "nuget.Exe")
        }).Length -gt 0 | should be $true
    }
}