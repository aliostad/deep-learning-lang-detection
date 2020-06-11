function _InvokeImaggaApi{
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true)][pscredential] $credential,
        [parameter(Mandatory=$true)][String] $parameters,
        [parameter(Mandatory=$true)][String] $function
    )

    begin{
        Write-Debug "Starting _InvokeImaggaApi with $parameters"
    }

    process{
        Try{
            $result = Invoke-WebRequest "https://api.imagga.com/v1/$function`?$parameters" -Credential $credential
        }
        Catch{
        Write-debug $_.Exception 
        Throw "Problem contacting imagga API"
        Break
        }
        
        $json = $null
        Try{
            $json = $result.content
        }
        Catch{
            Write-Information $_.Exception 
            Write-debug "JSON: $result"
            Throw "Problem getting imagga JSON."
            Break
        }

        return $json
    }
}