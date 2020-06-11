# Checking if website is available
if( (Test-NetConnection -ComputerName "notepad-plus-plus.org" -CommonTCPPort HTTP).TcpTestSucceeded -eq $true ) {
    Write-Verbose -Message "Website is available."

    # Request website content
    $Website = Invoke-WebRequest -Uri "https://notepad-plus-plus.org"

    if($Website.StatusCode -eq 200) {
        Write-Verbose -Message "Got website content."

        $CurrentVersion = (($Website.AllElements | Where-Object { $_.outerText -like "Download*" -and $_.tagName -eq "P" }).innerText).Split(":")[1].Substring(1)
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
