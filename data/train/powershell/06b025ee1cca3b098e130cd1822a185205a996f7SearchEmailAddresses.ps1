function SearchEmailAddresses {
    Write-Host 'Word to search in EmailAddresses' -Fore Cyan -Back DarkBlue;
    $SearchCriterion = Read-Host '( i.e. example.com or bob or whatever )';
    $SearchResults = get-recipient -ResultSize Unlimited | Where-Object { ($_.RecipientType -eq 'UserMailbox' -and $_.EmailAddresses -match $SearchCriterion) } | select Name,SamAccountName,primarySmtpAddress,Database,OriginatingServer
    $SearchResults
    $SavePath = ('EmailAddressesSearchResults-{1:yyyyMMddHHmmss}.csv' -f $env:COMPUTERNAME,(Get-Date))
    $SearchResults | Export-csv  -Path $SavePath
    Write-Host 'Results saved: ' -Fore Yellow -Back Blue -NoNewLine;
    Write-Host $SavePath -Fore DarkRed -Back gray;start-sleep -seconds 1
}
SearchEmailAddresses
