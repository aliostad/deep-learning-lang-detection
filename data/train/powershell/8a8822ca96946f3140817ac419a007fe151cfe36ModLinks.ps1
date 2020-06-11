param(
    [string]$saveLocation = "$env:APPDATA\SpaceEngineersDedicated\Saves\Map",
    [string]$format
)

$format = $format.ToLower()

function cleanPlayers {
    $players = $configXML.SelectNodes("//AllPlayers/PlayerItem", $ns)
    $action = $args[0]; $action2 = $args[1]; [array]$deadPlayers = @{}; [array]$alivePlayers = @{}
    foreach ($player in $players) {
        if ($player.Model) {
            if ($player.IsDead -eq 'true') {
                $deadPlayers += @($player)
                $player.ParentNode.removeChild($player) | Out-Null
            } else {
                    $alivePlayers += @($player)
            }
        } else {
            $npcPlayers += @($player)
            $player.ParentNode.removeChild($player) | Out-Null
        }
    }
    if ($action -eq 'list') {
        Write-Output "Active Players:"
        foreach ($player in $alivePlayers) {
            if ($action2 -eq 'all') {
                Write-Output "$($player.Name) : $($Player.PlayerId)"
            } else {
                Write-Output $($player.Name)
            }
        }
    }
    Write-Output "`n"
    Write-Output "$($deadPlayers.count) Dead players have been cleaned up."
    Write-Output "$($npcPlayers.count) NPC players have been cleaned up."
}

function listMods {
    $mods = $configXML.SelectNodes("//Mods/ModItem", $ns)
    Write-Output "You are running $($mods.count) server mods, listing in $(if ($format) { $format } else { 'list' }) format:"
    foreach ($mod in $mods) {
        $modURI = "http://steamcommunity.com/sharedfiles/filedetails/?id=$($mod.PublishedFileId)"
        $HTML = Invoke-WebRequest -Uri $modURI
        $modTitle = @($html.parsedHTML.getElementsByTagName('title'))[0].innerText.Replace('Steam Workshop :: ','')
        if ($format -eq 'steam') {
            Write-Output "[url=$modURI]$modTitle[/url]"
        } elseif ($format -eq 'html') {
            Write-Output "<a href=`"$modURI`">$modTitle</a>"
        } else {
            Write-Output "Mod $($mod.PublishedFileId): $modTitle"
        }
    }
}

function saveIt {
    $saveFile = "$saveLocation\Sandbox.sbc"
    $configXML.Save($saveFile)
}

if ([xml]$configXML = Get-Content $saveLocation\Sandbox.sbc) {
    $ns = New-Object System.Xml.XmlNamespaceManager($configXML.NameTable)
    $ns.AddNamespace("xsi", "http://www.w3.org/2001/XMLSchema-instance")
    # Loaded stuffs and ready to work


    listMods

    #cleanPlayers list all

    saveIt

} else {
    Write-Ouptut "Unable to load $saveLocation\Sandbox.sbc."
}