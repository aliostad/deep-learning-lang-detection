###########################################################################################
# vCenter 6.5 REST API Example
#
# Authenticate and receive API Session Token
# Use session token to invoke REST API request (Get VMs)
#
# http://www.vhersey.com/
#
###########################################################################################
#Ignore Self Signed Certificates and set TLS
Try {
Add-Type @"
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
   [System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
} Catch {
}

#vCenter Credentials and IP/FQDN
$vcuser = "vcenteruser:vcenterpassword"
$vchost = "vcenterIPorFQDN"

#Authenticate to get session token
$base64 = [Convert]::ToBase64String([System.Text.UTF8Encoding]::UTF8.GetBytes($vcuser))
$headers = @{}
$headers.Add("Authorization", "Basic $base64")
$uri = "https://" + $vchost + "/rest/com/vmware/cis/session"
$response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Post
# Get token from response
$token = $response.value

# Set token to vmware-api-session-id session header
$session = @{'vmware-api-session-id' = $token}

# Request list of VMs
$getvmuri = "https://" + $vchost + "/rest/vcenter/vm" 
$response = Invoke-RestMethod -Uri $getvmuri -Method Get -Headers $session
