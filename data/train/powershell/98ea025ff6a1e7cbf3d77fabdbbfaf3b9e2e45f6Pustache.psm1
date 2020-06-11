[Reflection.Assembly]::LoadFile((Convert-Path ".\lib\Nustache.Core.dll"))
function Invoke-Nustache($template, $data) {
    return [Nustache.Core.Render]::StringToString($template, (Get-Dictionary $data))
}

function Get-Dictionary($data) {
    $dictionary = new-object "System.Collections.Generic.Dictionary``2[[System.String, mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089],[System.String, mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089]]"
    $data.keys | %{
        $dictionary.Add($_, $data.$_)
    }
    return $dictionary
}
