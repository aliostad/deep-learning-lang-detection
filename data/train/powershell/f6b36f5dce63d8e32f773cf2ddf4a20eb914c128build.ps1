$ZipArgs = @('a', '-r', 'FMD_MVC_Application_Template.zip', '.\tmp\*', '-xr!.git')

Remove-Item ./*.zip

Get-ChildItem -recurse ..\packages\*.* -include *.nupkg | foreach-object -process {
    $filename = $_.FullName
    Copy-Item $filename ./tmp/
}

Copy-Item ../"FMD MVC Application"/* ./tmp -recurse
& './7z.exe' $ZipArgs

Copy-Item ./*.zip ../FMD_MVC_Application_VSIX/ProjectTemplates/ -force -verbose

Remove-Item -recurse ./tmp/*
If(Test-Path ./ProjectTemplates){
    Remove-Item -recurse ./ProjectTemplates
}
Remove-Item ./*.vsix
Remove-Item ./*.vsixmanifest