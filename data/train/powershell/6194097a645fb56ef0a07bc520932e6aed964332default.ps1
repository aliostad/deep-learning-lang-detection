properties {
  $testMessage = 'Executed Test!'
  $compileMessage = 'Executed Compile!'
  $cleanMessage = 'Executed Clean!'
}

Framework "4.5.1"

task default -depends Test

task Test -depends Compile, Clean { 
  $testMessage
}

task Compile -depends Clean { 
  $compileMessage
}

task Clean { 
  $cleanMessage
}

task ? -Description "Helper to display task info" {
	Write-Documentation
}

task DocumentMsBuild {
   msbuild /?
}

task Build {
  msbuild Azure.PackageMe.sln /t:Rebuild /p:Configuration=$configuration
}

task Publish {
  msbuild Azure.PackageMe.sln /t:Publish /p:Configuration=$configuration
}

task BuildAndPublish -depends Build,Publish
