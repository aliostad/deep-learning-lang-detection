Param(
    [string] $serviceName,
    [string] $serviceFolder = "c:\services\$serviceName",    
    [string] $tempFolder = "c:\temp\$serviceName",
    [string] $fetchTar,
    [string] $tarball
)

# Terminate script execution if we see an error
$ErrorActionPreference = "Stop"

# Import all modules
function Import-AllModules() {
    $gitModulePath = $PSScriptRoot + "\modules\"
    Get-ChildItem $gitModulePath | Select -ExpandProperty FullName | Import-Module -DisableNameChecking -Force
}

Import-AllModules | Out-Null

function Create-Tempfolder($tempFolder) {
    # If we already have this version - delete it
   $message = ""
   if (Test-Path $tempFolder) {
        $message += "already have $tempFolder, deleting"   
        Remove-Item $tempFolder -Recurse -Force        
   }

    New-Item $tempFolder -type directory | Out-Null    
    return [PSCustomObject]@{
      message = $message
    }
}

function Download-Code($tempFolder) {   
   Create-Tempfolder $tempFolder    
   $message += "downloading from tarball using $fetchTar from $tarball"      
   $nodeOutput = & "node" $fetchTar $tarball $tempFolder
   $message += " " + $nodeOutput
   return [PSCustomObject]@{
      message = $message
   }  
}

function Copy-ToServiceFolder($tempServiceFolder, $serviceFolder) {    
    if (Test-Path "$serviceFolder\*") {
        Remove-Item "$serviceFolder\*" -Recurse    
    }    
    Copy-Item "$tempServiceFolder\*" $serviceFolder -Recurse
}


function Run-HookScript($hookScript) {
  if (Test-Path $hookScript) {    
    & $hookScript -serviceName $serviceName -hmsModules "$PSScriptRoot\modules"
    Remove-Item $hookScript
    return [PSCustomObject]@{
      message = "running script: $startupScript";
      status = 201
    }
  }
    return [PSCustomObject]@{
      message = "did not find: $startupScript";
      status = 404
    }
}

# TODO: nesting means the messaging is a bit off...
function Sync-Code() {  
  Download-Code $tempFolder
  
  $startupScript = "$tempFolder\startup.ps1"
  $startupRun = Run-HookScript $startupScript $serviceName

  if ($startupRun.status -eq 404) {
    # Create default service as fallback
    Create-Service $serviceName $serviceFolder      
  }

  Stop-Service $serviceName
  
  Copy-ToServiceFolder $tempFolder $serviceFolder
    
  return [PSCustomObject]@{
      message = "Code synched"
  }  
}

Sync-Code | ConvertTo-Json
