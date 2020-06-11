function Log-Message{
    param($Message)
    
    # Where to save log files?
    $dirLog = "c:\VPN\Logs"
        
    $dir = Get-Item -Path $dirLog
    if(-not $dir)
    {
        New-Item -ItemType directory -Path $dirLog
    }
    
    $today = Get-Date
    $logFile = $dirLog + "\" + $today.Day + ".log"

    $today.ToString() + " : " + $Message >> $logFile
}

while($true)
{
    # Wait 60 seconds before new check
    Start-Sleep 60

    # Make sure you have Azure VPN Client installed and working
    $vpnParentDir = $env:APPDATA + "\Microsoft\Network\Connections\Cm"
    $itemsInDir = Get-ChildItem -Path $vpnParentDir | ?{ $_.PSIsContainer } | Select-Object Name
    if(-not $itemsInDir)
    {
        Log-Message -Message "Can't find Azure Point to Site VPN installed on this computer, please double check."
        continue
    }

    if($itemsInDir -isnot [System.Array])
    {
        $vpnGateway = $itemsInDir.Name
    }
    else
    {
        Log-Message -Message "Multiple directory found under $vpnParentDir, we select the first one as vpn gateway."
        $vpnGateway = $itemsInDir[0].Name
    }

    # Check if a cloud server can be contacted
    # Replace with your Azure server private IP
    $azureServerIp = "10.0.0.36"    
    $result = gwmi -query "SELECT * FROM Win32_PingStatus WHERE Address = '$azureServerIp'" 
    if ($result.StatusCode -eq 0) { 
        Log-Message -Message "Server $azureServerIp is up."
    } 
    else
    { 
        Log-Message -Message "Server $azureServerIp is down."

        # Double checking if VPN is really down. Try to disconnect first.
        Log-Message -Message "Disconnecting..."
        rasdial $vpnGateway /DISCONNECT 
        
        # Connect using Azure VPN gateway 
        Log-Message -Message "Connecting..."
        rasdial $vpnGateway /PHONEBOOK:$vpnParentDir\$vpnGateway\$vpnGateway.pbk 

        # Check assined IP address
        # Replace with your Azure VNET Point to site IP segment
        $azureVnetP2SRange = "172.16.0"
        $azureIpAddress = ipconfig | findstr $azureVnetP2SRange
        
        $azureIpAddress = $azureIpAddress.Split(": ")
        $azureIpAddress = $azureIpAddress[$azureIpAddress.Length-1]
        $azureIpAddress = $azureIpAddress.Trim()

        # If Azure hasn't given us one yet, exit and let u know
        if (!$azureIpAddress){
            Log-Message -Message "You do not currently have an IP address in your Azure subnet."
            continue
        }

        # Delete any previous configured routes for these ip ranges
        $azureVnetRange = "10.0.0.0"
        $routeExists = route print | findstr $azureVnetRange
        if($routeExists) {
            Log-Message -Message "Deleting route to Azure: $azureVnetRange"
            route delete $azureVnetRange
        }

        # Add our new routes to Azure Virtual Network
        Log-Message -Message "Adding route to Azure: $azureVnetRange"
        Log-Message -Message "route add $azureVnetRange MASK 255.255.255.0 $azureIpAddress"
        route add $azureVnetRange MASK 255.255.255.0 $azureIpAddress
    }
}
