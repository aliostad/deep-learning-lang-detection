properties {
  $testMessage = 'Executed Test!'
  $compileMessage = 'Executed Compile!'
  $cleanMessage = 'Executed Clean!'
  $deployMessage = 'Executed Deployment'
  $productionFolder = 'C:\\ProductionRelease'
}

task default -depends deploy

task Deploy -depends Test {
	$deployMessage
	$productionFolderExists = Test-Path $productionFolder 
	if(!$productionFolderExists){
		mkdir $productionFolder
	}
	cp . $productionFolder -r -Force
}

task Test -depends Compile, Clean { 
  karma start
}

task Compile -depends Clean { 
  $compileMessage
}

task Clean {
	$productionFolderExists = Test-Path $productionFolder 
	if($productionFolderExists){
		rm -r $productionFolder -Force	
	}
	Write-Host "Folder Cleanup"
}

task ? -Description "Helper to display task info" {
	Write-Documentation
}