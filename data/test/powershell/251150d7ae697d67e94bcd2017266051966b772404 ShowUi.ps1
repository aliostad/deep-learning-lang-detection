#ShowUI by Joel Finke and Doglas Finke 

#find-module showUI | Install-Module
#ipmo ShowUi
#See the commands
#gcm -Module ShowUI
<#
$getEventInput = StackPanel -ControlName 'Get-EventLogsSinceDate' {            
    New-Label -VisualStyle 'MediumText' "Log Name"            
    New-ComboBox -IsEditable:$false -SelectedIndex 0 -Name LogName @("Application", "Security", "System", "Setup")            
    New-Label -VisualStyle 'MediumText' "Get Event Logs Since..."            
    Select-Date -Name After            
    New-Button "Get Events" -On_Click {            
        Get-ParentControl |            
            Set-UIValue -passThru |             
            Close-Control            
    }            
} -show            
            
Get-EventLog @getEventInput
#>
Function Test-Pinger {
$statuslabel.Content = 'Pinger: Pinging...'
        if (test-connection $PCName.text -Count 1 -Quiet){
            write-host 'Online'
            $status.Content = 'Status : Online'
            }
            else{
            Write-host 'Offline'
            $status.Content = 'Status : Offline'
            }
$statuslabel.Content = 'Pinger: Ready...'
}



#Pinger

$getCommandInput = New-UniformGrid -ControlName 'Pinger' -Columns 2 {            
    New-label -Content "Enter computer to ping"
    New-TextBox -Name PCName            
    New-label -Content 'Status:' -Name Status
    New-Button "Test" -On_Click { 
        Test-Pinger
    }
    
    New-StatusBar
    New-StatusBar -Items {New-StatusBarItem -Name Statuslabel -Content 'Ready'}             
    
} -show            
            