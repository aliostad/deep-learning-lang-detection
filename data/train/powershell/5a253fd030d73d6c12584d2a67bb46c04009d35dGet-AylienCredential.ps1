function Get-AylienCredential {
    <#
    .Synopsis
        Gets and sets the headers needed to interact with Aylien API
    .Description
        Applies either the passed in ID|Key if the $env variables are not set
    .Example
        Get-AylienCredential $ApplicationId $ApplicationKey
    #>

    [OutputType([Hashtable])]
    param(
        $ApplicationId,
        $ApplicationKey
    )

        if($env:AylienApplicationId)  {$ApplicationId=$env:AylienApplicationId}
        if($env:AylienApplicationKey) {$ApplicationKey=$env:AylienApplicationKey}

        @{
            "X-AYLIEN-TextAPI-Application-ID"=$ApplicationId
            "X-AYLIEN-TextAPI-Application-Key"=$ApplicationKey
        }
}
