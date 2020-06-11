# Example
# http://blog.briankmarsh.com/vmware-usage-meter-api/


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

$token = "TOKYRYNYB3HZ2JT3HXLMVVLXC0ZJ1P5Z4VZ"
$uri = "https://vcum.hotline.net.au:8443/um/api/reports"

#$headers = @{"x-useagemeter-authorization" = "$token"}
#$headers
Invoke-RestMethod -Uri $uri -Headers @{"x-useagemeter-authorization"="$token"} -ContentType "application/json"