Function Update-Git
{
    $sourcePaths=@(
        'C:\Users\hanwang\Documents\WindowsPowerShell\Modules\MyToolkit',
        'C:\Users\hanwang\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
    );
    $gitPaths=@(
        "D:\git\my_code\powershell\MyToolkit",
        "D:\git\my_code\powershell\"
    )

    for($i=0; $i -lt $sourcePaths.Length; ++$i){
        
        $a = Get-Item $sourcePaths[$i]

        if($a.Attributes -ne "Directory"){

            Write-Output "Copy to $($gitPaths[$i])\$($a.Name)"

            Copy-Item -Path $sourcePaths[$i] -Destination $gitPaths[$i]
        }
        else{
            Copy-Folder -SourcePath $sourcePaths[$i] -DestinationPath $gitPaths[$i]
        }
    }
}