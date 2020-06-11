<#
 # Run all outlook rules avaiable via powershell
 Inspired by this blog https://msdn.microsoft.com/en-us/magazine/dn189202.aspx 
#>

# invoke the Outlook API 
Add-Type -assembly "Microsoft.Office.Interop.Outlook"
$Outlook = New-Object -comobject Outlook.Application
$namespace = $Outlook.GetNameSpace("MAPI")

# get the inbox folder
$inbox =$namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)


#$MyFolder1 =$namespace.Folders.Item('joe.leibowitz@companyname.com').Folders.Item('NOTIFICATIONS')

# get all rules in stock
$rules = $namespace.DefaultStore.GetRules()
# get the rule names
$rule_names = $rules.name

$show_progress = $false
$include_subfolders = $false

#run all rules one by one
write-host "Running rule: $rule_names one by one"
Foreach ($rule IN $rules)
{

  
  $rule.Execute($show_progress,$inbox,$include_subfolders)

}
write-host "done"
#TODO: create customized rule dynamically
#$rule = $rules.create("My rule1: Receiving Notification",[Microsoft.Office.Interop.Outlook.OlRuleType]::olRuleReceive)
