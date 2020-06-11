<#
    .Synopsis
    Install module
    Inspiration from: http://blogs.technet.com/b/heyscriptingguy/archive/2010/01/19/hey-scripting-guy-january-19-2010.aspx
#>

Function Copy-Module([string]$Name) {
    $UserPath = $env:PSModulePath.split(";")[0]
    $ModulePath = Join-Path -Path $userPath -ChildPath (Get-Item -Path $name).basename
    If(-not(Test-Path -Path $modulePath)) {
        New-Item -Path $modulePath -ItemType directory | Out-Null
        Copy-item -Path $name -Destination $ModulePath | Out-Null
    }
    Else { 
    Copy-item -path $name -destination $ModulePath | Out-Null
    }
}

Get-ChildItem -Path $path -Include *.psm1,*.psd1 -Recurse |
Foreach-Object { Copy-Module -Name $_.fullName }

