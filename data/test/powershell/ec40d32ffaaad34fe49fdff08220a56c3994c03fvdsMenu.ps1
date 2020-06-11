
#Start of vdsMenu
function vdsMenu
{
 do {
 do {
     Write-Host "Make sure you are connected to a vCenter" -ForegroundColor Yellow
     Write-Host "`nvdsMenu" -BackgroundColor White -ForegroundColor Black
     Write-Host "
     A. Create VDS
     B. Create dvPortgroup
     C. Add hosts to VDS
     D. Load balancing
     E. (L3)TCP/IP stack" #options to choose from
   
     Write-Host "
     X. Previous Menu
     Y. Main Menu
     Z. Exit" -BackgroundColor Black -ForegroundColor Green #return to main menu
    
     $choice = Read-Host "choose one of the above"  #Get user's entry
     $ok     = $choice -match '^[abcdexyz]+$'
     if ( -not $ok) { write-host "Invalid selection" -BackgroundColor Red }
    } until ( $ok )
    switch -Regex ($choice) 
    {
    "A" { CreateVds }
    "B" { AddDpg }
    "C" { HostVds }
    "D" { vdsLoadBalancingMenu }
    "E" { Write-Host This feature is not available yet }
    "X" { vCenterMenu }
    "Y" { MainMenu }  
    }
    } until ( $choice -match "Z" )
}
#end of vdsMenu