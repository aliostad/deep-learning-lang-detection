
$scope = 2

$ScriptDir = Split-Path $MyInvocation.MyCommand.Path

$files = dir $ScriptDir\..\..\h5\h5ex_t_*.h5

foreach ($f in $files)
{
    $drive = "$($f.Name.Substring(7,$f.Name.Length-10))"
    New-H5Drive $drive "$($f.FullName)" -Scope $scope
}

$drives = (Get-H5Drive | ?{$_.Name -ne 'h5tmp'})

foreach ($d in $drives)
{
    New-H5Group "h5tmp:\$($d.Name)","h5tmp:\$($d.Name)1","h5tmp:\$($d.Name)2","h5tmp:\$($d.Name)3"

    # work around a bug in H5Ocopy
    if (($d.Name -ne 'cmpdatt') -and ($d.Name -ne 'cpxcmpdatt'))
    {
        Copy-H5Item "$($d.Name):\*" "h5tmp:\$($d.Name)"
        Copy-H5Item "$($d.Name):\*" "h5tmp:\$($d.Name)1" -IgnoreAttributes
        Copy-H5Item "$($d.Name):\*" "h5tmp:\$($d.Name)2" -Recurse
        Copy-H5Item "$($d.Name):\*" "h5tmp:\$($d.Name)3" -Recurse -IgnoreAttributes
    }
}

Remove-Item h5tmp:\* -Recurse

c:

foreach ($f in $files)
{
    $drive = "$($f.Name.Substring(7,$f.Name.Length-10))"
    Remove-H5Drive $drive -Scope $scope
}
