#!/usr/bin/env powershell
$ErrorActionPreference = 'Stop'

function exec($_cmd) {
    write-host " > $_cmd $args" -ForegroundColor cyan
    & $_cmd @args
    if ($LASTEXITCODE -ne 0) {
        throw 'Command failed'
    }
}

Remove-Item artifacts/ -Recurse -ErrorAction Ignore
Remove-Item ./src/MiMsBuildTasks/obj/ -Recurse -ErrorAction Ignore
Remove-Item ./test/Example.Web.Api/obj/ -Recurse -ErrorAction Ignore

exec dotnet restore ./src/MiMsBuildTasks/
exec dotnet pack -c Release ./src/MiMsBuildTasks/
exec dotnet restore ./test/Example.Web.Api/
exec dotnet msbuild /nologo '/t:BandeleroTarget;GringoTarget' ./test/Example.Web.Api/
