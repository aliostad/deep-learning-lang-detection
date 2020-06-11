
Function Reread
{    
    param
    (
        [string]$file
    )
    $tmp = "C:\users\deverett.APEX\desktop\tmp"
    $result = test-path $tmp
    if($result -eq $false)
    {
        ni $tmp -type d
    }

    $currentPath = get-location
    $UNCPath = $pwd.ProviderPath

    $firstMatch = $file -match "\.\\"
    $secondMatch = $file -match "\\"
    if($firstMatch -eq $true)
    {
        $subfile = $file.Substring(2)
        $file = $subfile
        $completedFile = "$UNCPath\$file"
        
        $newName = "$tmp\$file.COPY"
        $file = "$file.COPY"

        copy $completedFile $newName
        $last = "$tmp\$file"
    }
    elseif($secondMatch -eq $true)
    {        
        copy $file $tmp

        $regex = "[^\\]+$"

        $newName = [regex]::Match($file, $regex).Value
        $last = "$newName.COPY"
        $ren = "$tmp\$newName"
        ren $ren $last
    }
    else
    {
        $pathfile = $UNCPath + "\" + $file

        $newName = "$tmp\$file.COPY"

        copy $pathfile $newName

        $last = "$file.COPY"
    }
    $newLocation = "$tmp\$last"
    cd 'C:\program files (x86)\notepad++'
    .\notepad++.exe $newLocation
    cd $currentPath
}