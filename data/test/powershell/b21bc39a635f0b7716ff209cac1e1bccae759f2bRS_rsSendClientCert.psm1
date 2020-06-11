Function Get-TargetResource {
   param (
      [Parameter(Mandatory)]
      [ValidateNotNullOrEmpty()]
      [string]$Name,
      [string]$DestinationQueue,
      [string]$MessageLabel,
      [string]$Ensure,
      [string]$NodeInfo
   )
   return @{
      'DestinationQueue' = $DestinationQueue
      'MessageLabel' = $MessageLabel
      'Name' = $Name
      'Ensure' = $Ensure
      'NodeInfo' = $NodeInfo
   }
}

Function Test-TargetResource {
   param (
      [Parameter(Mandatory)]
      [ValidateNotNullOrEmpty()]
      [string]$Name,
      [string]$DestinationQueue,
      [string]$MessageLabel,
      [string]$Ensure,
      [string]$NodeInfo
   )
   return $false
}

Function Set-TargetResource {
   param (
      [Parameter(Mandatory)]
      [ValidateNotNullOrEmpty()]
      [string]$Name,
      [string]$DestinationQueue,
      [string]$MessageLabel,
      [string]$Ensure,
      [string]$NodeInfo
   )
   if($Ensure -eq 'Present') {
      $bootstrapinfo = Get-Content $NodeInfo -Raw | ConvertFrom-Json
      [Reflection.Assembly]::LoadWithPartialName("System.Messaging") | Out-Null
      $publicCert = ((Get-ChildItem Cert:\LocalMachine\My | ? Subject -eq "CN=$env:COMPUTERNAME`_enc").RawData)
      $msgbody = @{'Name' = "$env:COMPUTERNAME"
         'uuid' = $($bootstrapinfo.uuid)
         'dsc_config' = $($bootstrapinfo.dsc_config)
         'shared_key' = $($bootstrapinfo.shared_key)
         'PublicCert' = "$([System.Convert]::ToBase64String($publicCert))"
         'NetworkAdapters' = $($bootstrapinfo.NetworkAdapters)
      } | ConvertTo-Json
      $msg = New-Object System.Messaging.Message
      $msg.Label = $MessageLabel
      $msg.Body = $msgbody
      $queue = New-Object System.Messaging.MessageQueue ($DestinationQueue, $False, $False)
      $queue.Send($msg)
   }
   else {
      Write-Verbose "Not Sending Messages"
   }
}


Export-ModuleMember -Function *-TargetResource