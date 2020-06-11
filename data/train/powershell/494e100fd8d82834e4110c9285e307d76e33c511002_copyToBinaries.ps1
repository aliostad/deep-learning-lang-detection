# cls
$rootFolder = (Resolve-Path '..\..\').Path

$packagesFolder = $rootFolder + '\packages'

$binariesFolder = $rootFolder + '\Release\Binaries'

$toolsFolder = $rootFolder + '\Release\Tools'

Write-Host("Copying binaries and tools...")

if(!(Test-Path "$binariesFolder")){ md "$binariesFolder";}

Copy-Item "$packagesFolder\NServiceBus\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus.ActiveMQ\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus.Azure\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus.Host\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus.Host32\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus.Hosting.Azure\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus.Hosting.Azure.HostProcess\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus.Interfaces\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus.NHibernate\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus.Notifications\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus.RabbitMQ\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus.SqlServer\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus.Testing\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus.Timeout.Hosting.Azure\lib\net40\*.*" -Destination $binariesFolder
Copy-Item "$packagesFolder\NServiceBus\tools\*.*" -Exclude *.ps1 -Destination $binariesFolder

#containers

Write-Host("Copying containers...")

if(!(Test-Path "$binariesFolder\containers")){ md "$binariesFolder\containers";}
if(!(Test-Path "$binariesFolder\containers\autofac")){ md "$binariesFolder\containers\autofac";}
if(!(Test-Path "$binariesFolder\containers\castle")){ md "$binariesFolder\containers\castle";}
if(!(Test-Path "$binariesFolder\containers\ninject")){ md "$binariesFolder\containers\ninject";}
if(!(Test-Path "$binariesFolder\containers\spring")){ md "$binariesFolder\containers\spring";}
if(!(Test-Path "$binariesFolder\containers\structuremap")){ md "$binariesFolder\containers\structuremap";}
if(!(Test-Path "$binariesFolder\containers\unity")){ md "$binariesFolder\containers\unity";}

Copy-Item "$packagesFolder\NServiceBus.Autofac\lib\net40\*.*" "$binariesFolder\containers\autofac"
Copy-Item "$packagesFolder\NServiceBus.CastleWindsor\lib\net40\*.*" "$binariesFolder\containers\castle"
Copy-Item "$packagesFolder\NServiceBus.Ninject\lib\net40\*.*" "$binariesFolder\containers\ninject"
Copy-Item "$packagesFolder\NServiceBus.Spring\lib\net40\*.*" "$binariesFolder\containers\spring"
Copy-Item "$packagesFolder\NServiceBus.StructureMap\lib\net40\*.*" "$binariesFolder\containers\structuremap"
Copy-Item "$packagesFolder\NServiceBus.Unity\lib\net40\*.*" "$binariesFolder\containers\unity"

#log4net

$log4NetDit = "$packagesFolder\log4net\lib\net40-full\*"

Copy-Item $log4NetDit -Destination $binariesFolder

#Tools
if(!(Test-Path "$toolsFolder")){ md "$toolsFolder";}

Copy-item "$packagesFolder\NServiceBus.Tools\*" -Destination "$toolsFolder\" -Exclude *.nupkg -Force 

Write-Host("Done copying binaries and tools")

# CustomActions
$res_binaryFolder =  $rootFolder + '\NServiceBus\res-binary\'

Write-Host("Copying Dependencies to $res_binaryFolder")

Copy-Item "$packagesFolder\Particular.CustomActions\lib\net40\*" -Destination $res_binaryFolder -Recurse -force

Write-Host("002_copyToBinaries done.")






