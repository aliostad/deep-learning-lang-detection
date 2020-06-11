function Invoke-HashtagExtraction {
    param(
        [Parameter(ValueFromPipeline=$true)]
        [string]$Url,
        $ApplicationId,
        $ApplicationKey
    )

    Begin {
        $Headers = Get-AylienCredential $ApplicationId $ApplicationKey
    }

    Process {
        $address = "https://api.aylien.com/api/v1/hashtags?url=$url"

        $result = Invoke-RestMethod -Uri $address -Headers $Headers

        New-Object PSObject -Property @{
            Url = $Url
            Hashtags = $result.hashtags
        }
    }
}