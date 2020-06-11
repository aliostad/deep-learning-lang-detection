#
# .SYNOPSIS
# Invokes the Call by Contract (CbC) JavaScript library automated build.
#

[CmdletBinding()]
param (

    #
    # The path to the solution folder.
    #
    [Parameter(
        ValueFromPipeline = $true
    )]
    [string] $SolutionPath = $PWD,
    
    #
    # The path where to put build result.
    #
    [Parameter()]
    [string] $BuildPath = ($SolutionPath | Join-Path -ChildPath build),
    
    #
    # The path where to put temporary build files.
    #
    [Parameter()]
    [string] $TmpPath = ($SolutionPath | Join-Path -ChildPath tmp)
)

#
# Creating directories.
#
$BuildPath, $TmpPath |
    Where-Object -FilterScript { -not ($_ | Test-Path) } |
    ForEach-Object -Process {
        New-Item -ItemType directory -Path $_ | Out-Null
    }
Write-Verbose -Message "Using build path '$BuildPath'."
Write-Verbose -Message "Using tmp path '$TmpPath'."

#
# Clean up.
#
Write-Verbose -Message "Cleaning tmp directory."
$TmpPath |Join-Path -ChildPath * | Remove-Item -Force -Recurse

#
# Fetching tools.
#
$MSBuild = [object].Assembly.Location |
    Split-Path -Parent |
    Join-Path -ChildPath MSBuild.exe
$packagesPath = $SolutionPath | Join-Path -ChildPath packages
$NuGet = Get-ChildItem -Path $packagesPath -Filter NuGet.exe -Recurse |
    Select-Object -First 1 -ExpandProperty FullName
Write-Verbose -Message "Found NuGet at path '$NuGet'."
$ajaxMinLoaded = @([AppDomain]::CurrentDomain.GetAssemblies() |
    Where-Object -FilterScript { $_.GetName().Name -eq 'AjaxMin' }
).Length -eq 1
if (-not $ajaxMinLoaded) {
    $AjaxMin = Get-ChildItem -Path $packagesPath -Filter AjaxMin.dll -Recurse |
        Where-Object -FilterScript {
            ($_.FullName | Split-Path -Parent | Split-Path -Leaf) -eq 'net40'
        } |
        Select-Object -First 1 -ExpandProperty FullName
    Write-Verbose -Message "Loading AjaxMin assembly from path '$AjaxMin'."
    Add-Type -Path $AjaxMin
    Write-Verbose -Message 'Done.'
}
$AjaxMinPath = [Microsoft.Ajax.Utilities.Minifier].Assembly.Location
Write-Verbose -Message "Using AjaxMin at path '$AjaxMinPath'."

#
# Compiling solution.
#
Write-Verbose -Message "Compiling solution with '$MSBuild'."
& $MSBuild /target:clean | Out-Null
& $MSBuild | Out-Null

#
# Init.
#
$TmpPath | Push-Location
$minifier = New-Object -TypeName Microsoft.Ajax.Utilities.Minifier

#
# Creating combined files...
#
"" | Out-File -FilePath cbc.js
"" | Out-File -FilePath cbc.min.js

"cbc.ns", "cbc.assert", "cbc.parse", "cbc.contract" |
    ForEach-Object -Process {
    
        #
        # Copying...
        #
        Write-Verbose -Message "Processing file '$_.js'."
        Write-Verbose -Message ' - Copying to tmp directory...'
        $SolutionPath | Join-Path -ChildPath "cbc\$_.js" | Copy-Item

        #
        # Minifying...
        #
        Write-Verbose -Message ' - Minifying...'
        $sourceCode = Get-Content -Path "$_.js" | Out-String
        $minifier.MinifyJavaScript($sourceCode) |
            Out-File -FilePath "$_.min.js"
       
        #
        # Combining...
        #
        Write-Verbose -Message ' - Combining...'
        Get-Content -Path "$_.js" |
            Where-Object { $_ -notmatch '^\s*///\s*<reference' } |
            Out-File -Append cbc.js
    }

#
# Copying test helpers.
#
Write-Verbose -Message 'Copying test helpers...'
'cbc.testhelpers.js' | ForEach-Object -Process {    
    $SolutionPath| Join-Path -ChildPath "cbc\$_"
} | Copy-Item

#
# Minifying combined...
#
Write-Verbose -Message 'Minifying combined file...'
$sourceCode = Get-Content -Path cbc.js | Out-String
$minifier.MinifyJavaScript($sourceCode) |
    Out-File -FilePath cbc.min.js

#
# Creating NuGet package
#
$nuspecFile = 'cbc.nuspec'
$nuspecFilePath = $SolutionPath | Join-Path -ChildPath "cbc\$nuspecFile"
$nuspecFilePath | Copy-Item
Write-Verbose -Message "Copying nuspec file '$nuspecFilePath'."

$binPath = $SolutionPath | Join-Path -ChildPath 'cbc\bin'
$version = (Get-ChildItem -Path $binPath -Filter cbc.dll -Recurse |
    Sort-Object -Property LastWriteTime -Descending |
    Select-Object -First 1 -ExpandProperty VersionInfo).ProductVersion
Write-Verbose -Message "Updating version token in nuspec file to '$version'."
$nuspecXml = [xml] (Get-Content -Path $nuspecFile)
$nuspecXml.package.metadata.version = $version
$nuspecXml.Save(($PWD | Join-Path -ChildPath $nuspecFile))
Write-Verbose -Message 'Creating NuGet package...'
& $NuGet pack $nuspecFile | Out-Null
Write-Verbose -Message 'Copying NuGet package to build directory...'
$PWD | Get-ChildItem -Filter *.nupkg | Copy-Item -Destination $BuildPath

#
# Post build stuff.
#
Write-Verbose -Message 'Done.'
Pop-Location