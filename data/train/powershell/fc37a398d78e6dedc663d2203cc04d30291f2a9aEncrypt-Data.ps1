Function Encrypt-Data
{
[cmdletbinding()]
Param(
    [Parameter(Mandatory=$true,Position=0)]
    [string]$SamAccountName,
    [Parameter(Mandatory=$true,Position=1)]
    [string]$PayLoad,
    [Parameter(Mandatory=$false)]
    [string]$FilePath
    )
    
    ## first we define a function that gets the certificate of the specified user account
    ## Then we use that certificate to encrypt the password

#region Sub-Functions

    ## Function that returns the user certificate from Active Directory (so we can safely encrypt and decrypt passwords)
    Function Get-UserCertificate([string]$SamAccountName)
    {
    $UserCertificateBytes = (Get-ADUser -Identity $SamAccountName -Properties UserCertificate -ErrorAction Stop).UserCertificate
    [System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate = $UserCertificateBytes[0]
    return $Certificate
    }

#endregion


    try
    {
        ## Here we call the functions
        $UserCert = Get-UserCertificate -SamAccountName $SamAccountName ## Get the user certificate
        $PayLoadBytes = [System.Text.Encoding]::UTF8.GetBytes($PayLoad) ## Convert the password to a byte array
        $EncryptedPayLoadBytes = $UserCert.PublicKey.Key.Encrypt($PayLoadBytes,$true) ## Encrypt the bytes with the public key
        $EncryptedPayLoadUTF8String = [System.Text.Encoding]::UTF8.GetString($EncryptedPayLoadBytes) ## Convert bytes to string

        ## form a PSCustomObject that contains the bytes AND the string (saving the pasword to a file is most reliable by writing the byte array)
        $EncryptedObject = [PSCustomObject] @{
            PayloadBytes = $EncryptedPayLoadBytes
            PayloadStringString = $EncryptedPayLoadUTF8String
            }
        

        ## If the filepath field is set, save the payload to the file
        if ($FilePath -ne $null)
            {
                [System.IO.File]::WriteAllBytes($FilePath,$EncryptedPayLoadBytes)
            }
        return $EncryptedObject
    }

    catch
    {
        #$exception = [System.InvalidOperationException]::new("Unable to find a valid user certificate for $UserName")
        #throw $exception
        throw
    }

}