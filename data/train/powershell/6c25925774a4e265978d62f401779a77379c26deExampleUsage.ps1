# Must have the SharePoint 2013 Client dlls installed see:
# http://www.microsoft.com/en-us/download/details.aspx?id=35585
$myScriptPath = (Split-Path -Parent $MyInvocation.MyCommand.Path) 
. "$myScriptPath\Common.ps1"
Add-CSOM


$siteUrl = "https://gb365.sharepoint.com/sites/catalogs"
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)

$username = "roydon@g-b.me" # username@tenant.com for SPOnline
$domain = "perficient"
$password = Read-Host -Prompt "Enter Password" -AsSecureString

# do not set $ctx.Credentials if you want default credentials to be used
#$ctx.Credentials = New-Object System.Net.NetworkCredential($username, $password, $domain)
$ctx.Credentials = New-Object Microsoft.Sharepoint.Client.SharePointOnlineCredentials($username, $password)

$XmlFile = "$myScriptPath\Example-WebSetup.xml"
$xml = New-Object XML
$xml.load($XmlFile);

$Web = $ctx.Web
$ctx.Load($Web)
$ctx.ExecuteQuery()

Add-Webs -Web $Web -Xml $xml.DocumentElement -Context $ctx