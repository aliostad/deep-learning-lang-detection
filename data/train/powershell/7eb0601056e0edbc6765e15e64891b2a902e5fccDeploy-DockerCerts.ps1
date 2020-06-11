param
(
	$Base64EncodedDockerCACert, $Base64EncodedDockerServerCert, $Base64EncodedDockerServerKey
)

function OpenPorts {
    [cmdletbinding()]
    param()
    process {
        # For ASP.NET 5 web application
        netsh advfirewall firewall add rule name="Http 80" dir=in action=allow protocol=TCP localport=80

        # For Docker daemon
        netsh advfirewall firewall add rule name="Docker Secure Port" dir=in action=allow protocol=TCP localport=2376
    }
}

function SaveBase64EncodedCertificateToFile {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        $base64EncodedContent,
        
        [Parameter(Mandatory = $true, Position = 1)]
        $targetFilePath
    )
    process {
        $bytes = [System.Convert]::FromBase64String($base64EncodedContent)
        $contents = [System.Text.Encoding]::UTF8.GetString($bytes)
        [System.IO.File]::WriteAllText($targetFilePath, $contents)
    }
}

# Open Docker required ports
OpenPorts

SaveBase64EncodedCertificateToFile $Base64EncodedDockerCACert (Join-Path "$env:ProgramData\docker\certs.d" "ca.pem")
SaveBase64EncodedCertificateToFile $Base64EncodedDockerServerCert (Join-Path "$env:ProgramData\docker\certs.d" "server-cert.pem")
SaveBase64EncodedCertificateToFile $Base64EncodedDockerServerKey (Join-Path "$env:ProgramData\docker\certs.d" "server-key.pem")

# Restart Docker service to consume the certificates
Restart-Service Docker