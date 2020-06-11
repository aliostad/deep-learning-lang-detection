param(
  [Parameter(Mandatory=$true)]
  [SecureString]
  $ApiKey,
  
  [Parameter(Mandatory=$true)]
  [String]
  $EnvironmentName
)

$envs = Invoke-Octopus -ApiKey $ApiKey -Path Environments
$next = $envs.Links.'Page.Next'
$env = $envs | select -ExpandProperty Items | where -Property Name -EQ $EnvironmentName
while (-not $env -and $next) {
  $envs = Invoke-Octopus -ApiKey $ApiKey -Path $next
  $next = $envs.Links.'Page.Next'
  $env = $envs | select -ExpandProperty Items | where -Property Name -EQ $EnvironmentName
}

if ($env) {
  $machines = Invoke-Octopus -ApiKey $ApiKey -Path $env.Links.Machines
  do {
    foreach ($machine in $machines.Items) {
      Write-Output $machine
    }
    $next = $machines.Links.'Page.Next'
    if ($next) {
      $machines = Invoke-Octopus -ApiKey $ApiKey -Path $next
    } else {
      $next = $null
    }
  }
  while ($next)
}
