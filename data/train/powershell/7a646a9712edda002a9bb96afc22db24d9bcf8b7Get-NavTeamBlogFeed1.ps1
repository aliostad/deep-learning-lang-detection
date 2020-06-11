# Get CU posts

$url = 'https://blogs.msdn.microsoft.com/nav/feed/atom/'
[System.Reflection.Assembly]::LoadWithPartialName('System.ServiceModel') | Out-Null
[System.ServiceModel.Syndication.SyndicationFeed] $feed = [System.ServiceModel.Syndication.SyndicationFeed]::Load([System.Xml.XmlReader]::Create($url))
#$feed | Get-Member

$cuItems = $feed.Items `
| Where-Object { ($_.Categories.Name -contains 'Announcements') -and ($_.Categories.Name -contains 'Cumulative Updates') } `
| Select-Object @{Name='Title'; Expression={"$($_.Title.Text)"}}, @{Name='KB'; Expression={
    $r = Invoke-WebRequest $_.Id
    $link = $r.Links | Where-Object { $_.innerText -like 'KB *' }
    ($link.innerText -split ' ')[1]
}}, Id `
| Select-Object *, @{Name='HotfixUrl'; Expression={
    "https://support.microsoft.com/en-us/hotfix/kbhotfix?kbnum=$($_.KB)&kbln=en-us&sd=mbs"
}}

$cuItems | Format-Table -Property Title, HotfixUrl
