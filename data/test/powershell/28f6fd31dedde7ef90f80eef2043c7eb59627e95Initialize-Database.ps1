Function Initialize-Database {
    [cmdletbinding()]
    Param(        
        [parameter(Mandatory=$true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] #No value
        [string]$database        
    )
    Begin {
        
        <#
            Helper function to show usage of cmdlet.
        #>
        Function Show-Usage {
        
            Show-InfoMessage "Usage: Initialize-Database -database [database]"  
            Show-InfoMessage "database: portal for MAX Portal Database"
            Show-InfoMessage "database: pricing for MAX Pricing Database"
        }
    }
    Process {
        
        $workingDir = (Get-Item -Path ".\" -Verbose).FullName
        $sourceRootDir = "C:\Workspaces\Code\Dev"
        $databaseToMigrate = "";

        switch($database)
        {
            "portal"
                {                     
                    $databaseToMigrate = "MaxPortal"
                    break                    
                }

            "pricing"
                {                    
                    $databaseToBackup = "MaxPricing"
                    break
                }
            
            default {
                Show-InfoMessage "Invalid Database"
                Show-Usage
                return
            }
        }
        
        <# First, restart SQL Server to drop any open connections #>

        $sqlServiceCommand = "net stop MSSQLSERVER"
        Invoke-Expression -Command:$sqlServiceCommand
        
        $sqlServiceCommand = "net start MSSQLSERVER"
        Invoke-Expression -Command:$sqlServiceCommand

        <# Second, back up the database #>
        Invoke-DBBackup $database
        
        <# Third, use RAKE command to rebuild database #>

        $rakeCommand = "bundle exec rake ""db:" + $database.ToString() + ":rebuild""";

        cd $sourceRootDir

        Invoke-Expression -Command:$rakeCommand        

        <# Lastly, restart IIS #>

        $iisCommand = "iisreset"
        Invoke-Expression -Command:$iisCommand
        
        cd $workingDir
    }
}