cd Config\
$command = '.\Configure' + $OctopusEnvironmentName +'.bat'  
cmd /c $command | Write-Host

cd ..
$command = 'copy Config\ConnectionStrings.config ConnectionStrings.config'  
cmd /c $command | Write-Host

$command = 'copy Config\Logging.config Logging.config'  
cmd /c $command | Write-Host

$command = 'copy Config\SAHL.Common.Service.config SAHL.Common.Service.config'  
cmd /c $command | Write-Host

$command = 'copy Config\SAHL.Common.X2.config SAHL.Common.X2.config'  
cmd /c $command | Write-Host

Remove-Item .\Config -Force -Recurse | Write-Host