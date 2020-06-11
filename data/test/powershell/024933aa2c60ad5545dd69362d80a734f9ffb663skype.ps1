# // TODO: Secure passphrase entry and use via SecureString/Get-Credential

$__user=$env:SkypeFriend

function Get-Skype([Parameter(Mandatory=$true)][ScriptBlock]$MessageReceived, [Parameter(Mandatory=$true)][ScriptBlock]$Starting)
{
    
    [Reflection.Assembly]::LoadFile("C:\Program Files (x86)\Skype\Interop.SKYPE4COMLib.dll") | Out-Null
    [Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-Null

    $skype = New-Object Skype4COMLib.SkypeClass
    $skype.Cache = $false
    $skype.Attach(9,$true)

    Unregister-Event -SourceIdentifier "SkypeListener" -ErrorAction SilentlyContinue | Out-Null

    Add-Member -InputObject $skype -Name MessageReceived -MemberType NoteProperty -Value $MessageReceived -Force
    Add-Member -InputObject $skype -Name Starting -MemberType NoteProperty -Value $Starting -Force
    Add-Member -InputObject $skype -Name Keys -MemberType NoteProperty -Value (New-SkypeKeys) -Force
    Add-Member -InputObject $skype.Keys -Name TheirPublicKey -MemberType NoteProperty -Value ([String]::Empty) -Force
    Add-Member -InputObject $skype -Name RestartListener -MemberType ScriptMethod -Value { 
        Unregister-Event -SourceIdentifier "SkypeListener"; Register-SkypeListener $this } -Force
    Add-Member -InputObject $skype -Name SendMessage -MemberType ScriptMethod -Value {
        param($msg, $user=$__user) Send-SkypeMessage $this (New-SkypeMessage $this $msg) $user } -Force
    Add-Member -InputObject $skype -Name Negotiate -MemberType ScriptMethod -Value {
        param($user=$__user) Send-SkypeMessage $this (New-SkypeMessage $this) $user } -Force

    Register-SkypeListener $skype | Out-Null

    return $skype
}

function New-SkypeKeys()
{
    # // Generate a new secret
    $rj = New-Object System.Security.Cryptography.RijndaelManaged
    $rj.BlockSize = 256
    $rj.GenerateIV()
    $rj.GenerateKey()

    # // Then generate a new set of keys to protect that secret
    $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider 2048

    $keys = New-Object PSObject
    Add-Member -InputObject $keys -Name PublicKey -MemberType NoteProperty -Value ($rsa.ToXmlString($false)) -Force
    Add-Member -InputObject $keys -Name PrivateKey -MemberType NoteProperty -Value ($rsa.ToXmlString($true)) -Force
    Add-Member -InputObject $keys -Name Secret -MemberType NoteProperty -Value ($rj.IV + $rj.Key) -Force
    
    return $keys;
}

function New-SkypeMessage($skype, $message = [String]::Empty)
{
    $msg = New-Object PSObject

    if($message.Length -gt 0) {
        $message = Encrypt-StringWithSecret $message $skype.Keys.Secret
        $encSecret = Encrypt-SecretWithKey $skype.Keys.Secret $skype.Keys.TheirPublicKey

        $keys = (New-SkypeKeys)
        $skype.Keys.PublicKey = $keys.PublicKey
        $skype.Keys.PrivateKey = $keys.PrivateKey
        $skype.Keys.Secret = $keys.Secret
    }

    Add-Member -InputObject $msg -Name Message -MemberType NoteProperty -Value $message -Force
    Add-Member -InputObject $msg -Name Secret -MemberType NoteProperty -Value $encSecret -Force
    Add-Member -InputObject $msg -Name NextPublicKey -MemberType NoteProperty -Value $skype.Keys.PublicKey -Force
    
    ConvertTo-Json $msg
}

function Send-SkypeMessage($skype, $msg, $handle=$__user)
{
    $chat = $skype.CreateChatWith($handle)
    $msg = Compress-String $msg -Base64
    $chat.SendMessage("ENC:$msg")
}

function Register-SkypeListener($skype)
{
    Register-ObjectEvent $skype -EventName MessageStatus -MessageData $skype -SourceIdentifier "SkypeListener" -Action { 
        param($chatMessage, $status)

        try {
            $skype = $Event.MessageData;
            
            switch ($status)
            {
                cmsSent {
                    if($chatMessage.Body.ToLowerInvariant() -eq "!") {
                        
                        $name = $chatMessage.Chat.FriendlyName
                        
                        if($name.Contains('|')) {
                            $name = $name.Split('|').Trim()[0];
                        }
                        
                        $skype.Starting.Invoke($chatMessage.Chat.DialogPartner, $name);
                    }
                }

                cmsReceived {
                    $data = $chatMessage.Body
                    if ($data.StartsWith("ENC:")) { 
                        $data = $data.Remove(0,4)
                        
                        $msg = ConvertFrom-Json (Decompress-String -Base64 $data)

                        if($msg.Message.Length -gt 0) {
                            $secret = Decrypt-SecretWithKey $msg.Secret $skype.Keys.PrivateKey
                            $skype.MessageReceived.Invoke($chatMessage.Sender.Handle, (Decrypt-StringWithSecret $msg.Message $secret))
                        }
                        
                        $skype.Keys.TheirPublicKey = $msg.NextPublicKey
                    }
                }
            } 
        } catch [Exception] {
            Write-Host ($_ | Out-String)
        }
    }
}

function Encrypt-SecretWithKey($secret, $key)
{
    $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider 2048
    $rsa.FromXmlString($key)
    $rsa.Encrypt($secret, $false)
    $rsa.Dispose();
}

function Decrypt-SecretWithKey($secret, $key)
{
    $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider 2048
    $rsa.FromXmlString($key)
    $rsa.Decrypt($secret, $false)
    $rsa.Dispose();
}

function Encrypt-StringWithSecret($string, $secret, $salt = "spaghetti") 
{
    $rj = New-Object System.Security.Cryptography.RijndaelManaged
    $rj.BlockSize = 256
    $rj.IV = $secret[0..31]
    $rj.Key = $secret[32..63]

    $enc = $rj.CreateEncryptor()
    
    $ms = New-Object IO.MemoryStream
    $cs = New-Object System.Security.Cryptography.CryptoStream($ms, $enc, [System.Security.Cryptography.CryptoStreamMode]::Write)

    $data = Compress-String $string
    $cs.Write($data, 0, $data.Length)
    $cs.FlushFinalBlock()

    $encdata = $ms.ToArray()
    
    $cs.Dispose()
    $ms.Dispose()
    $rj.Dispose()
    
    return [Convert]::ToBase64String($encdata)
} 
 
function Decrypt-StringWithSecret($string, $secret, $salt = "spaghetti") 
{
    $rj = New-Object System.Security.Cryptography.RijndaelManaged
    $rj.BlockSize = 256;
    $rj.IV = $secret[0..31]
    $rj.Key = $secret[32..63]

    $dec = $rj.CreateDecryptor()
    
    $ms = New-Object IO.MemoryStream
    $cs = New-Object System.Security.Cryptography.CryptoStream($ms, $dec, [System.Security.Cryptography.CryptoStreamMode]::Write)
    
    $data = [Convert]::FromBase64String($string)

    $cs.Write($data, 0, $data.Length)
    $cs.FlushFinalBlock()

    $decdata = $ms.ToArray()

    $cs.Dispose()
    $ms.Dispose()
    $rj.Dispose()
    
    return Decompress-String -Bytes $decdata
} 

function Compress-String([Parameter(Mandatory=$true, ValueFromPipeline=$true)]$String, [switch]$Base64)
{
    $ms = New-Object System.IO.MemoryStream
    $cs = New-Object System.IO.Compression.GZipStream ($ms, [System.IO.Compression.CompressionMode]::Compress)
    $sw = New-Object System.IO.StreamWriter $cs
    $sw.AutoFlush = $true
    $sw.Write($String)
    $sw.Close();

    $bytes = $ms.ToArray()
    if ($Base64)
    {
        [Convert]::ToBase64String($bytes)
    }
    else
    {
        $bytes
    }
}

function Decompress-String([System.Byte[]]$Bytes, [string]$Base64)
{
    $data = $Bytes
    if ($Base64) {
        $data = [System.Convert]::FromBase64String($Base64)
    }

    $ms = New-Object System.IO.MemoryStream
    $ms.Write($data, 0, $data.Length)

    $ms.Seek(0, 0) | Out-Null
    $cs = New-Object System.IO.Compression.GZipStream ($ms, [System.IO.Compression.CompressionMode]::Decompress)
    $sr = New-Object System.IO.StreamReader $cs
    $sr.ReadToEnd()
}