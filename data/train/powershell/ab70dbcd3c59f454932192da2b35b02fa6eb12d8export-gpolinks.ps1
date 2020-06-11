# this script is inspired and largely taken 
# from https://github.com/jeremyts/ActiveDirectoryDomainServices/blob/master/Backups/ManageGPOLinks.ps1


function export-gpolinks {

  if(!(Test-Path -Path "$winkeeper_local\gpolinks" )){
    New-Item -ItemType directory -Path "$winkeeper_local\gpolinks"
  }

  $gpo_parent_dir = join-path $winkeeper_local "gpolinks"

  $gpo_reference_file = join-path $gpo_parent_Dir $gpo_reference_filename

  set-content $gpo_reference_file $null
  $Links = $NULL
  $thisDomain = Get-ADDomain
  $thisDomainDN = $thisDomain.DistinguishedName
  $thisDomainConfigurationPartition = "CN=Configuration," + $thisDomainDN
  $Links = Get-ADObject -Filter {gpLink -LIKE "[*]"} -Properties gpLink

  #$Links += Get-ADObject -Filter {gpLink -LIKE "[*]"} -Searchbase $thisDomainConfigurationPartition -Properties gpLink

  $NewLine = $null
  if ($Links) {
    foreach ($Link in $Links) {
      if ($Link -ne $NULL) {
        $NewLine = $null
        $LinkList = $Link.gpLink.Split('\[|\]')

        foreach ($LinkItem in $LinkList) {
          if ($LinkItem) {
            $LinkSplit = $LinkItem.Split(";")
            $LinkItem = $LinkItem.TrimStart("LDAP://")
            $LinkItem = $LinkItem.TrimEnd(';0|;1|;2')
            $LinkItem = get-adobject $LinkItem -Properties displayName
            $NewLine = $NewLine + $LinkItem.DisplayName + ";" + $LinkSplit[1] + "`v"
          }
        }
        $NewLine = $Link.DistinguishedName + "`t" + $thisDomainDN + "`t" + $NewLine
        add-content $gpo_reference_file $NewLine
      }
    }
    write-host -ForegroundColor Yellow "The output file has been saved at $gpo_reference_file"
  }
  else {
      write-host -ForegroundColor Red "No GPO Links exist in this domain"
      write-host -ForegroundColor Red "Exiting script"
      Set-Content $gpo_reference_file $NULL
  return
  }
}