$users = get-rolemember -identity extranet\UserForumWHUsers
$users += get-rolemember -identity extranet\UserForumWHRegisteredUsers

$props = @{
    InfoTitle = "User Forum WH Users"
    InfoDescription = "Lists the all users imported for the User Forum 2015."
    PageSize = 200
}


    
if($users.Count -eq 0){
    Show-Alert "There are no User Forum users ."
}
else {
    
 
$users |
    Show-ListView @props -ActionData $actionData  -Property @{Label="Full Name"; Expression={$_.Profile.FullName} },
        @{Label="Email"; Expression={ $_.Profile.Email} },
        @{label="Details";Expression={$_.Profile.Comment}},
        @{Label="Last Activity Date"; Expression={ $_.Profile.LastActivityDate}}
}
close-window