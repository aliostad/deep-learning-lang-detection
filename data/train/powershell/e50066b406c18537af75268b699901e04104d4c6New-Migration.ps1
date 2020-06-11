Function New-Migration {
    [cmdletbinding()]
    Param(
        [parameter(Mandatory=$true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] #No value
        [string]$pbi,
        [parameter(Mandatory=$true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] #No value
        [string]$database        
    )
    Begin {
        
        <#
            Helper function to show usage of cmdlet.
        #>
        Function Show-Usage {
        
            Show-InfoMessage "Usage: New-Migration -pbi [pbi] -database [database]"  
            Show-InfoMessage "database: portal for MAX Portal Database"
            Show-InfoMessage "database: pricing for MAX Pricing Database"
        }
    }
    Process {
        
        $workingDir = (Get-Item -Path ".\" -Verbose).FullName
        $sourceRootDir = "C:\Workspaces\Code\Dev"
        $databaseToMigrate = "";
        $migrationDir = "";

        switch($database)
        {
            "portal"
                {                     
                    $databaseToMigrate = "MaxPortal"
                    $migrationDir = $sourceRootDir + "\Data\Max.Migrations.Portal\Migrations"
                    break                    
                }

            "pricing"
                {                    
                    $databaseToBackup = "MaxPricing"
                    $migrationDir = $sourceRootDir + "\PricingService\Max.Migrations.PricingService\Migrations"
                    break
                }
            
            default {
                Show-InfoMessage "Invalid Database"
                Show-Usage
                return
            }
        }
        
        <# Invoke the rake command to create the new database migration #>
                
        $rakeCommand = "bundle exec rake ""db:" + $database.ToString() + ":new_migration[Pbi" + $pbi.ToString() + ", Migration script for PBI " + $pbi.ToString() + "]""";

        cd $sourceRootDir

        Invoke-Expression -Command:$rakeCommand

        <# Get the name of the newly created migration source file and add it to source control #>

        $files = Get-ChildItem -path $migrationDir -File

        $lastFile = $files | sort LastWriteTime | select -last 1

        $tfsCommand = "tf add " + $migrationDir + "\" + $lastFile

        Invoke-Expression -Command:$tfsCommand
        
        cd $workingDir
    }
}