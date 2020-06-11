#Enable Refiner Count in the specified site collection
#http://melcher.it
#@maxmelcher

param([Parameter(Mandatory = $true, Position = 0)][string] $siteUrl, [switch] $hide)

if ([string]::IsNullOrWhiteSpace($siteUrl))
{
    Write-Host -ForegroundColor red "Param -webUrl is required"
    return
}

Add-PSSnapin Microsoft.SharePoint.Powershell -Ea 0


$web = get-spweb $siteUrl

if (!$web)
{
    throw [string]::Format("Web {0} does not exist. ", $siteUrl)
}

try
{
    $file = $web.GetFile('/_catalogs/masterpage/Display Templates/Filters/Filter_Default.html')
    $filter = [System.Text.Encoding]::ASCII.GetString($file.OpenBinary())
}
catch
{
    throw [string]::Format("Refiner File does not exist. Exception: {0}", $_.Exception)
}
$regex = [regex] '(ShowCounts: )(true|false)'

if ($hide)
{
    $showCount = 'false'
}
else
{
    $showCount = 'true'
}

$filter = $filter -ireplace $regex, [string]::Concat('$1', $showCount)
$file.SaveBinary([System.Text.Encoding]::ASCII.GetBytes($filter))

if ($hide)
{
    $visibilty = "not visible"
}
else
{
    $visibilty = "visible"
}

Write-Host -ForegroundColor Green ([string]::Format( "Refiner Count is {1} for Site {0}", $web.Url, $visibilty));


