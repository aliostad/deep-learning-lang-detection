param(
  [string]$to_fqdn
)

$confdir = "C:/ProgramData/PuppetLabs/puppet/etc"
$ssldir = $confdir + "/ssl"

Write-EventLog -LogName Application -Source "Puppet" -EntryType Information -EventId 1 -Message "Agent Migration: Begin update of puppet.conf"

Write-EventLog -LogName Application -Source "Puppet" -EntryType Information -EventId 1 -Message "Agent Migration: Update 'server='$to_fqdn"
(Get-Content ($confdir + "/puppet.conf") |
    Foreach-Object {$_ -replace '^server.+', ("server=" + $to_fqdn)}
) | Set-Content ($confdir + "/puppet.conf")

Write-EventLog -LogName Application -Source "Puppet" -EntryType Information -EventId 1 -Message "Agent Migration: Update 'archive_file_server='$to_fqdn"
(Get-Content ($confdir + "/puppet.conf") |
    Foreach-Object {$_ -replace '^archive_file_server.+', ("archive_file_server=" + $to_fqdn)}
) | Set-Content ($confdir + "/puppet.conf")

Write-EventLog -LogName Application -Source "Puppet" -EntryType Information -EventId 1 -Message "Agent Migration: Remove 'environment' tag"
(Get-Content ($confdir + "/puppet.conf") |
     Where-Object {$_ -notmatch '^environment.+'}
) | Set-Content ($confdir + "/puppet.conf")

if ( Test-Path $ssldir ) {
  Write-EventLog -LogName Application -Source "Puppet" -EntryType Information -EventId 1 -Message "Agent Migration: Remove $ssldir"
  Remove-Item -Recurse -Force $ssldir
}

Write-EventLog -LogName Application -Source "Puppet" -EntryType Information -EventId 1 -Message "Agent Migration: End update of puppet.conf"

Write-EventLog -LogName Application -Source "Puppet" -EntryType Information -EventId 1 -Message "Agent Migration: Running puppet agent -t . . . "
puppet agent -t
Write-EventLog -LogName Application -Source "Puppet" -EntryType Information -EventId 1 -Message "Agent Migration: Puppet agent run complete."
