#not finished yet
#purpose was to check if a nuspec file references certain dlls which aren't listed in it's dependencies

function GetNuSpecFiles {
    param (
        [string] $folder
    )
    Get-ChildItem -Path $folder -Filter *.nuspec -Recurse
}


function GetAfcModules {
    param (
        [string] $folder
    )
    
    Get-ChildItem -Path $folder -Recurse  -Directory -Filter AFC-*
}


function GetDllPathsFromNuSpec{
    param ( 
        [string] $nuspecPath
    )
   
    [xml] $xml = Get-Content $nuspecPath
    $srcs = $xml.package.files.file.src | where { $_ -like "*.dll" }

    $srcs = $srcs |% { $_ -replace '\$Configuration\$', 'Debug' } 
    $srcs
    #Write-host blqh
    $nuspecDirectory = (Get-Item $nuspecPath).DirectoryName
    
    $absolutePaths = $srcs |% { [System.io.path]::Combine($nuspecDirectory, $_) }
    $absolutePaths
}

. .\manage_assembly.ps1

function GetDllPathsFromNuSpec{
    param ( 
        [string] $nuspecPath
    )
    
    $dllPaths = GetDllPathsFromNuSpec -nuspecPath $_.FullName

    $referencedAssemblies = $dllPaths |% {GetReferencedAssemblies -AssemblyFile $_}
    $referencedAssemblies
}



#$baseFolder = "C:\git"
#$moduleFolders = GetAfcModules -Folder $baseFolder
#$nuspecFilesForModuleFolders = $moduleFolders  |% { GetNuSpecFiles -folder $_.FullName }

$nuspecFilesForModuleFolders |% { GetDllPathsFromNuSpec -nuspecPath $_.FullName }


#$moduleInfos = $moduleFolders |% { GetPackageInfo -Folder $_.FFullName}
