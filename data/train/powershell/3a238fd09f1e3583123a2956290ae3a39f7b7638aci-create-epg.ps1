param (
  [parameter(Mandatory=$true,ValueFromPipeLine=$true,ValueFromPipeLineByPropertyName=$true)]
  [ValidateNotNullOrEmpty()]
  [string]$username,
  [parameter(Mandatory=$true,ValueFromPipeLine=$true,ValueFromPipeLineByPropertyName=$true)]
  [ValidateNotNullOrEmpty()]
  [string]$password,
  [parameter(Mandatory=$true,ValueFromPipeLine=$true,ValueFromPipeLineByPropertyName=$true)]
  [ValidateNotNullOrEmpty()]
  [string]$apic,
  [parameter(Mandatory=$true,ValueFromPipeLine=$true,ValueFromPipeLineByPropertyName=$true)]
  [ValidateNotNullOrEmpty()]
  [string]$CSVFile
)

.".\aci-functions.ps1"

# Simple function to create an ACI EPG and optionally attach it to a vCenter
function ACI-Create-EPG([string]$EGP_Name, [string]$EPG_Desc, [string]$BD_Name, [string]$AP_Name, [string]$TN_Name, [string]$VC_Name)
{
  # format the EPG creation API call, starting with the URL
  $url = "https://$apic/api/node/mo/uni/tn-$TN_Name/ap-$AP_Name/epg-$EPG_Name.json"
  # Now the JSON body
  $body = '{"fvAEPg":{"attributes":{"dn":"uni/tn-' + $TN_Name + '/ap-' + $AP_Name + '/epg-' + $EPG_Name + '","name":"' + $EPG_Name + '","rn":"epg-' + $EPG_Name + '","descr": "' + $EPG_Desc + '", "status":"created"},"children":[{"fvRsBd":{"attributes":{"tnFvBDName":"' + $BD_Name + '","status":"created,modified"},"children":[]}}]}}';
  # Execute the API Call
  $result = ACI-API-Call "POST" "application/json" $url "" $body

  # If the result was OK, go on
  if($result.httpCode -eq 200)
  {
    Write-Host "EPG '$EPG_Name' created!";

    # If the EPG was created and the VC_Name variable isn't empty, do the vCenter attachment
    if($VC_Name -ne "")
    {
      # Format the URL
      $url = "https://$apic/api/node/mo/uni/tn-$TN_Name/ap-$AP_Name/epg-$EPG_Name.json"
      # Format the JSON body for the API Call
      $body = '{"fvRsDomAtt":{"attributes":{"resImedcy":"immediate","tDn":"uni/vmmp-VMware/dom-' + $VC_Name + '","status":"created"},"children":[{"vmmSecP":{"attributes":{"status":"created"},"children":[]}}]}}';
      # Execute the API Call
      $result = ACI-API-Call "POST" "application/json" $url "" $body

      # Did it work?
      if($result.httpCode -eq 200)
      {
        Write-Host "EPG attached to vCenter!";
      }
      else {
        # It did not work :-(
        Write-Host "Failed to attach EPG to vCenter!"
      }
    }
  }
  else {
    # EPG creation did not return an OK :-(
    Write-Host "Failed to create EPG!"
  }
}

# Run through the CSV file line for line and create an EPG for each line
Import-Csv $CSVFile | Foreach {
  $EPG_Name = $_."EPG Name"
  $EPG_Desc = $_."EPG Description"
  $BD_Name  = $_."Bridge Domain"
  $AP_Name  = $_."Application Profile"
  $TN_Name  = $_."Tenant Name"
  $VC_Name  = $_."vCenter Name"

  ACI-Create-EPG $EGP_Name $EPG_Desc $BD_Name $AP_Name $TN_Name $VC_Name
}
