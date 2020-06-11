#
# Manage_User.ps1
#


Function User-Menu {

    Param (
        [string]$Title = "User Menu"
    )

    Write-Host "-- What would you like to do with this user account? --"
    Write-Host
    Write-Host "1: Disable, remove groups and move to Disabled OU"
    Write-Host "2: Disable this account"
    Write-Host "3: Remove group memberships for this account"
    Write-Host "4: Move account to Disabled OU"
    Write-Host "Q: Quit"
}

Function Prompt-User {

    Clear-Host
    
    Write-Host "=== Search for AD user account ==="
    Write-Host
    Write-Host "-- Please enter details or leave blank for wildcard search --"
    Write-Host
    $GivenName = Read-Host -Prompt "Enter Firstname"
    $Surname = Read-Host -Prompt "Enter Surname"
    $SamAccountName = Read-Host -Prompt "Enter Username"

    If ($SamAccountName) {
        $User = Get-ADUser -Filter {SamAccountName -like $SamAccountName}
    }

    ElseIf ($Surname -and $GivenName){
        $User = Get-ADUser -Filter {GivenName -like $GivenName -and Surname -like $Surname}
    }

    ElseIf ($GivenName -and -not $Surname){
        $User = Get-ADUser -Filter {GivenName -like $GivenName}
    }

    ElseIf ($Surname -and -not $GivenName){
        $User = Get-ADUser -Filter {Surname -like $Surname}
    }

    ElseIf (-Not $GivenName -and -not $Surname){
        Write-Host
        Write-Warning Please enter something!
        Read-Host
        Prompt-User
    }

    If ($User){
        If ($User.GetType().IsArray) {
            $User | Format-Table -Property Name, Enabled, SamAccountName
            Write-Host
            Write-Warning "Multiple users found"
            $samAccountName = Read-Host "Please confirm username"
            $User = Get-ADUser -Identity $samAccountName
        }
        
        Write-Host
        Write-Host "Found $($User.Name)"
        Write-Host
        
        Do {
            Clear-Host
            User-Menu
            Write-Host
            $Input = Read-Host "Enter option"
            Write-Host

            Switch ($Input){
                1 {
                    "Option 1"
                }
                2 {
                    If ($User.Enabled){
                        Write-Host "$($User.Name) is a currently enabled" -ForegroundColor Green
                    }
                    Else{
                        Write-Host "$($User.Name) is a disabled" -ForegroundColor Red
                    }
                    Write-Host
                    Write-Warning "Disabling user account.."
                    Write-Host
                }
                3 {
                    Write-Host "$($User.Name) is a member of the following groups:"
                    Get-ADPrincipalGroupMembership -Identity $User | Format-Table -Properties Name
                    Write-Host
                    Write-Warning "Removing groups.."
                    Write-Host
                }
                
            }
            Read-Host
        }
        Until ($Input -eq 'Q')

        


    }
    Else {
        Write-Host
        Write-Warning "No users found!"
    }
}

Prompt-User

