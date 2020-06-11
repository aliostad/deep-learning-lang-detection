function loadQADsnapin()
{
    if ((Get-PSSnapin -name quest.activeroles.admanagement -ErrorAction SilentlyContinue) -eq $null)
    {
        Add-PSSnapin quest.activeroles.admanagement
    }
}

function doSales()
{
    Get-QADUser -Department "Sales" | ForEach-Object {
        if ($_.ParentContainerDN -ne "OU=Sales,OU=Company ABC,DC=ndtest,DC=domain,DC=local")
        {
            Move-QADObject $_ -NewParentContainer "OU=Sales,OU=Company ABC,DC=ndtest,DC=domain,DC=local"
        }
    }
}

loadQADsnapin
doSales