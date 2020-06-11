##BEGIN json2json.ps1 ##
#"TRANSP": "OPAQUE",のカンマを後続行しだいで削除する。
#ファイルパスの作成
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]

#入力
$inRecords = Get-Content $inputFilePath -Encoding UTF8

#出力オブジェクトを格納する配列（初期値＝空の配列）
$outRecords=@()

#入力オブジェクト配列要素を列挙
$saveString1 = ""
$saveString2 = ""
foreach($inRecord in $inRecords)
{
    if ($inRecord -match ".+OPAQUE.+") {
        $saveString1 = $inRecord
        $saveString2 = $inRecord -replace(",$", "")
    }
    else {
        if ($inRecord -match "^}") {
            if ($saveString2 -ne "") {
                $outRecords += $saveString2
                $saveString2 = ""
                $saveString1 = ""
            }
        } 
        elseif ($inRecord -match ".+CATEGORIES.+") {
            if ($saveString1 -ne "") {
                $outRecords += $saveString1
                $saveString1 = ""
                $saveString2 = ""
            }
        }
        else {
        }
        $outRecords += $inRecord
    }
}
#出力配列を出力
$outRecords | Out-File $outputFilePath -Encoding UTF8
##END json2json.ps1 ##