function show-alias { 
<#
.SYNOPSIS
Displays a list of all the aliases which aren't built in.

.DESCRIPTION
Basically pipes get-alias into a comparison with a big long hard-coded list
of built in aliases

.PARAMETER No parameters
No parameters

.INPUTS
None. You cannot pipe objects to this function

.EXAMPLE
C:\PS> salias
sback                                   show-backups
sback2000                               show-backups2000
sbackup                                 show-backups
sbackup2000                             show-backups2000
sbackups                                show-backups
sbackups2000                            show-backups2000
sbe                                     show-backupexec
sbl                                     show-backuplogs
sbo                                     show-backupoptions
scd2000t                                show-catalog_databases_2000twikistyle
sci                                     show-catalog_instances
scit                                    show-catalog_instancestwikistyle
sfiles                                  show-sqlserverfiles
shh                                     save-history

.LINK
Online list: http://ourwiki/twiki501/bin/view/Main/DBA/PowershellFunctions


#>
	
	Param( [String] $P_Match_String,
         [String] $ShowBuiltins = $False,
         [String] $Display = "Multi",
         [Int][Alias ("Col", "Columns", "c")] $DesiredColumns = 4,
         [Int]$AliasWidth = 8,
         [int]$DefinitionWidth = 20)

  if ($ShowBuiltins -eq $False)
  {
    $BUILTIN_ALIASES = @( `
    "%", # ForEach-Object
    "?", # Where-Object
    "ac", # Add-Content
    "asnp", # Add-PSSnapIn
    "cat", # Get-Content
    "cd", # Set-Location
    "chdir", # Set-Location
    "clc", # Clear-Content
    "clear", # Clear-Host
    "clhy", # Clear-History
    "cli", # Clear-Item
    "clp", # Clear-ItemProperty
    "cls", # Clear-Host
    "clv", # Clear-Variable
    "compare", # Compare-Object
    "copy", # Copy-Item
    "cp", # Copy-Item
    "cpi", # Copy-Item
    "cpp", # Copy-ItemProperty
    "cvpa", # Convert-Path
    "dbp", # Disable-PSBreakpoint
    "del", # Remove-Item
    "diff", # Compare-Object
    "dir", # Get-ChildItem
    "ebp", # Enable-PSBreakpoint
    "echo", # Write-Output
    "epal", # Export-Alias
    "epcsv", # Export-Csv
    "epsn", # Export-PSSession
    "erase", # Remove-Item
    "etsn", # Enter-PSSession
    "exsn", # Exit-PSSession
    "fc", # Format-Custom
    "fl", # Format-List
    "foreach", # ForEach-Object
    "ft", # Format-Table
    "fw", # Format-Wide
    "gal", # Get-Alias
    "gbp", # Get-PSBreakpoint
    "gc", # Get-Content
    "gci", # Get-ChildItem
    "gcm", # Get-Command
    "gcs", # Get-PSCallStack
    "gdr", # Get-PSDrive
    "ghy", # Get-History
    "gi", # Get-Item
    "gjb", # Get-Job
    "gl", # Get-Location
    "gm", # Get-Member
    "gmo", # Get-Module
    "gp", # Get-ItemProperty
    "gps", # Get-Process
    "group", # Group-Object
    "gsn", # Get-PSSession
    "gsnp", # Get-PSSnapIn
    "gsv", # Get-Service
    "gu", # Get-Unique
    "gv", # Get-Variable
    "gwmi", # Get-WmiObject
    "h", # Get-History
    "history", # Get-History
    "icm", # Invoke-Command
    "iex", # Invoke-Expression
    "ihy", # Invoke-History
    "ii", # Invoke-Item
    "ipal", # Import-Alias
    "ipcsv", # Import-Csv
    "ipmo", # Import-Module
    "ipsn", # Import-PSSession
    "ise", # powershell_ise.exe
    "iwmi", # Invoke-WMIMethod
    "kill", # Stop-Process
    "lp", # Out-Printer
    "ls", # Get-ChildItem
    "man", # help
    "md", # mkdir
    "measure", # Measure-Object
    "mi", # Move-Item
    "mount", # New-PSDrive
    "move", # Move-Item
    "mp", # Move-ItemProperty
    "mv", # Move-Item
    "nal", # New-Alias
    "ndr", # New-PSDrive
    "ni", # New-Item
    "nmo", # New-Module
    "nsn", # New-PSSession
    "nv", # New-Variable
    "ogv", # Out-GridView
    "oh", # Out-Host
    "popd", # Pop-Location
    "ps", # Get-Process
    "pushd", # Push-Location
    "pwd", # Get-Location
    "r", # Invoke-History
    "rbp", # Remove-PSBreakpoint
    "rcjb", # Receive-Job
    "rd", # Remove-Item
    "rdr", # Remove-PSDrive
    "ren", # Rename-Item
    "ri", # Remove-Item
    "rjb", # Remove-Job
    "rm", # Remove-Item
    "rmdir", # Remove-Item
    "rmo", # Remove-Module
    "rni", # Rename-Item
    "rnp", # Rename-ItemProperty
    "rp", # Remove-ItemProperty
    "rsn", # Remove-PSSession
    "rsnp", # Remove-PSSnapin
    "rv", # Remove-Variable
    "rvpa", # Resolve-Path
    "rwmi", # Remove-WMIObject
    "sajb", # Start-Job
    "sal", # Set-Alias
    "saps", # Start-Process
    "sasv", # Start-Service
    "sbp", # Set-PSBreakpoint
    "sc", # Set-Content
    "select", # Select-Object
    "set", # Set-Variable
    "si", # Set-Item
    "sl", # Set-Location
    "sleep", # Start-Sleep
    "sort", # Sort-Object
    "sp", # Set-ItemProperty
    "spjb", # Stop-Job
    "spps", # Stop-Process
    "spsv", # Stop-Service
    "start", # Start-Process
    "sv", # Set-Variable
    "swmi", # Set-WMIInstance
    "tee", # Tee-Object
    "type", # Get-Content
    "where", # Where-Object
    "wjb", # Wait-Job
    "write") # Write-Output
  }
  else
  {
    $BUILTIN_ALIASES = @( )
  }
  
  $Aliases = get-alias | where { $BUILTIN_ALIASES -notcontains $_.name } |
    select name, definition |
    sort name

  # Todo: essentially, the columns and rows are going in the wrong direction!
  if ($Display -eq "Multi")
  {

    $CountColumns =0
    foreach ($O in $Aliases) 
    {
  
      $CountColumns++

      [string]$Alias = $O.Name
      [string]$Definition = $O.Definition

      [int]$ThisAliasWidth = [math]::min($AliasWidth, $Alias.length) 
      [int]$ThisDefinitionWidth = [math]::min($DefinitionWidth, $Definition.length) 

      write-debug "`$Alias: $Alias `$ThisAliasWidth: $ThisAliasWidth "
      write-debug "`$Definition: $Definition `$ThisDefinitionWidth: $ThisDefinitionWidth"

      [string]$PrintString = "{0,-$AliasWidth} {1,-$DefinitionWidth}     " -f $Alias.Substring(0, $ThisAliasWidth), $Definition.Substring(0, $ThisDefinitionWidth)
  
      write-host -NoNewline $PrintString
  
      if ($CountColumns -ge $DesiredColumns)
      {
        write-host ""
        $CountColumns = 0
      }
    }
  }
  else
  {
    $Aliases
  }

}
set-alias salias show-alias
set-alias sa show-alias


<#
vim: tabstop=2 softtabstop=2 shiftwidth=2 expandtab
#>


