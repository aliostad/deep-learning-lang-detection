# VMKernel	Warnings check
function ShowVMKernel () {

  if ($ShowVMKernel) {
  
    Write-CustomOut "..Checking VMKernel Warnings"
    
    $SysGlobalization = New-Object System.Globalization.CultureInfo("en-US")
    $VMHV = Get-View -ViewType HostSystem
    $VMKernelWarnings = @()

    foreach ($VMHost in ($VMHV)){
      
      $product = $VMHost.config.product.ProductLineId

      if ($product -eq "embeddedEsx"){
        $Warnings = (Get-Log -vmhost ($VMHost.name) -Key messages -ErrorAction SilentlyContinue).entries |where {$_ -match "warning" -and $_ -match "vmkernel"}

        if ($Warnings -ne $null) {
          $VMKernelWarning = @()
          $Warnings | % {
            $Details = "" | Select-Object VMHost, Time, Message, Length, KBSearch, Google
            $Details.VMHost = $VMHost.Name

            if (($_.split()[1]) -eq "") {
              $Details.Time = ([datetime]::ParseExact(($_.split()[0] + " " + $_.split()[2] + " " + $_.split()[3]), "MMM d HH:mm:ss", $SysGlobalization))
            } else {
              $Details.Time = ([datetime]::ParseExact(($_.split()[0] + " " + $_.split()[1] + " " + $_.split()[2]), "MMM dd HH:mm:ss", $SysGlobalization))
            }
            
            $Message = ([regex]::split($_, "WARNING: "))[1]
            $Message = $Message -replace "'", " "
            $Details.Message = $Message
            $Details.Length = ($Details.Message).Length
            $Details.KBSearch = "<a href='http://kb.vmware.com/selfservice/microsites/search.do?searchString=$Message&sortByOverride=PUBLISHEDDATE&sortOrder=-1' target='_blank'>Click Here</a>"
            $Details.Google = "<a href='http://www.google.co.uk/search?q=$Message' target='_blank'>Click Here</a>"
            
            if ($Details.Length -gt 0) {
              if ($Details.Time -gt $Date.AddDays(-$vmkernelchk) -and $Details.Time -lt $Date) {
                $VMKernelWarning += $Details
              }
            }
          }
          
          $VMKernelWarnings += $VMKernelWarning | Sort-Object -Property Length -Unique |select VMHost, Message, Time, KBSearch, Google
        }	
      } else {
        $Warnings = (Get-Log –VMHost ($VMHost.Name) -Key vmkernel -ErrorAction SilentlyContinue).Entries | where {$_ -match "warning" -and $_ -match "vmkernel"}
        
        if ($Warnings -ne $null) {
          $VMKernelWarning = @()
          $Warnings | % {
          $Details = "" | Select-Object VMHost, Time, Message, Length, KBSearch, Google
          $Details.VMHost = $VMHost.Name
          
          if (($_.split()[1]) -eq "") {
            $Details.Time = ([datetime]::ParseExact(($_.split()[0] + " " + $_.split()[2] + " " + $_.split()[3]), "MMM d HH:mm:ss", $SysGlobalization))
          } else {
            $Details.Time = ([datetime]::ParseExact(($_.split()[0] + " " + $_.split()[1] + " " + $_.split()[2]), "MMM dd HH:mm:ss", $SysGlobalization))}
            $Message = ([regex]::split($_, "WARNING: "))[1]
            $Message = $Message -replace "'", " "
            $Details.Message = $Message
            $Details.Length = ($Details.Message).Length
            $Details.KBSearch = "<a href='http://kb.vmware.com/selfservice/microsites/search.do?searchString=$Message&sortByOverride=PUBLISHEDDATE&sortOrder=-1' target='_blank'>Click Here</a>"
            $Details.Google = "<a href='http://www.google.co.uk/search?q=$Message' target='_blank'>Click Here</a>"
            
            if ($Details.Length -gt 0) {						
              if ($Details.Time -gt $Date.AddDays(-$VMKernelchk)) {
                $VMKernelWarning += $Details
              }
            }
          }
          $VMKernelWarnings += $VMKernelWarning | Sort-Object -Property Length -Unique |select VMHost, Message, Time, KBSearch, Google
        }
      }
    }	
    
    If (($VMKernelWarnings | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $VMKernelWarnings = $VMKernelWarnings |sort time -Descending
      $vmKernelReport += Get-CustomHeader "ESX/ESXi VMKernel Warnings" "The following VMKernel issues were found, it is suggested all unknown issues are explored on the VMware Knowledge Base. Use the below links to automatically search for the string"
      $vmKernelReport += Get-HTMLTable $VMKernelWarnings
      $vmKernelReport += Get-CustomHeaderClose
    }			
  }
  
  return $vmKernelReport
}