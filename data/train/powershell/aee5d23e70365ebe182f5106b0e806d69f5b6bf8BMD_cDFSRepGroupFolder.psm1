#######################################################################################
#  cDFSRepGroupFolder : This resource is used to create, edit or remove DFS Replication
#  Group folders. It should be combined with the cDFSRepGroup and
#  cDFSRepGroupMembership resources.
#######################################################################################
 
data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData -StringData @'
GettingRepGroupFolderMessage=Getting DFS Replication Group "{0}" folder "{1}".
RepGroupFolderExistsMessage=DFS Replication Group "{0}" folder "{1}" exists.
RepGroupFolderMissingError=DFS Replication Group "{0}" folder "{1}" is missing.
SettingRegGroupFolderMessage=Setting DFS Replication Group "{0}" folder "{1}".
RepGroupFolderUpdatedMessage=DFS Replication Group "{0}" folder "{1}" has has been updated.
TestingRegGroupFolderMessage=Testing DFS Replication Group "{0}" folder "{1}".
RepGroupFolderDescriptionMismatchMessage=DFS Replication Group "{0}" folder "{1}" has incorrect Description. Change required.
RepGroupFolderFileNameToExcludeMismatchMessage=DFS Replication Group "{0}" folder "{1}" has incorrect FileNameToExclude. Change required.
RepGroupFolderDirectoryNameToExcludeMismatchMessage=DFS Replication Group "{0}" folder "{1}" has incorrect DirectoryNameToExclude. Change required.
RepGroupFolderDfsnPathMismatchMessage=DFS Replication Group "{0}" folder "{1}" has incorrect DfsnPath. Change required.
'@
}


