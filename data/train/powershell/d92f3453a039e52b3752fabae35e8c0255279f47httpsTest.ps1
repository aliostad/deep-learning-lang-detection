add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$uris = @("https://api.georgiancollege.ca/programApi"
    ,"https://ccr.georgiancollege.ca/"
    ,"https://studentcard.georgiancollege.ca/"
    ,"https://barectrac01:443/"
);
foreach ($uri in $uris) {
    $result = 'unknown';
    try {
        Write-Host "uri: $uri";
        $result = Invoke-WebRequest -Uri $uri;
    } catch [system.exception] {
        $result = $_;
    }
    Write-Host "result:$result`n-------------------";
}
