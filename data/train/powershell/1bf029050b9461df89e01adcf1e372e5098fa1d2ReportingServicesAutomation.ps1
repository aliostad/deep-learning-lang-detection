#powershell script to navigate to local MS Reporting Services webpage, select an option from dropdown, click a button and export output
#URL and ids removed
$ie = New-Object -com "InternetExplorer.Application"
$MSRSwebpage = "URL to MS Reporting Services"
$ie.Navigate($MSRSwebpage)
$doc = $ie.Document
$dropdown = "id of dropdown goes here"
$change = $doc.getElementById($dropdown)
$ie.visible = $true
$wshell = new-object -com wscript.shell
$names = @("collection of names to choose from dropdown") 
$btnSubmit = "id of submit button"
$btn = $doc.getElementById($btnSubmit)
$savedropdown = "button to open dropdown for saving"
$menu_open = $doc.getElementById($savedropdown)
$saveMenu = "id of list of save options"
$menu = $doc.getElementById($saveMenu)

foreach($name in $names){
	($change | where {$_.innerHTML -eq $name}).Selected = $true
	$btn.click()
	while($ie.Busy) {Start-Sleep 1}
	$menu_open.visible = $true
	$exports = $menu.getElementsByTagName("div")
	$export = ($exports | where {$_.innerHTML -like "*(comma delimited)*"}).getElementsByTagName("a")
	($export | where {$_.innerHTML -like "*CSV*"}).click()
	$wshell.appactivate("Save as")
	$wshell.sendkeys("%u")
	$wshell.appactivate("Save as")
	$filepath = "target file path" + $name + ".csv"
	$wshell.SendKeys $filepath
	$wshell.sendkeys("{Enter}")
}
