function Deploy(){
	[CmdletBinding(DefaultParameterSetName='Task')]
	param(
		# Task name
		[Parameter(Mandatory=$false, ParameterSetName='Task',Position=0)]
		[string]$Task=$null,

		# List available tasks
		[Parameter(Mandatory=$false, ParameterSetName='List')]
		[switch]$List
	)
	Begin {
		function Run(){
			try{
				scriptcs .\Deployment.csx -loglevel Error `-- -tasks:$Task
				
			} catch{
				 $ErrorMessage = $_.Exception.Message
				Write-Error $ErrorMessage
			}
		}
		function List(){
			try{
				$taskList = @("RunGruntForTest","RunGruntForStage","RunGruntForProd","Releasenotes","Octopack","DeployToTest","DeployToStage","ProductionPackage")
				Write-Output $taskList
			} catch{
				$ErrorMessage = $_.Exception.Message
				Write-Error $ErrorMessage
			}
		}
	}
	Process {
		if ($List){
			List
			return
		}

		Run $Task
	}
}