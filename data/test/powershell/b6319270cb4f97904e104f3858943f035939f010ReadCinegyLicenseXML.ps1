#read server list from XML
[xml]$servers = Get-Content "ServerList.xml"

#webclient to grab license data from servers
$client = New-Object Net.WebClient

ForEach ($server In $servers.ServerList.ChildNodes) 
{   
    $url = $server.Address
    $serverResponse = "";
    $serverResponse = [xml]$client.DownloadString($url)
    
    $saveFile = ".\\Saved\\" + $server.Name + ".xml"
    
    if($serverResponse)
    {
        if($serverResponse.LicensingService) 
        {
            $saveTime = Get-Date
            Out-File -filepath $saveFile -InputObject  $serverResponse.OuterXml
        }
    }
  
    [xml]$licenseDetails = Get-Content $saveFile
    
    Write-Output "Server $($server.Name.ToString()) detected and response saved"
        
    foreach($licenseTypeNode in $licenseDetails.LicensingService.AvailableLicenses.LicenseType)
    {
        foreach($licenseNode in $licenseTypeNode)
        {
           if (($licenseNode.License.minDaysLeft -lt 11) -and ($licenseNode.License.minDaysLeft -gt -1))
           {
                Write-Host "OMG just" $licenseNode.License.minDaysLeft "days left for" $licenseNode.License.ParentNode.name
           }
        }
    }

}