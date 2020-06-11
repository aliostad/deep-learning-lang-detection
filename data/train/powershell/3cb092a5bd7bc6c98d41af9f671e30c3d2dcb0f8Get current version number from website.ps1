# Checking if website is available
if( (Test-NetConnection -ComputerName "getpaint.net" -CommonTCPPort HTTP).TcpTestSucceeded -eq $true ) {
    Write-Verbose -Message "Website is available."

    # Request website content
    $Website = Invoke-WebRequest -Uri "https://www.getpaint.net/"

    if($Website.StatusCode -eq 200) {
        Write-Verbose -Message "Got website content."

        $CurrentVersion = (($Website.AllElements | Where-Object { $_.innerHTML -clike "paint.net*.*.*"}).innerHTML).Substring(10)
        $CurrentVersion
    }
    else {
        Write-Verbose -Message "Got no website content!"

        Exit 1
    }
}
else {
    Write-Verbose -Message "Website not available!"

    Exit 1
}
