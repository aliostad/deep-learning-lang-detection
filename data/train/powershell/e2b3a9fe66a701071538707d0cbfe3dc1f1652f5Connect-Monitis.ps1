function Connect-Monitis
{
    <#
    .Synopsis
        Connects to the Monitis Web Service
    .Description    
        Connects to the Monitis Web Service so you can perform later operations.  
        The authorization token returned from Monitis is cached for later use.
    .Example
        Connect-Monitis -ApiKey 20ECHRRRMK88L31KH6OMDU0BNR -SecretKey 26CQ6QUIRF571P1BHU3CV37MR0         
    .Link
        Get-CustomMonitor
    .Link
        Get-ExternalMonitor
    #>
    [CmdletBinding(DefaultParameterSetName='ApiKey')]
    param(
    # The API Key used to connect to Monitis.  
    [Parameter(Mandatory=$true,
        ParameterSetName='ApiKey', 
        ValueFromPipelineByPropertyName=$true)]
    [string]$ApiKey,
    # The Secret Key used to connect to Monitis
    [Parameter(Mandatory=$true,
        ParameterSetName='ApiKey', 
        ValueFromPipelineByPropertyName=$true)]
    [string]$SecretKey,
    # Uses a credential for the API key and secret key.  
    # The username will become the API Key and the password will become the 
    # secret key.
    [Parameter(Mandatory=$true,
        ParameterSetName='Credential',
        ValueFromPipelineByPropertyName=$true)]
    [Management.Automation.PSCredential]$Credential,
    
    # If set, outputs the authorization token
    [Switch]$OutputAuthToken
    )
    
    process {
        #region Translate Credentials into APIKey
        if ($pscmdlet.parametersetName -eq 'Credential') {
            $apiKey = $psBoundParameters.Credential.Username
            $SecretKey = $psBoundParameters.Credential.GetNetworkCredential().Password            
        }                
        #endregion
                        
        $webClient = New-Object Net.Webclient        
        $connectionUrl = "http://www.monitis.com/api?action=authToken&apikey=$apiKey&secretkey=$secretKey"        
        $result = $webClient.DownloadString($connectionUrl)
        #region Extract Auth Token            
        if ($result -like '{"authtoken":"*"}') {
            $auth = $result -split '[\"\{\}\:\"]'  | 
                Where-Object { $_ } | 
                Select-Object -Skip 1 
        }
        #endregion
        #region Cache Information
        if ($auth) {
            $script:AuthToken = $auth
            $script:SecretKey = $secretKey
            $script:ApiKey = $apiKey
        }                
        #endregion
                
        if ($outputAuthToken ) {
            $script:AuthToken 
        }
    }
    
}

