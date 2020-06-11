#requires -version 3.0

#create the constrained session configuration file
New-PSSessionConfigurationFile -Path C:\Scripts\ConstrainTest.pssc `
                               -Description 'Chapter 27 lab' `
                               -ExecutionPolicy Restricted `
                               -ModulesToImport SMBShare `
                               -PowerShellVersion 3.0 `
                               -VisibleFunctions 'Get-SMBShare'`
                               -SessionType RestrictedRemoteServer

#register a new session with the file                               
Register-PSSessionConfiguration -Path C:\Scripts\ConstrainTest.pssc `
                                -Name ConstrainTest `
                                -ShowSecurityDescriptorUI `
                                -AccessMode Remote `
                                -RunAsCredential Administrator

