Function Get-LeagueBySummoner
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
        ParameterSetName='ID')]
        [string[]]$ID,
        [Parameter(Mandatory=$true,
        ParameterSetName='Name')]
        [string[]]$Name,
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        $summoner = Get-Summoner -Name $Name -Region $Region
    }
    ElseIf($PSCmdlet.ParameterSetName -eq 'ID')
    {
        $summoner = Get-Summoner -ID $ID -Region $Region
    }
    $results = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.5/league/by-summoner/" -Parameter $summoner.id
    Foreach($result in $results)
    {
        $summonerName = $summoner | Where-Object {$_.id -eq $result.participantId} | Select-Object -ExpandProperty Name
        $result | Add-Member -MemberType NoteProperty -Name participantName -Value $summonerName
        $result
    }
}

Function Get-LeagueEntryBySummoner
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
        ParameterSetName='ID')]
        [string[]]$ID,
        [Parameter(Mandatory=$true,
        ParameterSetName='Name')]
        [string[]]$Name,
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        $summoner = Get-Summoner -Name $Name -Region $Region
    }
    ElseIf($PSCmdlet.ParameterSetName -eq 'ID')
    {
        $summoner = Get-Summoner -ID $ID -Region $Region
    }
    $results = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.5/league/by-summoner/" -Parameter $summoner.id -Method '/entry'
    Foreach($result in $results)
    {
        $summonerName = $summoner | Where-Object {$_.id -eq $result.participantId} | Select-Object -ExpandProperty Name
        $result | Add-Member -MemberType NoteProperty -Name participantName -Value $summonerName
        $result
    }
}

Function Get-LeagueByTeam
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string[]]$TeamID,
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.5/league/by-team/" -Parameter $TeamID
}

Function Get-LeagueEntryByTeam
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string[]]$TeamID,
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.5/league/by-team/" -Parameter $TeamID -Method '/entry'
}

Function Get-ChallengerLeague
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na',
        [ValidateSet('Solo', 'Team3', 'Team5')]
        [Parameter(Mandatory=$true)]
        [string]$LeagueType
    )
    Switch($LeagueType)
    {
        'Solo'
        {
            $type = 'RANKED_SOLO_5x5'
        }
        'Team3'
        {
            $type = 'RANKED_TEAM_3x3'
        }
        'Team5'
        {
            $type = 'RANKED_TEAM_5x5'
        }
    }
    $league = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.5/league/challenger" -Query "type=$type&"
    $league.entries
}

Function Get-MasterLeague
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na',
        [ValidateSet('Solo', 'Team3', 'Team5')]
        [Parameter(Mandatory=$true)]
        [string]$LeagueType
    )
    Switch($LeagueType)
    {
        'Solo'
        {
            $type = 'RANKED_SOLO_5x5'
        }
        'Team3'
        {
            $type = 'RANKED_TEAM_3x3'
        }
        'Team5'
        {
            $type = 'RANKED_TEAM_5x5'
        }
    }
    $league = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.5/league/master" -Query "type=$type&"
    $league.entries
}