######################################################################################
# The Get-TargetResource cmdlet.
######################################################################################
function Get-TargetResource
{
    [OutputType([Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [String]
        $GroupName,

        [parameter(Mandatory = $true)]
        [String]
        $FolderName,

        [String]
        $DomainName
    )
    
    Write-Verbose -Message ( @(
        "$($MyInvocation.MyCommand): "
        $($LocalizedData.GettingRepGroupFolderMessage) `
            -f $GroupName,$FolderName,$DomainName
        ) -join '' )

    # Lookup the existing Replication Group
    $Splat = @{ GroupName = $GroupName; FolderName = $FolderName }
    $returnValue = $splat.Clone()
    if ($DomainName) {
        $Splat += @{ DomainName = $DomainName }
    }
    $RepGroupFolder = Get-DfsReplicatedFolder @Splat -ErrorAction Stop
    if ($RepGroupFolder) {
        Write-Verbose -Message ( @(
            "$($MyInvocation.MyCommand): "
            $($LocalizedData.RepGroupFolderExistsMessage) `
                -f $GroupName,$FolderName,$DomainName
            ) -join '' )
        $returnValue += @{
            Description = $RepGroupFolder.Description
            FilenameToExclude = $RepGroupFolder.FilenameToExclude
            DirectoryNameToExclude = $RepGroupFolder.DirectoryNameToExclude
            DfsnPath = $RepGroupFolder.DfsnPath
            DomainName = $RepGroupFolder.DomainName
        }
    } Else {       
        # The Rep Group folder doesn't exist
        $errorId = 'RegGroupFolderMissingError'
        $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidOperation
        $errorMessage = $($LocalizedData.RepGroupFolderMissingError) `
            -f $GroupName,$FolderName,$DomainName
        $exception = New-Object -TypeName System.InvalidOperationException `
            -ArgumentList $errorMessage
        $errorRecord = New-Object -TypeName System.Management.Automation.ErrorRecord `
            -ArgumentList $exception, $errorId, $errorCategory, $null

        $PSCmdlet.ThrowTerminatingError($errorRecord)
    }

    $returnValue
} # Get-TargetResource

######################################################################################
# The Set-TargetResource cmdlet.
######################################################################################
function Set-TargetResource
{
    param
    (
        [parameter(Mandatory = $true)]
        [String]
        $GroupName,

        [parameter(Mandatory = $true)]
        [String]
        $FolderName,

        [String]
        $Description,

        [String[]]
        $FileNameToExclude,

        [String[]]
        $DirectoryNameToExclude,

        [String]
        $DfsnPath,

        [String]
        $DomainName
    )

    Write-Verbose -Message ( @(
        "$($MyInvocation.MyCommand): "
        $($LocalizedData.SettingRegGroupFolderMessage) `
            -f $GroupName,$FolderName,$DomainName
        ) -join '' )

    # Now apply the changes
    Set-DfsReplicatedFolder @PSBoundParameters -ErrorAction Stop

    Write-Verbose -Message ( @(
        "$($MyInvocation.MyCommand): "
        $($LocalizedData.RepGroupFolderUpdatedMessage) `
            -f $GroupName,$FolderName,$DomainName
        ) -join '' )

} # Set-TargetResource

######################################################################################
# The Test-TargetResource cmdlet.
######################################################################################
function Test-TargetResource
{
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [String]
        $GroupName,

        [parameter(Mandatory = $true)]
        [String]
        $FolderName,

        [String]
        $Description,

        [String[]]
        $FileNameToExclude,

        [String[]]
        $DirectoryNameToExclude,

        [String]
        $DfsnPath,

        [String]
        $DomainName
    )

    # Flag to signal whether settings are correct
    [Boolean] $desiredConfigurationMatch = $true

    Write-Verbose -Message ( @(
        "$($MyInvocation.MyCommand): "
        $($LocalizedData.TestingRegGroupFolderMessage) `
            -f $GroupName,$FolderName,$DomainName
        ) -join '' )

    # Lookup the existing Replication Group Folder
    $Splat = @{ GroupName = $GroupName; FolderName = $FolderName }
    if ($DomainName) {
        $Splat += @{ DomainName = $DomainName }
    }
    $RepGroupFolder = Get-DfsReplicatedFolder @Splat -ErrorAction Stop

    if ($RepGroupFolder) {
        # The rep group folder is found
        Write-Verbose -Message ( @(
            "$($MyInvocation.MyCommand): "
            $($LocalizedData.RepGroupFolderExistsMessage) `
                -f $GroupName,$FolderName,$DomainName
            ) -join '' )

        # Check the description
        if (($PSBoundParameters.ContainsKey('Description')) `
            -and ($RepGroupFolder.Description -ne $Description)) {
            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($LocalizedData.RepGroupFolderDescriptionMismatchMessage) `
                    -f $GroupName,$FolderName,$DomainName
                ) -join '' )
            $desiredConfigurationMatch = $false
        }
        
        # Check the FileNameToExclude
        if (($PSBoundParameters.ContainsKey('FileNameToExclude')) `
            -and ((Compare-Object `
                -ReferenceObject  $RepGroupFolder.FileNameToExclude `
                -DifferenceObject $FileNameToExclude).Count -ne 0)) {
            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($LocalizedData.RepGroupFolderFileNameToExcludeMismatchMessage) `
                    -f $GroupName,$FolderName,$DomainName
                ) -join '' )
            $desiredConfigurationMatch = $false
        }

        # Check the DirectoryNameToExclude
        if (($PSBoundParameters.ContainsKey('DirectoryNameToExclude')) `
            -and ((Compare-Object `
                -ReferenceObject  $RepGroupFolder.DirectoryNameToExclude `
                -DifferenceObject $DirectoryNameToExclude).Count -ne 0)) {
            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($LocalizedData.RepGroupFolderDirectoryNameToExcludeMismatchMessage) `
                    -f $GroupName,$FolderName,$DomainName
                ) -join '' )
            $desiredConfigurationMatch = $false
        }

        if (($PSBoundParameters.ContainsKey('DfsnPath')) `
            -and ($RepGroupFolder.DfsnPath -ne $DfsnPath)) {
            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($LocalizedData.RepGroupFolderDfsnPathMismatchMessage) `
                    -f $GroupName,$FolderName,$DomainName
                ) -join '' )
            $desiredConfigurationMatch = $false
        }
    } else {
        # The Rep Group folder doesn't exist
        $errorId = 'RegGroupFolderMissingError'
        $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidOperation
        $errorMessage = $($LocalizedData.RepGroupFolderMissingError) `
            -f $GroupName,$FolderName,$DomainName
        $exception = New-Object -TypeName System.InvalidOperationException `
            -ArgumentList $errorMessage
        $errorRecord = New-Object -TypeName System.Management.Automation.ErrorRecord `
            -ArgumentList $exception, $errorId, $errorCategory, $null

        $PSCmdlet.ThrowTerminatingError($errorRecord)
    }

    return $desiredConfigurationMatch
} # Test-TargetResource
######################################################################################

Export-ModuleMember -Function *-TargetResource