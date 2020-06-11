#
# PoshRack_Compute.psm1
#
function script:Get-Provider {
    [CmdletBinding()]
    Param(
        [Parameter (Mandatory=$False)] [string] $Account,
        [Parameter (Mandatory=$False)] [string] $RegionOverride
        )

	$Provider = Get-RSComputeProvider -Account $Account
	
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }

    Add-Member -InputObject $Provider -MemberType NoteProperty -Name Region -Value $Region

	Return $Provider
}

function script:Get-RSComputeProvider {
    [CmdletBinding()]
    Param(
        [Parameter (Mandatory=$False)] [string] $Account
    )

    # The Account comes from the file RSCloudAccounts.csv
	# If the Account is not used, then the username and APIKey must come from environment variables
    Get-RSAccount -Account $Account

    $RSId    = New-Object net.openstack.Core.Domain.CloudIdentity
    $RSId.Username = $Credentials.RackspaceUsername
    $RSId.APIKey   = $Credentials.RackspaceAPIKey
    $Global:RSId = New-Object net.openstack.Providers.Rackspace.CloudIdentityProvider($RSId)
    Return New-Object net.openstack.Providers.Rackspace.CloudServersProvider($RSId)
}

function Get-RSComputeImage {
    [CmdletBinding()]
    Param(
        [Parameter (Mandatory=$False,
					ValueFromPipeline=$True,
					HelpMessage='Account name')]
			[string] $Account,
        [Parameter (Mandatory=$False,
					ValueFromPipeline=$True,
					HelpMessage='ImageId')][string] $ImageId,
        [Parameter (Mandatory=$False,
					ValueFromPipeline=$True,
					HelpMessage='RegionOverride')][string] $RegionOverride,
        [Parameter (Mandatory=$False,
					ValueFromPipeline=$True,
					HelpMessage='ServerName')][string] $ServerName,
        [Parameter (Mandatory=$False,
					ValueFromPipeline=$True,
					HelpMessage='ImageName')][string] $ImageName,
        [Parameter (Mandatory=$False,
					ValueFromPipeline=$True,
					HelpMessage='ImageStatus')][net.openstack.Core.Domain.ImageState] $ImageStatus,
        [Parameter (Mandatory=$False,
					ValueFromPipeline=$True,
					HelpMessage='ChangesSince')][datetime] $ChangesSince,
        [Parameter (Mandatory=$False,
					ValueFromPipeline=$True,
					HelpMessage='MarkerId')][string]  $MarkerId,
        [Parameter (Mandatory=$False,
					ValueFromPipeline=$True,
					HelpMessage='Limit')][int]    $Limit = 10000,
        [Parameter (Mandatory=$False,
					ValueFromPipeline=$True,
					HelpMessage='ImageType')][net.openstack.Core.Domain.ImageType]$ImageType,
        [Parameter (Mandatory=$False,
					ValueFromPipeline=$True,
					HelpMessage='Details')][switch] $Details
    )

	$Provider = Get-Provider -Account $Account -RegionOverride $RegionOverride

    try {

            # DEBUGGING             
            Write-Debug -Message "Get-RSImage"
            Write-Debug -Message "Account..........: $Account"
            Write-Debug -Message "ImageId..........: $ImageId"
            Write-Debug -Message "Details..........: $Details"
            Write-Debug -Message "ServerName.......: $ServerName"
            Write-Debug -Message "ImageName........: $ImageName"
            Write-Debug -Message "ImageStatus......: $ImageStatus"
            Write-Debug -Message "ChangesSince.....: $ChangesSince"
            Write-Debug -Message "MarkerId.........: $MarkerId"
            Write-Debug -Message "Limit............: $Limit"
            Write-Debug -Message "ImageType........: $ImageType"
            Write-Debug -Message "Region...........: $Provider.Region"
			

            if ([string]::IsNullOrEmpty($ImageId)) {
                if ($Details) {
                    Write-Verbose "Getting a detailed list of Server Images"
                    $ImageList = $Provider.ListImagesWithDetails($ServerName, $ImageName, $ImageStatus, $ChangesSince, $MarkerId, $Limit, $ImageType, $Provider.Region, $Null)
                } else {
                    Write-Verbose "Getting a simple list of Server Images"
                    $ImageList = $Provider.ListImages($ServerName, $ImageName, $ImageStatus, $ChangesSince, $MarkerId, $Limit, $ImageType, $Provider.Region, $Null)
                }

                # Handling empty response indicating that no servers exist in the queried data center
                if ($ImageList.Count -eq 0) {
                    Write-Verbose "No Images found in region '$Provider.Region'."
                }
                elseif($ImageList.Count -ne 0){
					foreach($i in $ImageList){
						Add-Member -InputObject $i -MemberType NoteProperty -Name Region -Value $Provider.Region
					}
        		    $ImageList;
                }
            } else {
                $i = $Provider.GetImage($ImageId, $Provider.Region, $Null)
				Add-Member -InputObject $i -MemberType NoteProperty -Name Region -Value $Provider.Region
				$i
        }
    }
    catch {
        Invoke-Exception($_.Exception)
    }
}

function New-RSComputeServer {
    [CmdletBinding()]
	Param(
		[Parameter(Mandatory=$False)] [string]  $Account,
        [Parameter(Mandatory=$true)]  [string]  $ServerName = $(throw "Please specify server name with -ServerName parameter"),
        [Parameter(Mandatory=$true)]  [string]  $ImageId = $(throw "Please specify the image Id with -ImageId parameter"),
        [Parameter(Mandatory=$true)]  [string]  $FlavorId = $(throw "Please specify server flavor with -FlavorId parameter"),
        [Parameter(Mandatory=$false)] [net.openstack.Core.Domain.DiskConfiguration]$DiskConfig = $Null,
        [Parameter(Mandatory=$false)] [net.openstack.Core.Domain.Metadata]$Metadata = $Null,
        [Parameter(Mandatory=$false)] [bool]    $AttachToServiceNetwork=$true,
        [Parameter(Mandatory=$false)] [bool]    $AttachToPublicNetwork=$true,
        [Parameter(Mandatory=$false)] [string[]]$Networks = $Null,
        [Parameter(Mandatory=$false)] [ValidateCount(0,5)][string[]]$PersonalityFile,
        [Parameter(Mandatory=$false)] [string]  $RegionOverride = $Null
	)
	$Provider = Get-Provider -Account $Account -RegionOverride $RegionOverride

    # DEBUGGING
    Write-Debug -Message "New-RSServer"        
    Write-Debug -Message "Account...............: $Account"     
    Write-Debug -Message "ServerName............: $ServerName"
    Write-Debug -Message "ImageId...............: $ImageId"
    Write-Debug -Message "FlavorId..............: $FlavorId"
    Write-Debug -Message "DiskConfig............: $DiskConfig"
    Write-Debug -Message "Metadata..............: $Metadata"
    Write-Debug -Message "AttachToServiceNetwork: $AttachToServiceNetwork"
    Write-Debug -Message "AttachToPublicNetwork.: $AttachToPublicNetwork"
    Write-Debug -Message "Networks..............: $Networks"
    Write-Debug -Message "PersonalityFile.......: $PersonalityFile"
    Write-Debug -Message "Region................: $Provider.Region"

            
    # Create a Server
    $Provider.CreateServer($ServerName, $ImageId, $FlavorId, $DiskConfig, $Metadata, $null, $AttachToServiceNetwork, $AttachToPublicNetwork, $Networks, $Provider.Region, $Null)
}

Export-ModuleMember -Function *