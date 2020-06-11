#######################################################################################
#  cFSRMFileGroup : DSC Resource for configuring FSRM File Groups.
#######################################################################################
 
data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData -StringData @'
GettingFileGroupMessage=Getting FSRM File Group "{0}".
FileGroupExistsMessage=FSRM File Group "{0}" exists.
FileGroupDoesNotExistMessage=FSRM File Group "{0}" does not exist.
SettingFileGroupMessage=Setting FSRM File Group "{0}".
EnsureFileGroupExistsMessage=Ensuring FSRM File Group "{0}" exists.
EnsureFileGroupDoesNotExistMessage=Ensuring FSRM File Group "{0}" does not exist.
FileGroupCreatedMessage=FSRM File Group "{0}" has been created.
FileGroupUpdatedMessage=FSRM File Group "{0}" has been updated.
FileGroupRemovedMessage=FSRM File Group "{0}" has been removed.
TestingFileGroupMessage=Testing FSRM File Group "{0}".
FileGroupDescriptionNeedsUpdateMessage=FSRM File Group "{0}" description is different. Change required.
FileGroupIncludePatternNeedsUpdateMessage=FSRM File Group "{0}" incude pattern is different. Change required.
FileGroupExcludePatternNeedsUpdateMessage=FSRM File Group "{0}" exclude pattern is different. Change required.
FileGroupDoesNotExistButShouldMessage=DFS Replication Group "{0}" does not exist but should. Change required.
FileGroupExistsButShouldNotMessage=DFS Replication Group "{0}" exists but should not. Change required.
FileGroupDoesNotExistAndShouldNotMessage=DFS Replication Group "{0}" does not exist and should not. Change not required.
'@
}

