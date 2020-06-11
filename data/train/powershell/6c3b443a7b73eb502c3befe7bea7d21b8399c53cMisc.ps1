<#
   共通で使用する雑多な関数群
#>

# TODO：肥大化してきた場合、分割を検討

# Typeの配列の取得
Function GetTypeArray
{
    Param($items)

    $list = New-Object 'System.Collections.Generic.List[System.Type]'

    foreach($r in $items)
    {
        $list.Add($r.GetType())
    }

    return $list.ToArray()
}

# IEnumerable型をList<object>型に変換
Function IEnumToList
{
    Param($ienum);


    $list = New-Object 'System.Collections.Generic.List[object]'
    
    foreach($r in $ienum)
    {
        $list.Add($r)
    }

    return $list
}

# ダイアログ表示
Function ShowMsg
{
    Param($message, $title)

    [System.Windows.Forms.MessageBox]::Show($message, $title)
}
