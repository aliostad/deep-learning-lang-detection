function Invoke-B2ItemDownload
{
<#
.SYNOPSIS
    The Invoke-B2ItemDownload cmdlet downloads files by either the file ID or file name.
.DESCRIPTION
    The Invoke-B2ItemDownload cmdlet downloads files by either the file ID or file name.
    When downloading by the file name the bucket ID the file resides in must be specified.
    
    An API key is reuqired to use this cmdlet.
.EXAMPLE
    Invoke-B2ItemDownload -FileID 4_h4a48fe8875c6214145260818_f000000000000472a_d20140104_m032022_c001_v0000123_t0104 -OutFile C:\hello.txt
    
    The cmdlet above will download the file with the given ID and place it at the root of the C: drive with the name hello.txt.
.EXAMPLE
    PS C:\>Invoke-B2ItemDownload -FileName hello.txt -BucketName text -OutFile C:\hello.txt
    
    The cmdlet above will download the file with the given name from the given bucket name and place it at the root of the C: drive with the name hello.txt.
.EXAMPLE
    PS C:\>Get-B2Bucket | Get-B2ChildItem | ForEach-Object {Invoke-B2ItemDownload -FileID $_.ID -OutFile .\$_.Name}
    
    The cmdlet above will download the first 1000 files in all buckets and place them in the current directory.
.INPUTS
    System.String
    
        This cmdlet takes the FileID, FileName, BucketName, OutFile, and ApiToken as strings.
    
    System.Uri
    
        This cmdlet takes the ApiUri as a uri.
.OUTPUTS
    None
    
        The cmdlet has no outputs.
.LINK
    https://www.backblaze.com/b2/docs/
.ROLE
    PS.B2
.FUNCTIONALITY
    PS.B2
#>
    [CmdletBinding(SupportsShouldProcess=$true,
                   ConfirmImpact='Low')]
    [Alias('ib2id')]
    [OutputType()]
    Param
    (
        # The Uri for the B2 Api query.
        [Parameter(ParameterSetName='ID',
                   Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]$ID,
        # The Uri for the B2 Api query.
        [Parameter(ParameterSetName='Name',
                   Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
        # The Uri for the B2 Api query.
        [Parameter(ParameterSetName='Name',
                   Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]$BucketName,
        # The Uri for the B2 Api query.
        [Parameter(ParameterSetName='Name',
                   Mandatory=$true,
                   Position=3)]
        [Parameter(ParameterSetName='ID',
                   Mandatory=$true,
                   Position=1)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]$OutFile,
        # The Uri for the B2 Api query.
        [Parameter(Mandatory=$false,ParameterSetName='Name')]
        [Parameter(Mandatory=$false,ParameterSetName='ID')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Uri]$ApiDownloadUri = $script:SavedB2DownloadUri,
        # The authorization token for the B2 account.
        [Parameter(Mandatory=$false,ParameterSetName='Name')]
        [Parameter(Mandatory=$false,ParameterSetName='ID')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]$ApiToken = $script:SavedB2ApiToken
    )
    
    Begin
    {
        if(-not (Test-Path -Path $OutFile -IsValid))
        {
            throw 'The file path given is not valid.`n`rThe file cannot be saved.'
        }
        [Hashtable]$sessionHeaders = @{'Authorization'=$ApiToken}
    }
    Process
    {
        # The process context will change based on the name of the paramter set used.
        switch($PSCmdlet.ParameterSetName)
        {
            'ID'
            {
                [Uri]$b2ApiUri = "${ApiDownloadUri}b2api/v1/b2_download_file_by_id?fileId=$ID"
                if($PSCmdlet.ShouldProcess($ID, "Download to the path $OutFile."))
                {
                    try
                    {
                        Invoke-RestMethod -Method Get -Uri $b2ApiUri -Headers $sessionHeaders -OutFile $OutFile
                    }
                    catch
                    {
                        $errorDetail = $_.Exception.Message
                        Write-Error -Exception "Unable to upload the file.`n`r$errorDetail" `
                            -Message "Unable to upload the file.`n`r$errorDetail" -Category InvalidOperation
                    }
                }
            }
            'Name'
            {
                [Uri]$b2ApiUri = "${ApiDownloadUri}file/$BucketName/$Name"
                if($PSCmdlet.ShouldProcess($Name, "Download to the path $OutFile."))
                {
                    try
                    {
                        Invoke-RestMethod -Method Get -Uri $b2ApiUri -Headers $sessionHeaders -OutFile $OutFile
                    }
                    catch
                    {
                        $errorDetail = $_.Exception.Message
                        Write-Error -Exception "Unable to upload the file.`n`r$errorDetail" `
                            -Message "Unable to upload the file.`n`r$errorDetail" -Category InvalidOperation
                    }
                }
            }
        }
    }
}