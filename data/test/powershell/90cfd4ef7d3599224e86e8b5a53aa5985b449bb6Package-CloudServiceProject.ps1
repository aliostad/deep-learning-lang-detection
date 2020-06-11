[CmdletBinding()]
Param(
    [Parameter(Position=1)]
    [string]$csprojpath,
    [Parameter(Position=1)]
    [string]$outpath = ".\out\"

)

Function Get-File($filter){
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $fd = New-Object system.windows.forms.openfiledialog
    $fd.MultiSelect = $false
    $fd.Filter = $filter
    [void]$fd.showdialog()
    return $fd.FileName
}

if(!$csprojpath){
    $csprojpath = Get-File "Project file (*.csproj)|*.ccproj"
}

msbuild $csprojpath /p:Configuration=Release `
                                /p:DebugType=None `
                                /p:Platform=AnyCpu `
                                /p:OutputPath=$outpath `
                                /p:TargetProfile=Cloud `
                                /t:publish      