### Load SharePoint SnapIn
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin Microsoft.SharePoint.PowerShell
}
### Load SharePoint Object Model
[System.Reflection.Assembly]::LoadWithPartialName(“Microsoft.SharePoint”)

$siteName = [Your site name] # e.g. http://www.contoso.com/sites/km
$librarypath = [Your library path] #e.g. /sites/km/documents
$fieldName = [Your field name] e.g. isEnable (usually internal name)

$site = get-spsite $siteName
$web = $site.openweb()
$web.title

$list = $web.GetList($libraryPath)
$list.title

$field = $list.Fields[$fieldName]

$field
$field.ShowInDisplayForm = 0
$field.ShowInEditForm = 0
$field.ShowInListSettings = 0
$field.ShowInVersionHistory = 0
$field.ShowInNewForm = 0
$field.ShowInViewForms = 0
$field.Update()

$web.dispose()
$site.dispose()