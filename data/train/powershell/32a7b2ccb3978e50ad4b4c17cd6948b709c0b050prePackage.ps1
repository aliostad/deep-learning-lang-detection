# powershell -file "prePackage.ps1" $(Src) $(Target) $(NuSpecFile) $(StrongAssemblyReference)
param ([string]$Src, [string]$Target, [string]$NuSpecFile, [string]$StrongAssemblyReference)

# Copy NuSpec Build Location
Copy-Item $Src$NuSpecFile $($Target + "../" + $NuSpecFile)

# Copy Content Files to Build Location
Copy-Item $($Src + "content/") $($Target + "content/") -Recurse

# Replace Variables in Files
Get-ChildItem $($Target + "*") -Recurse -Include "*.xdt" | ForEach-Object -Process {
    (Get-Content $_) -Replace '\$StrongAssemblyReference\$', $StrongAssemblyReference | Set-Content $_
}