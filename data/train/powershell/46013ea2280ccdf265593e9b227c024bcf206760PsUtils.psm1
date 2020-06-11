gci $PSScriptRoot\lib\*.ps1 | % {. $_}

Function Get-Path($target = "Machine") {
    return [System.Environment]::GetEnvironmentVariable("PATH", $target)    
}

Function Add-ToPath($folder, $target = "Machine") {
    $path = Get-Path($target)
    [System.Environment]::SetEnvironmentVariable("PATH", "$path;$folder", $target)
    $env:PATH += ";$folder"
}

Function Get-UserPath() {
    return Get-Path "User"
}

Function Get-SystemPath() {
    return Get-Path "Machine"
}

Function Add-ToSystemPath($folder) {
    Add-ToPath $folder "Machine"  
}

Function Add-ToUserPath($folder) {
    Add-ToPath $folder "User"  
}

Function Show-Path($target = "Machine") {
    $path = Get-Path $target
    return $path.Split(";")    
}

Function Show-UserPath() {
    return Show-Path "User"   
}

Function Show-SystemPath() {    
    return Show-Path "Machine"
}

Function Set-PersistentEnvironmentVariable($var, $value, $target = "User") {
    [System.Environment]::SetEnvironmentVariable($var, $value, $target)
}