function Get-B2Bucket
{
<#
.SYNOPSIS
    The Get-B2Bucket cmdlet will list buckets associated with the account.
.DESCRIPTION
    The Get-B2Bucket cmdlet will list buckets associated with the account.
    
    An API key is required to use this cmdlet.
.EXAMPLE
    Get-B2Bucket
    
    BucketName       BucketID                 BucketType AccountID
    ----------       --------                 ---------- ---------
    awsome-jack-fang 4a48fe8875c6214145260818 allPrivate 30f20426f0b1
    Kitten Videos    5b232e8875c6214145260818 allPublic  30f20426f0b1
    
    The cmdlet above will return all buckets for the account.
.EXAMPLE
    Get-B2Bucket | Where-Object {$_.BucketName -eq 'awsome-jack-fang'}
    
    BucketName       BucketID                 BucketType AccountID
    ----------       --------                 ---------- ---------
    awsome-jack-fang 4a48fe8875c6214145260818 allPrivate 30f20426f0b1
    
    The cmdlet above will return all buckets and search for the one with
    a name of awsome-jack-fang.
.INPUTS
    System.String
    
        This cmdlet takes the AccountID and ApplicationKey as strings.
        
    System.Uri
    
        This cmdlet takes the ApiUri as a Uri.
.OUTPUTS
    PS.B2.Bucket
    
        The cmdlet will output a PS.B2.Bucket object holding the bucket info.
.LINK
    https://www.backblaze.com/b2/docs/
.ROLE
    PS.B2
.FUNCTIONALITY
    PS.B2
#>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [Alias('gb2b')]
    [OutputType('PS.B2.Bucket')]
    Param
    (
        # The Uri for the B2 Api query.
        [Parameter(Mandatory=$false,
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Uri]$ApiUri = $script:SavedB2ApiUri,
        # The account ID for the B2 account.
        [Parameter(Mandatory=$false,
                   Position=1)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]$AccountID = $script:SavedB2AccountID,
        # The authorization token for the B2 account.
        [Parameter(Mandatory=$false,
                   Position=2)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]$ApiToken = $script:SavedB2ApiToken
    )
    
    Begin
    {
        [Hashtable]$sessionHeaders = @{'Authorization'=$ApiToken}
        [String]$sessionBody = @{'accountId'=$AccountID} | ConvertTo-Json
        [Uri]$b2ApiUri = "$ApiUri/b2api/v1/b2_list_buckets"
    }
    Process
    {
        $bbInfo = Invoke-RestMethod -Method Post -Uri $b2ApiUri -Headers $sessionHeaders -Body $sessionBody
        foreach($info in $bbInfo.buckets)
        {
            $bbReturnInfo = [PSCustomObject]@{
                'BucketName' = $info.bucketName
                'BucketID' = $info.bucketId
                'BucketType' = $info.bucketType
                'AccountID' = $info.accountId
            }
            # bbReturnInfo is returned after Add-ObjectDetail is processed.
            Add-ObjectDetail -InputObject $bbReturnInfo -TypeName 'PS.B2.Bucket'
        }
    }
}