function Connect-SPOContext{

    # Example Connect-SPOContext -Url "https://vbluzern.sharepoint.com/_layouts/15/start.aspx#/SitePages/Homepage.aspx"

    param(
        [string]$Url
    )
    
    [Reflection.Assembly]::LoadFile((Get-ChildItem -Path $PSlib.Path -Filter "ClaimsAuth.dll" -Recurse).Fullname)
    $Global:SPOContext = New-Object SPOContext((Get-SPUrl $Url).Url)
    $Global:SPOContext
}

function Get-SPOWeb{

    $SPOWeb = $Global:SPOContext.Web
    $Global:SPOContext.Load($SPOWeb)
    $Global:SPOContext.ExecuteQuery()
    Return $SPOWeb
}

# Connect-SPOContext "https://vbluzern.sharepoint.com/Support/SitePages/Homepage.aspx"

function Get-SPOList{

    param(
        $SPOContext,
        $ListName
    )

    $SPOWeb = Get-SPOWeb $SPOContext
    if($SPOWeb -ne $null){
        $SPOLists = $web.Lists
        $SPOContext.Load($SPOLists)
        $SPOLists.ExecuteQuery()
        $SPOList = $SPOLists | where {$_.Title -eq $ListName}
        return $SPOLists
    }
}