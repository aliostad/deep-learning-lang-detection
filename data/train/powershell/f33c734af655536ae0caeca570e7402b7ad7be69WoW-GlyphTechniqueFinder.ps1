# API Documentation = http://blizzard.github.io/api-wow-docs/

$Character = "Girthy"
$Realm = "Bloodscalp"

$FeedURL = "http://us.battle.net/api/wow/character/$Realm/$($Character)?fields=professions"

$WebClient = New-Object net.webclient
$Json = $WebClient.Downloadstring($FeedURL) | ConvertFrom-Json

$PrimaryProfessions = $json.professions.Primary


ForEach ($Profession in $PrimaryProfessions)
    {
        Switch ($Profession.Name)
            {
                "Inscription"
                    {
                        Write-Output $Profession.recipes
                    }
            }
    }


# Recipe Lookup
$RecipeID = '135561'
$FeedURL = "http://us.battle.net/api/wow/recipe/$RecipeID"
$Recipe = $WebClient.Downloadstring($FeedURL) | ConvertFrom-Json

# Item Lookup
$ItemID = '104219'
$FeedURL = "http://us.battle.net/api/wow/item/$ItemID"
$Item = $WebClient.Downloadstring($FeedURL) | ConvertFrom-Json
