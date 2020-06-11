param($installPath, $toolsPath, $package, $project)

# Open Global.asax.cs file
Get-ChildItem . -Recurse -Include Global.asax.cs | %{ $dte.ItemOperations.OpenFile($_) } 
# remove using staement
$DTE.ActiveDocument.ProjectItem.FileCodeModel.Remove("NotAClue.Web.DynamicData")
# save file and close file
$DTE.ActiveDocument.Save()
$DTE.ActiveDocument.Close()
Get-ChildItem . -Recurse -Include Global.asax.cs | Foreach-Object { (Get-Content $_) | Foreach-Object { $_ -replace 'new AdvancedMetaModel', 'new MetaModel' } | Set-Content $_ -Force }
