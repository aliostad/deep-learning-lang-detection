# It decrypt content by using X509 certificate from windows local certificate store
# Params::
# 1> thumb print of certificate
# 2> encrypted content

$thumbPrint = $args[0]

$content = $args[1]

# load System.Security assembly
[System.Reflection.Assembly]::LoadWithPartialName("System.Security") | out-null

$encryptedByteArray = [Convert]::FromBase64String($content)

$envelope =  New-Object System.Security.Cryptography.Pkcs.EnvelopedCms

# get certificate from local machine store
$store = new-object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine)
$store.open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadOnly)
$cert = $store.Certificates | Where-Object {$_.thumbprint -eq $thumbPrint}

$envelope.Decode($encryptedByteArray)

$envelope.Decrypt($cert)

$decryptedBytes = $envelope.ContentInfo.Content

$decryptedResult = [System.Text.Encoding]::UTF8.GetString($decryptedBytes)

$decryptedResult
