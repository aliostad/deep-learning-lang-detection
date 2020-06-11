function loadQADsnapin()
{
    if ((Get-PSSnapin -name quest.activeroles.admanagement -ErrorAction SilentlyContinue) -eq $null)
    {
        Add-PSSnapin quest.activeroles.admanagement
    }
}

function createUsers()
{
    $y = 1
    $username = "testuser"
    $password = "beerisfun"
    $ou = "OU=Test,DC=ndtest,DC=domain,DC=local"
    do
    {
        $username = "testuser" + $y
        New-QADUser -Name $username -samAccountName $username -UserPassword $password -ParentContainer $ou
        $y++
    }
    while ($y -le 10000)
}

loadQADsnapin
createUsers