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

function ConvertTo-DoPxObject {
    [CmdletBinding()]
    [OutputType('digitalocean.object')]
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $InputObject,

        [Parameter(Position=1, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Property,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $TypePrefix = 'digitalocean'
    )
    begin {
        try {
            #region Turn down strict mode so that we can use JSON data without validating member existence first.

            Set-StrictMode -Version 1

            #endregion
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
    process {
        try {
            foreach ($item in $InputObject) {
                foreach ($propertyItem in $item.$Property) {
                    #region If the property is a PSCustomObject, add type information to it.

                    if ($propertyItem -is [System.Management.Automation.PSCustomObject]) {
                        #region Identify the type name by combining the prefix and the property.

                        $typeName = "${TypePrefix}.$($Property -replace '_|s$')"

                        #endregion

                        #region Convert nested properties as well if they are arrays or of type PSCustomObject.

                        foreach ($member in $propertyItem.PSObject.Properties) {
                            if ($member.TypeNameOfValue -eq 'System.Object[]') {
                                $propertyItem.$($member.Name) = @(ConvertTo-DoPxObject -InputObject $propertyItem -Property $member.Name -TypePrefix $typeName)
                            } else { #if ($property.TypeNameOfValue -eq 'System.Management.Automation.PSCustomObject') {
                                $propertyItem.$($member.Name) = ConvertTo-DoPxObject -InputObject $propertyItem -Property $member.Name -TypePrefix $typeName
                            }
                        }

                        #endregion

                        #region Set the type information that is desired for all PSCustomObjects.

                        $propertyItem.PSTypeNames.Clear()
                        Add-Member -InputObject $propertyItem -TypeName 'digitalocean.object'
                        if (@('digitalocean.backup','digitalocean.snapshot') -contains $typeName) {
                            Add-Member -InputObject $propertyItem -TypeName 'digitalocean.image'
                        }
                        Add-Member -InputObject $propertyItem -TypeName $typeName

                        #endregion
                    }

                    #endregion

                    #region If the property is a string in datetime format, convert it and return it to the caller.

                    if (($propertyItem -is [System.String]) -and
                        ($propertyItem -match '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$')) {
                        $propertyItem = $propertyItem -as [System.DateTime]
                    }

                    #endregion

                    #region Return the property value back to the caller.

                    $propertyItem

                    #endregion
                }
            }
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}