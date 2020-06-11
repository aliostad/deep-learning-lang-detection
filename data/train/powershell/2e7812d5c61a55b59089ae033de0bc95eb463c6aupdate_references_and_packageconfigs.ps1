# Purpose of this powershell script is to update a reference e.g. Pms.ServiceBus.Contracts 6.0.0 to Pms.ServiceBus.Contracts 6.1.0
# The .csproj files and the nuget package.config files and the .nuspec files will be updated
# These changes will be put on a feature branch and pushed to the remote repository.
#
# Remarks:
# This script will not add any assembly redirects in config files.
# This script is only usable when all the versions of the dlls within the nuget package are the same. So it's not usable for e.g. the devart package.

$baseFolder = "C:\git\afc"
$packageIdToUpgrade = "Pms.ServiceBus.Contracts"
$newAssemblyVersion = "6.2.0.0"
$newPackageVersion = "6.2.0-B0014"
$branchName = "" #branchname for your feature - leave empty for default: feature/$packageIdToUpgrade$newPackageVersion

. $PSScriptRoot\manage_nuget.ps1


function UpdatePackagesConfig{
    param($Folder)

    $pacackageConfigs = Get-ChildItem -Path $Folder -Recurse -Filter packages.config;

    Write-Host "Found following package.config files: ";
    $pacackageConfigs |% { Write-Host $_.Fullname };

    $somePackagesAreChanged = $false;

    Foreach($packageconfig in $pacackageConfigs){        
        $xmlPath = $packageconfig.FullName;
        [xml] $xml = Get-Content $xmlPath

        $nodesToChange = $xml.packages.package | where { $_.id -eq $packageIdToUpgrade }

        $nodesToChange |% { $_.version=$newPackageVersion }

        if($nodesToChange){
            $xml.Save($xmlPath)
            $somePackagesAreChanged = $true;
            Write-Host "Updated $xmlPath"
        }
    }
    return $somePackagesAreChanged;
}

function UpdateProjectFiles{
    param($Folder)

    $csProjFiles = Get-ChildItem -Path $Folder -Recurse -Filter *.csproj;

    Write-Host "Found following .csproj files: ";
    $csProjFiles |% { Write-Host $_.Fullname };

    $someProjectFilesAreChanged = $false;

    Foreach($projFile in $csProjFiles){        
        $xmlPath = $projFile.FullName;

        [xml] $xml = Get-Content $xmlPath

        $referenceNodes = $xml.Project.ItemGroup.Reference

        $nodesToChange = $referenceNodes | where {$_.Include -Match '{0}($|,)' -f $packageIdToUpgrade }
        
        if($nodesToChange){
            $nodesToChange.Include = $nodesToChange.Include -replace "Version=.+?($|,)", ('Version={0}$1' -f $newAssemblyVersion)
            $nodesToChange.HintPath = $nodesToChange.HintPath -replace "\\packages\\.+?\\lib\\","\packages\$packageIdToUpgrade.$newPackageVersion\lib\"

            $xml.Save($xmlPath)
            $someProjectFilesAreChanged = $true;
            Write-Host "Updated $xmlPath"
        }
    }

    return $someProjectFilesAreChanged;
}

function UpdateNuspecFiles{
    param($Folder)

    $nuspecFiles = Get-ChildItem -Path $Folder -Recurse -Filter *.nuspec;

    Write-Host "Found following *.nuspec files: ";
    $nuspecFiles |% { Write-Host $_.Fullname };

    $someNuSpecFilesAreChanged = $false;

    Foreach($nuspecFile in $nuspecFiles){        
        $xmlPath = $nuspecFile.FullName;
        [xml] $xml = Get-Content $xmlPath

        $NsMgr = New-Object System.Xml.XmlNamespaceManager($Xml.NameTable)
        $NsMgr.AddNamespace("ns", "http://schemas.microsoft.com/packaging/2011/08/nuspec.xsd")
	    $dependencyNodes = $Xml.SelectNodes("//ns:dependency", $NsMgr)

        $nodesToChange = $dependencyNodes | where { $_.id -eq $packageIdToUpgrade }
        $nodesToChange |% { $_.version=$newPackageVersion }

        if($nodesToChange){
            $xml.Save($xmlPath)
            $someNuSpecFilesAreChanged = $true;
            Write-Host "Updated $xmlPath"
        }
    }
    return $someNuSpecFilesAreChanged;
}

function ExitWhenGitStatusNotClean{
    
    Write-Host ("Checking git status for {0}" -f $_.Fullname)

    $gitStatus = &git status --porcelain;

    $gitStatusLines = ($gitStatus -split '[\r\n]') |? {$_} 
    $gitStatusLines 

    $gitStatusLines |% { 
        if(-not $_.StartsWith("??")){
            Write-Error "There are staged or modified tracked files, script is aborting!";
            Exit
        }
    }
    Write-Host ("Git status OK for {0}" -f $_.Fullname) 
}

$changedFolders = @()

$moduleFolders = GetAfcModules -Folder $baseFolder
Write-Host "Module folders found:"
$moduleFolders


$moduleFolders |% {      
    cd $_.Fullname        
    ExitWhenGitStatusNotClean;
}


$moduleFolders |% { 
    Write-Host ("Navigating to {0}" -f $_.Fullname)
    cd $_.Fullname

    $packagesGotUpdate = (UpdatePackagesConfig -Folder $_.Fullname)
    Write-Host "Some packages are changed: $packagesGotUpdate"

    $projectFilesGotUpdate = (UpdateProjectFiles -Folder $_.Fullname);
    Write-Host "Some project files are changed: $projectFilesGotUpdate" 

    $nuspecFilesToUpdate = (UpdateNuspecFiles -Folder $_.Fullname);
    Write-Host "Some nuspec files are changed: $nuspecFilesToUpdate"


    if($packagesGotUpdate -or $projectFilesGotUpdate -or $projectFilesGotUpdate)
    {
        $changedFolders += $_.Fullname

        $featureBranchName = "feature/$packageIdToUpgrade$newPackageVersion"
        if($branchName -ne ""){
            $featureBranchName = $branchName
        }

        &git push origin "develop:$featureBranchName" 2>&1 | write-host
        Write-Host "Created remote feature branch $featureBranchName on origin"

        &git checkout -b "$featureBranchName" "origin/$featureBranchName" 2>&1 | write-host
        Write-Host "Checked out local branch for $featureBranchName"

        &git add ./\*\packages.config
        &git add ./\*.csproj
        Write-Host "Added all changed packages.config and *.csproj files"

        &git commit -m "Updated ServiceBus Contracts to $newAssemblyVersion from package $packageIdToUpgrade $newPackageVersion"
        Write-Host "Commited changes"

        &git push origin 2>&1 | write-host
        Write-Host "Pushed changes to origin"

        Write-Host " ------------------------------------ end of processing module $_.Fullname ------------------------------------ "
    }
     
     Write-Host "Pushed branches for following repositories:" 
     Write-Host $changedFolders
}
