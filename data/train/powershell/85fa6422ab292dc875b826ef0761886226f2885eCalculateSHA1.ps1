[Reflection.Assembly]::LoadWithPartialName("System.Security") | out-null
$sha1 = new-Object System.Security.Cryptography.SHA1Managed

$args | %{
    resolve-path $_ | %{
        write-host ([System.IO.Path]::GetFilename($_.Path))

        $file = [System.IO.File]::Open($_.Path, "open", "read")
        $sha1.ComputeHash($file) | %{
            write-host -nonewline $_.ToString("x2")
        }
        $file.Dispose()

        write-host
        write-host
    }
}