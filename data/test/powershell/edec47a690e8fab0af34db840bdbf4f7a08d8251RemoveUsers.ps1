$result = Show-ModalDialog -Control "ConfirmChoice" -Parameters @{btn_0="Yes"; btn_1="No"; te="Are you SURE you want to remove all User Forum Users?"; cp="Remove User Forum Users"} -Height 120 -Width 400

if ($result -eq "btn_0"){
    $regUsers = get-rolemember -identity extranet\UserForumWHUsers
    
    #$regUsers
    $ttlRegUsers = $regUsers.Count
    
    Write-output "$ttlRegusers Registered users found"
    
    foreach($user in $regUsers){
        if ($user.domain.Name = "extranet")
        {
            write-output $user.Name
            remove-user -identity $user.Name
        }
    }
    Show-Alert "All users have beeb removed."
}

else {
    Show-Alert "Request Canceled."
}

close-window