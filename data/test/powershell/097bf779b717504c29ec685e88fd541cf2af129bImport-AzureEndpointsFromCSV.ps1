# Arguments.
param 
(
	[Microsoft.WindowsAzure.Commands.ServiceManagement.Model.ServiceOperationContext]$vm = $(throw "'vm' 参数是必须的。"), 
	[string]$csvFile = $(throw "'csvFile' 参数是必须的。"),
	[string]$parameterSet = $(throw "'parameterSet' 参数是必须的。")
)
#Get-ChildItem "${Env:ProgramFiles(x86)}\Microsoft SDKs\Azure\PowerShell\*.dll" -Recurse | ForEach-Object {[Reflection.Assembly]::LoadFile($_) | out-null }

# Add endpoints without loadbalancer.
if ($parameterSet -eq "NoLB")
{
    Write-Host -Fore Green "Adding NoLB endpoints:"
    $endpoints = Import-Csv $csvFile -header Name,Protocol,PublicPort,LocalPort,DirectReturn -delimiter ',' | foreach {
		New-Object PSObject -prop @{
			Name = $_.Name;
			Protocol = $_.Protocol;
			PublicPort = [int32]$_.PublicPort;
			LocalPort = [int32]$_.LocalPort;
            DirectReturn =[bool]::Parse($_.DirectReturn);
		}
    }

    # Add each endpoint.
    Foreach ($endpoint in $endpoints)
    {
      
	   $r=Add-AzureEndpoint -VM $vm -Name $endpoint.Name -Protocol $endpoint.Protocol.ToLower() -PublicPort $endpoint.PublicPort -LocalPort $endpoint.LocalPort -DirectServerReturn $endpoint.DirectReturn
    }
}
# Add endpoints with loadbalancer.
elseif ($parameterSet -eq "LoadBalanced")
{
    Write-Host -Fore Green "Adding LoadBalanced endpoints:"
    $endpoints = Import-Csv $csvFile -header Name,Protocol,PublicPort,LocalPort,LBSetName,ProbePort,ProbeProtocol,ProbePath,DirectReturn -delimiter ',' | foreach {
		New-Object PSObject -prop @{
			Name = $_.Name;
			Protocol = $_.Protocol;
			PublicPort = [int32]$_.PublicPort;
			LocalPort = [int32]$_.LocalPort;
			LBSetName = $_.LBSetName;
			ProbePort = [int32]$_.ProbePort;
			ProbeProtocol = $_.ProbeProtocol;
			ProbePath = $_.ProbePath;
            DirectReturn =[bool]$_.DirectReturn;
		}
    }

    # Add each endpoint.
    Foreach ($endpoint in $endpoints)
    {
      $r= Add-AzureEndpoint -VM $vm -Name $endpoint.Name -Protocol $endpoint.Protocol.ToLower() -PublicPort $endpoint.PublicPort -LocalPort $endpoint.LocalPort -LBSetName $endpoint.LBSetName -ProbePort $endpoint.ProbePort -ProbeProtocol $endpoint.ProbeProtocol -ProbePath $endpoint.ProbePath  -DirectServerReturn $endpoint.DirectReturn
    }
}
else
{
    $(throw "$parameterSet is not supported. Allowed: NoLB, LoadBalanced")
}

# Update VM.
Write-Host -Fore Green "更新 虚机..."
$vm | Update-AzureVM 
Write-Host -Fore Green "完成."