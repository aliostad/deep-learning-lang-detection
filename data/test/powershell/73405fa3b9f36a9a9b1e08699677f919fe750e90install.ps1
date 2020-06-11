function CopyFiles ($from, $to) {
    mkdir $to
    Get-ChildItem -Path "$from" | % {
        $name = echo $_.FullName | Resolve-Path -Relative
        echo $name
        Copy-Item "$name" "$to" -Recurse -Force -Container
    }
}

$install_dir = "C:\Program Files (x86)\Vim\"

Remove-Item "$install_dir\vim74\colors\" -Force -Recurse
Remove-Item "$install_dir\vimfiles\bundle\" -Force -Recurse
Remove-Item "$install_dir\vimfiles\autoload\" -Force -Recurse

Copy-Item .vimrc "$install_dir\_vimrc" -Force
cd ".vim\"
CopyFiles "colors" "$install_dir\vim74\colors\"
CopyFiles "bundle" "$install_dir\vimfiles\bundle"
CopyFiles "autoload" "$install_dir\vimfiles\autoload"
cd ..
