. ".\parse-teams"

$outlook = new-object -com outlook.application

get-teams | % {

    $team_name = $_.name
    $members = $_.members


    $list = $outlook.CreateItem(7)
    $list.DLName = $team_name
    $list.Save() | out-null

    $members | % {
        "    $_"
        $rcpt = $outlook.Session.CreateRecipient($_)

        $rcpt.Resolve()  | out-null
        $list.AddMember($rcpt) | out-null
    }
    
    "$team_name done"
}
