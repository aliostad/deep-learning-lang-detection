<#############################################################################
The DoPx module provides a rich set of commands that extend the automation
capabilities of the DigitalOcean (DO) cloud service. These commands make it
easier to manage your DigitalOcean environment from Windows PowerShell. When
used with the LinuxPx module, you can manage your entire DigitalOcean
environment from one shell.

Copyright 2014 Kirk Munro

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#############################################################################>

@{
      ModuleToProcess = 'DoPx.psm1'

        ModuleVersion = '1.0.0.8'

                 GUID = '2aa000e6-a689-4443-a34e-20be26bfdabb'

               Author = 'Kirk Munro'

          CompanyName = 'Poshoholic Studios'

            Copyright = 'Copyright 2014 Kirk Munro'

          Description = 'The DoPx module provides a rich set of commands that extend the automation capabilities of the DigitalOcean (DO) cloud service. These commands make it easier to manage your DigitalOcean environment from Windows PowerShell. When used with the LinuxPx module, you can manage your entire DigitalOcean environment from one shell.'

    PowerShellVersion = '4.0'

      RequiredModules = @(
                        #'LinuxPx' integration coming soon
                        'TypePx'
                        )

        NestedModules = @(
                        'SnippetPx'
                        )

    FunctionsToExport = @(
                        'Add-DoPxDomain'
                        'Add-DoPxDnsRecord'
                        'Add-DoPxSshKey'
                        'Clear-DoPxDefaultAccessToken'
                        'Copy-DoPxBackup'
                        'Copy-DoPxSnapshot'
                        'Disable-DoPxDropletOption'
                        'Enable-DoPxDropletOption'
                        'Get-DoPxAction'
                        'Get-DoPxBackup'
                        'Get-DoPxDefaultAccessToken'
                        'Get-DoPxDomain'
                        'Get-DoPxDnsRecord'
                        'Get-DoPxDroplet'
                        'Get-DoPxImage'
                        'Get-DoPxKernel'
                        'Get-DoPxRegion'
                        'Get-DoPxSize'
                        'Get-DoPxSnapshot'
                        'Get-DoPxSshKey'
                        'New-DoPxDroplet'
                        'New-DoPxSnapshot'
                        'Receive-DoPxAction'
                        'Remove-DoPxBackup'
                        'Remove-DoPxDomain'
                        'Remove-DoPxDnsRecord'
                        'Remove-DoPxDroplet'
                        'Remove-DoPxSnapshot'
                        'Remove-DoPxSshKey'
                        'Rename-DoPxBackup'
                        'Rename-DoPxDnsRecord'
                        'Rename-DoPxDroplet'
                        'Rename-DoPxSnapshot'
                        'Rename-DoPxSshKey'
                        'Reset-DoPxDroplet'
                        'Resize-DoPxDroplet'
                        'Restart-DoPxDroplet'
                        'Restore-DoPxBackup'
                        'Restore-DoPxSnapshot'
                        'Set-DoPxDefaultAccessToken'
                        'Start-DoPxDroplet'
                        'Stop-DoPxDroplet'
                        'Update-DoPxKernel'
                        'Wait-DoPxAction'
                        )

             FileList = @(
                        'DoPx.psd1'
                        'DoPx.psm1'
                        'LICENSE'
                        'NOTICE'
                        'functions\Add-DoPxDomain.ps1'
                        'functions\Add-DoPxDnsRecord.ps1'
                        'functions\Add-DoPxSshKey.ps1'
                        'functions\Clear-DoPxDefaultAccessToken.ps1'
                        'functions\Copy-DoPxBackup.ps1'
                        'functions\Copy-DoPxSnapshot.ps1'
                        'functions\Disable-DoPxDropletOption.ps1'
                        'functions\Enable-DoPxDropletOption.ps1'
                        'functions\Get-DoPxAction.ps1'
                        'functions\Get-DoPxDefaultAccessToken.ps1'
                        'functions\Get-DoPxBackup.ps1'
                        'functions\Get-DoPxDomain.ps1'
                        'functions\Get-DoPxDnsRecord.ps1'
                        'functions\Get-DoPxDroplet.ps1'
                        'functions\Get-DoPxImage.ps1'
                        'functions\Get-DoPxKernel.ps1'
                        'functions\Get-DoPxRegion.ps1'
                        'functions\Get-DoPxSize.ps1'
                        'functions\Get-DoPxSnapshot.ps1'
                        'functions\Get-DoPxSshKey.ps1'
                        'functions\New-DoPxDroplet.ps1'
                        'functions\New-DoPxSnapshot.ps1'
                        'functions\Receive-DoPxAction.ps1'
                        'functions\Remove-DoPxDomain.ps1'
                        'functions\Remove-DoPxDnsRecord.ps1'
                        'functions\Remove-DoPxBackup.ps1'
                        'functions\Remove-DoPxDroplet.ps1'
                        'functions\Remove-DoPxSnapshot.ps1'
                        'functions\Remove-DoPxSshKey.ps1'
                        'functions\Rename-DoPxBackup.ps1'
                        'functions\Rename-DoPxDnsRecord.ps1'
                        'functions\Rename-DoPxDroplet.ps1'
                        'functions\Rename-DoPxSnapshot.ps1'
                        'functions\Rename-DoPxSshKey.ps1'
                        'functions\Reset-DoPxDroplet.ps1'
                        'functions\Resize-DoPxDroplet.ps1'
                        'functions\Restart-DoPxDroplet.ps1'
                        'functions\Restore-DoPxBackup.ps1'
                        'functions\Restore-DoPxSnapshot.ps1'
                        'functions\Set-DoPxDefaultAccessToken.ps1'
                        'functions\Start-DoPxDroplet.ps1'
                        'functions\Stop-DoPxDroplet.ps1'
                        'functions\Update-DoPxKernel.ps1'
                        'functions\Wait-DoPxAction.ps1'
                        'helpers\ConvertTo-DoPxObject.ps1'
                        'helpers\Get-DoPxObject.ps1'
                        'helpers\Get-DoPxWebRequestHeader.ps1'
                        'helpers\Invoke-DoPxObjectAction.ps1'
                        'helpers\Invoke-DoPxWebRequest.ps1'
                        'helpers\New-DoPxObject.ps1'
                        'helpers\Remove-DoPxObject.ps1'
                        'helpers\Set-DoPxObject.ps1'
                        )

          PrivateData = @{
                            PSData = @{
                                Tags = 'DigitalOcean cloud virtual machine droplet IaaS'
                                LicenseUri = 'http://apache.org/licenses/LICENSE-2.0.txt'
                                ProjectUri = 'https://github.com/KirkMunro/DoPx'
                                IconUri = ''
                                ReleaseNotes = 'This module is based on version 2 of the DigitalOcean API.'
                            }
                        }
}