$scriptRoot = Split-Path (Resolve-Path $myInvocation.MyCommand.Path)

properties {
    $projectName = "MobileDeviceDetector.Build"
    $buildFolder = Resolve-Path .. 
    $buildNumber = "15"
    $outputFolder = "$buildFolder\Output" 
}

task Package -depends Init, Create-Package, Clean {
}

task Init {
    if (Test-Path "$buildFolder\Output") {
        Remove-Item -Recurse -Force "$buildFolder\Output"         
    }

    if (Test-Path "$buildFolder\Empty") {
        Remove-Item -Recurse -Force "$buildFolder\Empty"         
    }

    New-Item "$buildFolder\Empty" -type directory    
    New-Item "$buildFolder\Output" -type directory    
    New-Item "$buildFolder\Output\bin" -type directory    
}

task Copy-Files {
    Copy-Item $buildFolder\MobileDeviceDetector\bin\Sitecore.SharedSource.MobileDeviceDetector.dll $outputFolder\bin -Force -Verbose
    Copy-Item $buildFolder\MobileDeviceDetector\bin\Sitecore.SharedSource.MobileDeviceDetector.pdb $outputFolder\bin -Force -Verbose
    Copy-Item $buildFolder\MobileDeviceDetector\bin\FiftyOne.Foundation.dll $outputFolder\bin -Force -Verbose
    Copy-Item $buildFolder\MobileDeviceDetector\App_Config\ $outputFolder -Force -Recurse -Verbose
    Copy-Item $buildFolder\MobileDeviceDetector\App_Data\ $outputFolder -Force -Recurse -Verbose
    Copy-Item $buildFolder\MobileDeviceDetector\Data\ $outputFolder -Force -Recurse -Verbose
}

task Create-Package  -depends Compile, Copy-Files {
   exec { .\Tools\Courier\Sitecore.Courier.Runner.exe /source:$buildFolder\Empty /target:$outputFolder /output:"$buildFolder\Mobile Device Detector.update" }
}

task Compile { 
  exec { msbuild $buildFolder\Sitecore.SharedSource.MobileDeviceDetector.sln /p:Configuration=Release /t:Build } 
}

task Clean { 
}