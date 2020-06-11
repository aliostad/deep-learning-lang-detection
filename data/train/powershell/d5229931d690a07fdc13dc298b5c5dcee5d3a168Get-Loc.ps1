$clocPath  = "C:\MyPrograms\Cloc\cloc-1.60.exe"

function Get-Loc
{
    param($location="."
    ,
    [switch]$showLang
)
    if($showlang)
    {
        & $clocPath --show-lang
        return
    }

    $commandLine = "$location --csv"
    $clocResult = & $clocPath $location --csv
    $indexOfLineCsvToParse = [array]::IndexOf($clocResult, "")
    if($indexOfLineCsvToParse -lt 0)
    {
        throw "cant get empty line in cloc result"
    }
    $csvToparse = $clocResult[$indexOfLineCsvToParse..($clocResult.Length)]
    $csvFeed = ConvertFrom-Csv $csvToparse -Delimiter ',' | select  files,language,blank,comment,code  

    return  $csvFeed | %{
        return New-Object PSObject  -prop @{
                                    Files = [int]($_.files);
                                    Language = $_.language;
                                    Blank = [int]($_.blank);
                                    Comment = [int]($_.comment);
                                    Code = [int]($_.code);
                               }
                    } 
}
