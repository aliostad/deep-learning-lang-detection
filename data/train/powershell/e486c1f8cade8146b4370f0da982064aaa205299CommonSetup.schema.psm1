configuration CommonSetup
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $DomainName
    )

    function Write-LogFile
    {
        param
        (
            [Parameter(Mandatory=$true)]
            [string]
            $Message
        )

        ("$(Get-Date) : "+$Message) | Out-File -FilePath C:\users\Public\Documents\logs.txt -Append
    }

	
	Write-LogFile -Message "Starting Common Setup..."
    
    Write-LogFile -Message ("Adding "+$DomainName+" to the DNS Suffix Search List")
    Set-DnsClientGlobalSetting -SuffixSearchList @($DomainName)
    Write-LogFile -Message ("Added "+$DomainName+" to the DNS Suffix Search List")
}