<#
 https://www.gitignore.io/docs
#>

. ($here + "\Scripts\WebClientProxied.ps1") -force

Set-Alias gig gig3

#For PowerShell v3
Function gig3 {
  param(
    [Parameter(Mandatory=$true)]
    [string[]]$list
  )
  $params = $list -join ","
  # Invoke-WebRequest -Uri "https://www.gitignore.io/api/$params" | select -ExpandProperty content | Out-File -FilePath $(Join-Path -path $pwd -ChildPath ".gitignore") -Encoding ascii
  Invoke-WebRequest -Uri "https://www.gitignore.io/api/$params" | select -ExpandProperty content
}

#For PowerShell v2
Function gig2 {
  param(
    [Parameter(Mandatory=$true)]
    [string[]]$list
  )
  $params = $list -join ","
  # $wc = New-Object System.Net.WebClient
  $wc = New-WebClientProxied
  # $wc.Headers["User-Agent"] = "PowerShell/" + $PSVersionTable["PSVersion"].ToString()
  # $wc.DownloadFile("https://www.gitignore.io/api/$params", "$PWD\.gitignore")
  $output = $wc.DownloadString("https://www.gitignore.io/api/$params")
  Write-Host "$output"
}
