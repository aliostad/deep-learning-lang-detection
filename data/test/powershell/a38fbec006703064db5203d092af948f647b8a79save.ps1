#
#  save.ps1
#  
#  This script extracts out the files I need for the demo and saves them in a local directory.
#
Param(
    $scriptDirectory = (split-path -parent $MyInvocation.MyCommand.Definition),
    $targetDirectory = (Join-Path $scriptDirectory '..\Local'),
    $appDirectory = (Join-Path $scriptDirectory 'app'),
    $chromeDirectory = (Join-Path $scriptDirectory 'ChromeApp'),
    $appxDirectory = (Join-Path $scriptDirectory 'appx')    
)


# If the target directory exists, then recursively delete it.
if (Test-Path $targetDirectory) {
    Remove-Item -Recurse -Force $targetDirectory;
    Write-Host -ForegroundColor Green "+ Cleaning local save directory `"$targetDirectory`"";
}

# Create target directory.
New-Item -Type Directory $targetDirectory | Out-Null;
New-Item -Type Directory "$targetDirectory\app" | Out-Null;
New-Item -Type Directory "$targetDirectory\AppX" | Out-Null;
New-Item -Type Directory "$targetDirectory\ChromeApp" | Out-Null;
Write-Host -ForegroundColor Green "+ Created new build directory `"$targetDirectory`"";

# Copy over the key app files
Copy-Item (Join-Path $appDirectory 'index.html') (Join-Path $targetDirectory 'app\');
Copy-Item -Recurse (Join-Path $appDirectory 'scripts')  (Join-Path $targetDirectory 'app\');
Copy-Item -Recurse (Join-Path $appDirectory 'styles')  (Join-Path $targetDirectory 'app\');
Copy-Item -Recurse (Join-Path $appDirectory 'images')  (Join-Path $targetDirectory 'app\');

#Copy over the ChromeApp files
Copy-Item (Join-Path $chromeDirectory 'nosandbox.json') (Join-Path $targetDirectory 'ChromeApp\manifest.json'); #note: I copy the pre-sandbox version of the manifest over to the manifest.json file to setup the demo
Copy-Item (Join-Path $chromeDirectory 'background.js') (Join-Path $targetDirectory 'ChromeApp\');
Copy-Item (Join-Path $chromeDirectory 'Build-ChromeApp.ps1') (Join-Path $targetDirectory 'ChromeApp\');

#Copy over the AppX files
Copy-Item (Join-Path $appxDirectory 'AppXManifest.xml') (Join-Path $targetDirectory 'AppX\');
Copy-Item (Join-Path $appxDirectory 'mappingfile.txt') (Join-Path $targetDirectory 'AppX\');
Copy-Item (Join-Path $appxDirectory 'Build-AppX.ps1') (Join-Path $targetDirectory 'AppX\');

#Copy over the copy script for the demo
Copy-Item (Join-Path $scriptDirectory 'demo.ps1') $targetDirectory;

Write-Host -ForegroundColor Green "+ Copied files to target directory."
