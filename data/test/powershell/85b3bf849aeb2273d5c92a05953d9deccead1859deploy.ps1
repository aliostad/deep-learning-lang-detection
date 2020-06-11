Param([string] $version, [string] $environment)
$nuGetRepository = "C:\SoftwareEngineeringEvent\NugetRepo"

$octo = "C:\SoftwareEngineeringEvent\OctopusTools.2.6.1.52\Octo.exe"
$deploymentProjects = @("Deploy OctoSample Database", "Deploy Web Api")

foreach($project in $deploymentProjects) {
  $args = 'create-release --project="' + $project + '" --deployto="' +$environment + '" --version="' + $version + '" --packageversion="' + $version + '" --waitfordeployment --server=http://localhost:8090/api --apikey=API-J9CZIWJ4GBL0P8R3TWGG6IKRDEY'
  
  Write-Host "Start-Process " $octo $args
  
  Start-Process $octo -ArgumentList $args
}