######################################################################################
# The Get-TargetResource cmdlet.
######################################################################################
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name
    )
    
    Write-Verbose -Message ( @(
        "$($MyInvocation.MyCommand): "
        $($LocalizedData.GettingFileGroupMessage) `
            -f $Name
        ) -join '' )

    $FileGroup =  Get-FileGroup -Name $Name

    $returnValue = @{
        Name = $Name
    }
    if ($FileGroup) {
        Write-Verbose -Message ( @(
            "$($MyInvocation.MyCommand): "
            $($LocalizedData.FileGroupExistsMessage) `
                -f $Name
            ) -join '' )

        $returnValue += @{
            Ensure = 'Present'
            Description = $FileGroup.Description
            IncludePattern = $FileGroup.IncludePattern
            ExcludePattern = $FileGroup.ExcludePattern
        }
    } else {
        Write-Verbose -Message ( @(
            "$($MyInvocation.MyCommand): "
            $($LocalizedData.FileGroupDoesNotExistMessage) `
                -f $Name
            ) -join '' )

        $returnValue += @{
            Ensure = 'Absent'
        }
    }

    $returnValue
} # Get-TargetResource

######################################################################################
# The Set-TargetResource cmdlet.
######################################################################################
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [System.String]
        $Description,

        [ValidateSet('Present','Absent')]
        [System.String]
        $Ensure = 'Present',

        [System.String[]]
        $IncludePattern = @(''),

        [System.String[]]
        $ExcludePattern = @('')
    )

    Write-Verbose -Message ( @(
        "$($MyInvocation.MyCommand): "
        $($LocalizedData.SettingFileGroupMessage) `
            -f $Name
        ) -join '' )

    # Remove any parameters that can't be splatted.
    $null = $PSBoundParameters.Remove('Ensure')

    # Lookup the existing file group
    $FileGroup = Get-FileGroup -Name $Name

    if ($Ensure -eq 'Present') {
        Write-Verbose -Message ( @(
            "$($MyInvocation.MyCommand): "
            $($LocalizedData.EnsureFileGroupExistsMessage) `
                -f $Name
            ) -join '' )

        if ($FileGroup) {
            # The file group exists
            Set-FSRMFileGroup @PSBoundParameters -ErrorAction Stop

            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($LocalizedData.FileGroupUpdatedMessage) `
                    -f $Name
                ) -join '' )
        } else {
            # Create the File Group
            New-FSRMFileGroup @PSBoundParameters -ErrorAction Stop

            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($LocalizedData.FileGroupCreatedMessage) `
                    -f $Name
                ) -join '' )
        }
    } else {
        Write-Verbose -Message ( @(
            "$($MyInvocation.MyCommand): "
            $($LocalizedData.EnsureFileGroupDoesNotExistMessage) `
                -f $Name
            ) -join '' )

        if ($FileGroup) {
            # The File Group shouldn't exist - remove it
            Remove-FSRMFileGroup -Name $Name -ErrorAction Stop

            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($LocalizedData.FileGroupRemovedMessage) `
                    -f $Name
                ) -join '' )
        } # if
    } # if
} # Set-TargetResource

######################################################################################
# The Test-TargetResource cmdlet.
######################################################################################
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [System.String]
        $Description,

        [ValidateSet('Present','Absent')]
        [System.String]
        $Ensure = 'Present',

        [System.String[]]
        $IncludePattern = @(''),

        [System.String[]]
        $ExcludePattern = @('')
    )
    # Flag to signal whether settings are correct
    [Boolean] $desiredConfigurationMatch = $true

    Write-Verbose -Message ( @(
        "$($MyInvocation.MyCommand): "
        $($LocalizedData.TestingFileGroupMessage) `
            -f $Name
        ) -join '' )

    # Lookup the existing file group
    $FileGroup = Get-FileGroup -Name $Name

    if ($Ensure -eq 'Present') {
        # The File Group should exist
        if ($FileGroup) {
            # The File Group exists already - check the parameters
            if (($Description) -and ($FileGroup.Description -ne $Description)) {
                Write-Verbose -Message ( @(
                    "$($MyInvocation.MyCommand): "
                    $($LocalizedData.FileGroupDescriptionNeedsUpdateMessage) `
                        -f $Name
                    ) -join '' )
                $desiredConfigurationMatch = $false
            }

            if (($IncludePattern) -and (Compare-Object `
                -ReferenceObject $IncludePattern `
                -DifferenceObject $FileGroup.IncludePattern).Count -ne 0) {
                Write-Verbose -Message ( @(
                    "$($MyInvocation.MyCommand): "
                    $($LocalizedData.FileGroupIncludePatternNeedsUpdateMessage) `
                        -f $Name
                    ) -join '' )
                $desiredConfigurationMatch = $false
            }

            if (($ExcludePattern) -and (Compare-Object `
                -ReferenceObject $ExcludePattern `
                -DifferenceObject $FileGroup.ExcludePattern).Count -ne 0) {
                Write-Verbose -Message ( @(
                    "$($MyInvocation.MyCommand): "
                    $($LocalizedData.FileGroupExcludePatternNeedsUpdateMessage) `
                        -f $Name
                    ) -join '' )
                $desiredConfigurationMatch = $false
            }
        } else {
            # Ths File Group doesn't exist but should
            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                 $($LocalizedData.FileGroupDoesNotExistButShouldMessage) `
                    -f  $Name
                ) -join '' )
            $desiredConfigurationMatch = $false
        }
    } else {
        # The File Group should not exist
        if ($FileGroup) {
            # The File Group exists but should not
            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                 $($LocalizedData.FileGroupExistsButShouldNotMessage) `
                    -f  $Name
                ) -join '' )
            $desiredConfigurationMatch = $false
        } else {
            # The File Group does not exist and should not
            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                 $($LocalizedData.FileGroupDoesNotExistAndShouldNotMessage) `
                    -f  $Name
                ) -join '' )
        }
    } # if
    return $desiredConfigurationMatch
} # Test-TargetResource

######################################################################################
# Helper Functions
######################################################################################
Function Get-FileGroup {
    param (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name
    )
    try {
        $FileGroup = Get-FSRMFileGroup -Name $Name -ErrorAction Stop
    }
    catch [Microsoft.PowerShell.Cmdletization.Cim.CimJobException] {
        $FileGroup = $null
    }
    catch {
        Throw $_
    }
    Return $FileGroup
}
######################################################################################

Export-ModuleMember -Function *-TargetResource