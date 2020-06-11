function Invoke-ConceptExtraction {
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
        $address = "https://api.aylien.com/api/v1/concepts?url=$url"

        $result = Invoke-RestMethod -Uri $address -Headers $Headers

        $propertyNames = ($result.concepts[0] | Get-Member -MemberType NoteProperty).name
            
        New-Object PSObject -Property @{
            Url = $Url
            Concepts = $propertyNames | ForEach { $result.concepts.$_.surfaceForms.string }
        }
    }
}