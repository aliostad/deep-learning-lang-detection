function Send-Download
    {
    [OutputType([bool])]
    Param
        (
        # URL of SabNZBd+
        [String]
        $SabNZBdplus,

        # API key of SabNZBd+
        [String]
        $APIKey,
    
        # URL of NZB
        [Parameter(Mandatory=$True)]
        [string]
        $NZBURL,
                
        # Friendly Name of NZB
        [Parameter(Mandatory=$false)]
        [string]
        $NZBTitle,

        # Category to place download in
        [Parameter(Mandatory=$True)]
        [validateSet("books","comics","magazines","movies","music","software","tv","jizzles")]
        [string]
        $sabCategory

        )
    Write-Verbose -Message "Sending $NZBURL to $SabNZBdplus/$sabCategory"
  
    
    $sabAddDownload = $SabNZBdplus+"/api?mode=addurl&name=$(Invoke-URLEncoding -unencodedString $NZBURL))&cat=$($sabCategory)&output=JSON&apikey=$($APIKey)&nzbname=$($NZBTitle)"
    Write-Verbose -Message $sabAddDownload
    Invoke-RestMethod -Uri $sabAddDownload


    }

