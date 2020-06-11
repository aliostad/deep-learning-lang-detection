cls

function Send-Gist {
    param(
        [string]$FileName,
        [string]$Content,
        [Switch]$ShowWebPage
    )

$content = @"
<#
    This Gist was created by ISEGist
    $(Get-Date)    
#>

"@ + $content

    $gist = @{
        "public"= $true
        "description"="Description for $($fileName)"
        "files"= @{
            "$($fileName)"= @{
                "content"= $content
            }
        }
    }
    
    $r = Invoke-RestMethod -Uri 'https://api.github.com/gists' -Method Post -Body ($gist | ConvertTo-Json)
    
    if($ShowWebPage) {
        start $r.html_url
    } else {
        [PSCustomObject]@{
            FileName = $FileName
            WebPage  = $r.html_url
        }
    }
}

function Send-FileGist {
    param(
        $FullName,
        [Switch]$ShowWebPage
    )

    Send-Gist (Split-Path -Leaf $FullName) ([System.IO.File]::ReadAllText($FullName)) -ShowWebPage:$ShowWebPage
}

cls
Send-FileGist .\install.ps1