#######################################################################################
#  cDFSRepGroupMembership : This resource is used to configure Replication Group Folder
#  Membership. It is usually used to set the **ContentPath** for each Replication Group
#  folder on each Member computer. It can also be used to set additional properties of
#  the Membership.
#######################################################################################
 
data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData -StringData @'
GettingRepGroupMembershipMessage=Getting DFS Replication Group "{0}" folder "{1}" on "{2}".
RepGroupMembershipExistsMessage=DFS Replication Group "{0}" folder "{1}" on "{2}" exists.
RepGroupMembershipMissingError=DFS Replication Group "{0}" folder "{1}" on "{2}" is missing.
SettingRegGroupMembershipMessage=Setting DFS Replication Group "{0}" folder "{1}" on "{2}".
RepGroupMembershipUpdatedMessage=DFS Replication Group "{0}" folder "{1}" on "{2}" has has been updated.
TestingRegGroupMembershipMessage=Testing DFS Replication Group "{0}" folder "{1}" on "{2}".
RepGroupMembershipContentPathMismatchMessage=DFS Replication Group "{0}" folder "{1}" on "{2}" has incorrect ContentPath. Change required.
RepGroupMembershipStagingPathMismatchMessage=DFS Replication Group "{0}" folder "{1}" on "{2}" has incorrect StagingPath. Change required.
RepGroupMembershipReadOnlyMismatchMessage=DFS Replication Group "{0}" folder "{1}" on "{2}" has incorrect ReadOnly. Change required.
RepGroupMembershipPrimaryMemberismatchMessage=DFS Replication Group "{0}" folder "{1}" on "{2}" has incorrect PrimaryMember. Change required.
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

        [parameter(Mandatory = $true)]
        [String]
        $ComputerName,

        [String]
        $DomainName
    )
    
    Write-Verbose -Message ( @(
        "$($MyInvocation.MyCommand): "
        $($LocalizedData.GettingRepGroupMembershipMessage) `
            -f $GroupName,$FolderName,$ComputerName,$DomainName
        ) -join '' )

    # Lookup the existing Replication Group
    $Splat = @{ GroupName = $GroupName; ComputerName = $ComputerName }
    $returnValue = $Splat
    if ($DomainName) {
        $Splat += @{ DomainName = $DomainName }
    }
    $returnValue += @{ FolderName = $FolderName }
    $RepGroupMembership = Get-DfsrMembership @Splat -ErrorAction Stop `
        | Where-Object { $_.FolderName -eq $FolderName }
    if ($RepGroupMembership) {
        Write-Verbose -Message ( @(
            "$($MyInvocation.MyCommand): "
            $($LocalizedData.RepGroupMembershipExistsMessage) `
                -f $GroupName,$FolderName,$ComputerName,$DomainName
            ) -join '' )
        $returnValue += @{
            ContentPath = $RepGroupMembership.ContentPath
            StagingPath = $RepGroupMembership.StagingPath
            ConflictAndDeletedPath = $RepGroupMembership.ConflictAndDeletedPath
            ReadOnly = $RepGroupMembership.ReadOnly
            PrimaryMember = $RepGroupMembership.PrimaryMember
            DomainName = $RepGroupMembership.DomainName
        }
    } Else {       
        # The Rep Group membership doesn't exist
        $errorId = 'RegGroupMembershipMissingError'
        $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidOperation
        $errorMessage = $($LocalizedData.RepGroupMembershipMissingError) `
            -f $GroupName,$FolderName,$ComputerName,$DomainName
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

        [parameter(Mandatory = $true)]
        [String]
        $ComputerName,

        [String]
        $ContentPath,

        [String]
        $StagingPath,

        [Boolean]
        $ReadOnly,

        [Boolean]
        $PrimaryMember,

        [String]
        $DomainName
    )

    Write-Verbose -Message ( @(
        "$($MyInvocation.MyCommand): "
        $($LocalizedData.SettingRegGroupMembershipMessage) `
            -f $GroupName,$FolderName,$ComputerName,$DomainName
        ) -join '' )

    # Now apply the changes
    Set-DfsrMembership @PSBoundParameters -ErrorAction Stop

    Write-Verbose -Message ( @(
        "$($MyInvocation.MyCommand): "
        $($LocalizedData.RepGroupMembershipUpdatedMessage) `
            -f $GroupName,$FolderName,$ComputerName,$DomainName
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

        [parameter(Mandatory = $true)]
        [String]
        $ComputerName,

        [String]
        $ContentPath,

        [String]
        $StagingPath,

        [Boolean]
        $ReadOnly,

        [Boolean]
        $PrimaryMember,

        [String]
        $DomainName
    )

    # Flag to signal whether settings are correct
    [Boolean] $desiredConfigurationMatch = $true

    Write-Verbose -Message ( @(
        "$($MyInvocation.MyCommand): "
        $($LocalizedData.TestingRegGroupMembershipMessage) `
            -f $GroupName,$FolderName,$ComputerName,$DomainName
        ) -join '' )

    # Lookup the existing Replication Group
    $Splat = @{ GroupName = $GroupName; ComputerName = $ComputerName }
    if ($DomainName) {
        $Splat += @{ DomainName = $DomainName }
    }
    $RepGroupMembership = Get-DfsrMembership @Splat -ErrorAction Stop `
        | Where-Object { $_.FolderName -eq $FolderName }
    if ($RepGroupMembership) {
        # The rep group folder is found
        Write-Verbose -Message ( @(
            "$($MyInvocation.MyCommand): "
            $($LocalizedData.RepGroupMembershipExistsMessage) `
                -f $GroupName,$FolderName,$ComputerName,$DomainName
            ) -join '' )

        # Check the ContentPath
        if (($PSBoundParameters.ContainsKey('ContentPath')) `
            -and ($RepGroupMembership.ContentPath -ne $ContentPath)) {
            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($LocalizedData.RepGroupMembershipContentPathMismatchMessage) `
                    -f $GroupName,$FolderName,$ComputerName,$DomainName
                ) -join '' )
            $desiredConfigurationMatch = $false
        }
        
        # Check the StagingPath
        if (($PSBoundParameters.ContainsKey('StagingPath')) `
            -and ($RepGroupMembership.StagingPath -ne $StagingPath)) {
            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($LocalizedData.RepGroupMembershipStagingPathMismatchMessage) `
                    -f $GroupName,$FolderName,$ComputerName,$DomainName
                ) -join '' )
            $desiredConfigurationMatch = $false
        }

        # Check the ReadOnly
        if (($PSBoundParameters.ContainsKey('ReadOnly')) `
            -and ($RepGroupMembership.ReadOnly -ne $ReadOnly)) {
            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($LocalizedData.RepGroupMembershipReadOnlyMismatchMessage) `
                    -f $GroupName,$FolderName,$ComputerName,$DomainName
                ) -join '' )
            $desiredConfigurationMatch = $false
        }

        # Check the PrimaryMember
        if (($PSBoundParameters.ContainsKey('PrimaryMember')) `
            -and ($RepGroupMembership.PrimaryMember -ne $PrimaryMember)) {
            Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($LocalizedData.RepGroupMembershipPrimaryMemberMismatchMessage) `
                    -f $GroupName,$FolderName,$ComputerName,$DomainName
                ) -join '' )
            $desiredConfigurationMatch = $false
        }

    } else {
        # The Rep Group membership doesn't exist
        $errorId = 'RegGroupMembershipMissingError'
        $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidOperation
        $errorMessage = $($LocalizedData.RepGroupMembershipMissingError) `
            -f $GroupName,$FolderName,$ComputerName,$DomainName
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