$primary = "10.1.10.2"
   $secondary = "10.1.10.226"
   $DNSServers = "$primary","$secondary"
   $message=""

  function setDNS($DNSServers)
  {

     try
      {
  	  $NICs = Get-WMIObject Win32_NetworkAdapterConfiguration |where{$_.IPEnabled -eq "TRUE"}
  	  Foreach($NIC in $NICs) 
	   {
	     $message += $NIC.SetDNSServerSearchOrder(@($DNSServers)) | Out-String   # set the DNS IPs and capture output to string
	   }
        }
     catch
        {
	  $message += "An error occcured while setting NIC object." + "`n`rError: $_";
        }
     #write-host $message #if necessary, display result messages
  }
  setDNS($DNSServers)