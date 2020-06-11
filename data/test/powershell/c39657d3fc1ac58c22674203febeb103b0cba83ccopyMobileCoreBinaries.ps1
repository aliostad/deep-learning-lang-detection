param([string]$WinBuildPath, [string]$GroupName, [switch]$Test)

$suffix = ""

if ($Test)
{
    [xml]$xml = gc $env:SDXROOT\public\CoreSystem\Update\publishwindowstest.xml
    $skus = "woafretest", "x86fretest"
}
else
{
    [xml]$xml = gc $env:SDXROOT\public\CoreSystem\Update\copymobilecore.xml
    $skus = "woafre", "x86fre", "woachk", "x86chk"
}

$copyGroup = $xml.CopyProject.CopyGroup | ? { $_.name -eq $GroupName }

$copies = $copyGroup.Copy

foreach ($copy in $copies)
{
    $srcPath = [System.IO.Path]::Combine($copyGroup.srcRoot, $copy.src)
    $destPath = [System.IO.Path]::Combine($copyGroup.destRoot, $copy.dest)
    
    foreach ($file in $copy.FileGroup.File)
    {
        $srcFilePath = [System.IO.Path]::Combine($srcPath, $file)
        
        foreach ($sku in $skus)
        {
            $skuRoot = [System.IO.Path]::Combine($WinBuildPath, $sku)
            $skuSrcFilePath = $srcFilePath.Replace('$(SrcDir)', $skuRoot)

            $skuDestPath = $destPath.Replace("CoreSystemTest", "bin\MobileCore")
            $skuDestPath = $skuDestPath.Replace("CoreSystem", "bin")
            $skuDestPath = $skuDestPath.Replace('$(PublishDir)', "$env:SDXROOT\public\CoreSystem\binaries\$sku")

            if (!(Test-Path $skuDestPath))
            {
                md $skuDestPath
            }
            copy $skuSrcFilePath $skuDestPath
            sd add "$skuDestPath\$file"
        }
    }
}