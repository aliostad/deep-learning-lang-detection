#requires -Version 3
function New-EchosignUser
{
    [cmdletbinding(SupportsShouldProcess = $True,ConfirmImpact = 'High')]

    Param(
        [Parameter(Mandatory = $True,ValueFromPipelineByPropertyName = $True)]
        [Alias('FirstName')]
        [string]$GivenName,

        [Parameter(Mandatory = $True,ValueFromPipelineByPropertyName = $True)]
        [Alias('LastName')]
        [string]$Surname,

        [Parameter(Mandatory = $True,ValueFromPipelineByPropertyName = $True)]
        [Alias('Email')]
        [string]$Mail,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [securestring]$Password = (New-RandomPassword).SecureStringObject,

        [Parameter(Mandatory = $True)]
        [string]$Company,

        [Parameter(Mandatory = $False)]
        [string]$GroupID = $null,

        [Parameter(Mandatory = $True)]
        [string]$APIKey,

        [Parameter(Mandatory = $True)]
        [string]$ApplicationSecret,

        [Parameter(Mandatory = $True)]
        [string]$ApplicationId
    )

    Begin{
        $RESTCredentials = @{
            userCredentials        = @{
                apiKey = $APIKey
            }
            applicationCredentials = @{
                applicationSecret = $ApplicationSecret
                applicationId     = $ApplicationId
            }
        } | ConvertTo-Json
    }

    Process{
        $AccessToken = Invoke-RestMethod -Uri 'https://api.echosign.com/api/rest/v2/auth/tokens' -Method Post -Body $RESTCredentials -ContentType application/json | Select-Object -ExpandProperty AccessToken
        
        $Header = @{
            'access-Token' = $AccessToken
        }
    
        $Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($Password)
        $PTPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($Ptr)
    
        $UserInfoHashtable = @{
            optIn     = 'NO'
            lastName  = $Surname
            email     = $Mail
            company   = $Company
            firstName = $GivenName
            password  = $PTPassword
        }

        If($PSBoundParameters.ContainsKey('GroupID'))
        {
            $UserInfoHashtable.groupId = $GroupID
        }
        
        $UserInfo = $UserInfoHashtable | ConvertTo-Json

        If($PSCmdlet.ShouldProcess("$($UserInfoHashtable.email)"))
        {
            Try
            {
                $null = Invoke-RestMethod -Uri 'https://api.echosign.com/api/rest/v2/users' -Method Post -Body $UserInfo -Headers $Header -ContentType application/json -ErrorAction Stop
            }
            Catch
            {
                $Details = $_.ErrorDetails.Message | ConvertFrom-Json
                Write-Warning -Message "$($Details.Code). $($Details.Message)."
            }
        }
    }

    End{}
}


