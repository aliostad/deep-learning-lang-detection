#
# Windows PowerShell Profile Setup Scripts for:
# Steven Oliver <oliver.steven@gmail.com>
#

##############################################
# uname clone
##############################################
function wname {            
    $colItems = get-wmiobject -class "Win32_Processor" -computername localhost
    
    $memory = get-mem
    $memory = $memory.ToString() + " MB"     
    
    Write-Host "Platform    - " ([Environment]::OSVersion.Platform.ToString())
    Write-Host "Windows Ver - " ([Environment]::OSVersion.VersionString.ToString())
    Write-Host "Arch        - " $colItems.Description.ToString()
    Write-Host "Processor   - " $colItems.Name.ToString()    
    Write-Host "Speed       - " $colItems.MaxClockSpeed
    Write-Host "Cores       - " $colItems.NumberOfCores
    Write-Host "Memory      - " $memory
    Write-Host "Date        - " (date).ToString()
}

function Get-Mem {
    $a = Get-WmiObject win32_physicalmemory -computername ([Net.DNS]::GetHostName())
    foreach ($b in $a) {
        if ($b.device_locator -ne "SYSTEM ROM") {
            return ($b.capacity/1mb).ToString()
        }
    }
}

##############################################
# Show functions
##############################################
function Show-Time {
    $time = date    
    return "`r`n" + $time.toShortDateString() + " " + $time.toShortTimeString() + "`r`n" 
}

function Show-IP {
    return "`r`n" + (Test-Connection $env:COMPUTERNAME -Count 1).ProtocolAddress + "`r`n"
}

function Show-Debug {
    Write-Host "$" -NoNewline
    Write-Host "DebugPreference = " -NoNewline    
    $DebugPreference
}

function Show-Variable ($var){
    Write-Host $var
}

function Show-Help {
    $money = "$"
    Write-Host ""
    Write-Host -ForegroundColor Green "Show functions"    
    Write-Host "debug       Debug variable"    
    Write-Host "date        Date and time"    
    Write-Host "time        Date and time"    
    Write-Host "ip          Current IP address"
    Write-Host "info        Basic computer info"
    Write-Host "home       "$money"HOME"
    Write-Host "oracle     "$money"ORACLE_HOME"
    Write-Host "help        Display this help"    
    Write-Host ""
    Write-Host "Example usage:    show debug"    
    Write-Host ""
}

function Show {
    switch ($args[0])
    {     
         ("time")       {Show-Time}
         ("date")       {Show-Time}
         ("ip")         {Show-IP}
         ("debug")      {Show-Debug}             
         ("info")       {wname}
         ("home")       {Show-Variable("$HOME")}
         ("oracle")     {Show-Variable("$ORACLE_HOME")}
         ("help")       {Show-Help}         
         
         default        {Write-Host -ForegroundColor Red "Error" -NoNewline; 
                         Write-Host -ForegroundColor White ": " -NoNewline; 
                         write-host "You must supply a valid argument!"; Show-Help;}
    }   
}

##############################################
# Goto functions
##############################################
function Goto {
    switch ($args[0])
    {
        ("scripts")     {set-location "$HOME\My Documents\WindowsPowerShell\Scripts"}
        ("desktop")     {set-location "$HOME\Desktop"}
        ("home")        {Set-Location "$HOME"}
        ("oracle")      {Set-Location "$ORACLE_HOME"}
        ("start")       {Set-Location "C:\"}
    }
}

function Goto-Scripts {
    set-location "$HOME\My Documents\WindowsPowerShell\Scripts"        
}

function Goto-Desktop {
    set-location "$HOME\Desktop"   
}

function Goto-Home {
    set-location "$HOME"        
}

function Goto-Oracle {
    set-location "$ORACLE_HOME"        
}

##############################################
# Prompt setup
##############################################
function shorten-path([string] $path) {
   $loc = $path.Replace($HOME, '~')
   # remove prefix for UNC paths
   $loc = $loc -replace '^[^:]+::', ''   
   return ($loc)
}

function get-adminuser() {
   $id = [Security.Principal.WindowsIdentity]::GetCurrent()
   $p = New-Object Security.Principal.WindowsPrincipal($id)
   return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function prompt {
   # our theme
   $cdelim = [ConsoleColor]::White
   if ( get-adminuser ) {
      $cuser = [ConsoleColor]::Red
   } else {
      $cuser = [ConsoleColor]::Green
   }
   $chost = [ConsoleColor]::White
   $cpath = [ConsoleColor]::Gray
   
   # Create the prompt   
   write-host ([Environment]::UserName) -n -f $cuser
   write-host '@' -n -f $cdelim
   write-host ([Net.DNS]::GetHostName().ToLower()) -n -f $chost   
   write-host ' ' -n -f $cdelim
   write-host (shorten-path (pwd).Path) -n -f $cpath
   write-host ' $' -n -f $cpath
   
   return ' '
}

