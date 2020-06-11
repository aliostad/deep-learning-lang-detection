properties {
    $baseDirectory  = resolve-path .
    $buildDirectory = ($buildDirectory, "$baseDirectory\build") | select -first 1
    $version = "0.3.36"
    $seleniumVersion = "2.40"

    $browserArchiveDirectory="$baseDirectory\browser_archive"

    $shortDescription = "Various utility methods for Selenium from .NET.  (Use jQuery or Sizzle css selectors, wait on ajax operations, check client-side exceptions, switch to/from new window)"
}

import-module .\tools\PSUpdateXML.psm1
. .\psake_ext.ps1

task default -depends TraceSourceControlCommit,Build,RunTests,BuildNuget

task vmtest {

	# http://www.bloof.de/virtualBox_headless

	#param($name,  $baseImage,
	#$ostype = "Windows7_64")
	
	$name = "scripted";
	$ostype = "Windows7_64";

	if (-not (get-command VBoxManag[e])) {
    	Set-Alias VBoxManage $env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe
	}

	$existing = VBoxManage list vms
	
	if ($existing -match ("^`"" + [Regex]::Escape($name) + "`"")) {
		"Deleting vm..."
		VBoxManage unregistervm $name --delete
	}

	"Creating vm..."
	exec { $createOutput = VBoxManage createvm --name $name --ostype Windows7_64 --register }
	
	exec { $uuid = switch -regex ($createOutput) { "UUID: (.*)" { $matches[1] } } }

	Assert ($uuid -is [string]) "Unable to detect UUID of created VM"
	
	exec { VBoxManage modifyvm $name --memory 256 --acpi on --boot1 dvd --nic1 nat }
	
	$imagePath = "$baseDirectory\build\TempDrive.vhd"
	exec { vboxmanage clonehd 'D:\IE VHDs\Win7_IE8.vhd' $imagePath --format VHD }

	exec { VBoxManage storagectl $name --name "IDE Controller" --add ide }
	exec { VBoxManage storageattach $name --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium $imagePath }
	#VBoxManage storageattach machineA --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium /path/to/debian-503-i386-businesscard.is
}

task TraceSourceControlCommit {
    git log -1 --oneline | % { "Current commit: " + $_ }
}

task Cleanup {
    if (test-path $buildDirectory) {
        rm $buildDirectory -recurse
    }
}

task GenerateAssemblyInfo {
	
	$projectFiles = ls -path $base_dir -include *.csproj -recurse

    $projectFiles | write-host
	foreach($projectFile in $projectFiles) {
		
		$projectDir = [System.IO.Path]::GetDirectoryName($projectFile)
		$projectName = [System.IO.Path]::GetFileName($projectDir)
		$asmInfo = [System.IO.Path]::Combine($projectDir, [System.IO.Path]::Combine("Properties", "AssemblyInfo.cs"))
				
		Generate-Assembly-Info `
			-file $asmInfo `
			-title "$projectName $version.0" `
			-description $shortDescription `
			-company "n/a" `
			-product "SizSelCsZzz $version.0" `
			-version "$version.0" `
			-fileversion "$version.0" `
			-copyright "Copyright © Frank Schwieterman 2011" `
			-clsCompliant "false"
	}
}

task Build -depends Cleanup,GenerateAssemblyInfo {
    $v4_net_version = (ls "$env:windir\Microsoft.NET\Framework\v4.0*").Name
    $dearlySolution = "$baseDirectory\dearly.sln"

    exec { &"C:\Windows\Microsoft.NET\Framework\$v4_net_version\MSBuild.exe" SizSelCsZzz.sln /T:"Clean,Build" /property:OutDir="$buildDirectory\" }    
}

task ConfigureTests {

    function set-applicationSetting ([string]$name, [string]$value) {
        set-xml -exactlyOnce "//configuration/applicationSettings/*/setting[@name='$name']/value" $value
    }

    update-xml "$buildDirectory\SizSelCsZzz.Test.dll.config" {
        set-applicationSetting "BrowserArchivePath" $browserArchiveDirectory
    }
}

task RunTests -depends Build,ConfigureTests {
    $nunitConsole = $(resolve-path $baseDirectory\packages\NUnit.Runners*\tools\nunit-console.exe)

    exec { & $nunitConsole "$buildDirectory\SizSelCsZzz.Test.dll" -xml:"$buildDirectory\TestResults.xml" -exclude:"unsupported" }
}

task BuildNuget {

    $nugetTarget = "$buildDirectory\nuget"
	
	if (test-path $nugetTarget) {
		rm $nugetTarget -force -recurse
	}

    $null = mkdir "$nugetTarget\lib\"
    $null = mkdir "$nugetTarget\tools\"

    cp "$buildDirectory\SizSelCsZzz.dll" "$nugetTarget\lib\"
    cp "$buildDirectory\SizSelCsZzz.pdb" "$nugetTarget\lib\"
	cp "$baseDirectory\SizSelCsZzz\SizSelCsZzz.nuspec" "$nugetTarget\"

    update-xml "$nugetTarget\SizSelCsZzz.nuspec" {

        for-xml "//package/metadata" {
            set-xml -exactlyOnce "//version" "$version.0"
            set-xml -exactlyOnce "//description" $shortDescription
            set-xml -exactlyOnce "//releaseNotes" "Built against Selenium Webdriver $seleniumVersion"

            set-xml -exactlyOnce "//dependencies" ""
            append-xml -exactlyOnce "//dependencies" "<dependency id=`"Newtonsoft.Json`" version=`"6.0`" />"
            append-xml -exactlyOnce "//dependencies" "<dependency id=`"Selenium.WebDriver`" version=`"$seleniumVersion`" />"
            append-xml -exactlyOnce "//dependencies" "<dependency id=`"Selenium.Support`" version=`"$seleniumVersion`" />"
        }
    }

	exec { & "$baseDirectory\tools\nuget.exe" pack "$nugetTarget\SizSelCsZzz.nuspec" -output "$nugetTarget\" }
}
