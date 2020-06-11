$interop = [System.Runtime.InteropServices.RuntimeEnvironment]
$frameworkPath = $interop::GetRuntimeDirectory()
$msbuild = Join-Path $frameworkPath msbuild.exe

# Build and copy the binary to the lib folder
Invoke-Expression ($msbuild + " ..\InsanelySimpleBlog\InsanelySimpleBlog.csproj /p:Configuration=Release")
Remove-Item lib\* -Recurse
New-Item lib\net40 -ItemType directory
Copy-Item ..\InsanelySimpleBlog\bin\Release\InsanelySimpleBlog.dll .\lib\net40\

# Build and copy the powershell cmdlets to the tools folder
Invoke-Expression ($msbuild + " ..\InsanelySimpleBlog.PowerShell\InsanelySimpleBlog.PowerShell.csproj /p:Configuration=Release")
Remove-Item tools\* -Recurse
Copy-Item ..\InsanelySimpleBlog.PowerShell\bin\Release\*.dll .\tools\
Copy-Item ..\InsanelySimpleBlog\Content\Init.ps1 .\tools\

# Pick up the CSS and script file
Remove-Item content\* -Recurse
New-Item content\Content -ItemType directory
New-Item content\Scripts -ItemType directory
New-Item content\Controllers -ItemType directory
New-Item content\Views -ItemType directory
New-Item content\Views\Blog -ItemType directory
Copy-Item ..\InsanelySimpleBlog\Content\insanelySimpleBlog.css .\content\Content
Copy-Item ..\InsanelySimpleBlog\Content\insanelySimpleBlog.js .\content\Scripts
Copy-Item ..\InsanelySimpleBlog\Content\BlogController.cs.pp .\content\Controllers
Copy-Item ..\InsanelySimpleBlog\Content\Index.cshtml .\content\Views\Blog
Copy-Item ..\InsanelySimpleBlog\Content\web.config.transform .\content\
Copy-Item ..\InsanelySimpleBlog\Content\InsanelySimpleBlog-readme.txt .\content\

nuget pack .\InsanelySimpleBlog.nuspec