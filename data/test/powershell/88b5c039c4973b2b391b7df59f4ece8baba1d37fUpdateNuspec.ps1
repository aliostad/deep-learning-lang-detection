$nuspecFile = "$pwd\nugetpackage\SimpleConfigSections.nuspec"
$nuspec = [xml] (Get-Content $nuspecFile)

$Pshfile = "$pwd\nugetpackage\lib\net35\SimpleConfigSections.dll"
# Now load the assembly
$version =[string] [System.Reflection.Assembly]::Loadfile($Pshfile).GetName().version

$nuspec.package.metadata.version = $version 

(git log -n 1 |
    select -Skip 4 |
    ForEach-Object {
        $release = $_.Trim()
    })

$nuspec.package.metadata.releaseNotes = $release
 
$nuspec.Save($nuspecFile) 
cd nugetpackage
nuget pack 