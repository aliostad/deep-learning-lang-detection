param($installPath, $toolsPath, $package, $project)

# rename metamodel
Get-ChildItem . -Recurse -Include Global.asax.cs | Foreach-Object { (Get-Content $_) | Foreach-Object { $_ -replace 'new MetaModel', 'new AdvancedMetaModel' } | Set-Content $_ -Force }
# Open Global.asax.cs file
Get-ChildItem . -Recurse -Include Global.asax.cs | %{ $dte.ItemOperations.OpenFile($_) } 
# add using staement
$DTE.ActiveDocument.ProjectItem.FileCodeModel.AddImport("NotAClue.Web.DynamicData")
# save file and close file
$DTE.ActiveDocument.Save()
#$DTE.ActiveDocument.Close()
