$d0 = "d:\outputs\nighttest"

$d = Join-Path $d0 $(get-date -Format "yyyy-MM-dd_HH-mm-ss")
md $d

cd C:\Windows\Microsoft.NET\Framework\v2.0.50727\
foreach($fn in dir *.dll)
{
    $f = Split-Path -Leaf $fn
    $sdf = "$f.sdf"
    $out1 = Join-Path $d "$f.1.out"
    $out2 = Join-Path $d "$f.2.out"
    $err1 = Join-Path $d "$f.1.err"
    $err2 = Join-Path $d "$f.2.err"
    
    write-host "** Analysis of $f"
    write-host "   First  run started at $(get-date)"
    d:\codecontracts\Microsoft.Research\Clousot\bin\Devlab9\Clousot.exe $fn -premode combined -rep mem -warninglevel full -bounds -nonnull -arrays -sortwarns=false -infer methodensures -suggest methodensures -suggest propertyensures -suggest requires -suggest objectinvariants -infer requires -suggest arrayrequires -adaptive -arithmetic -enum -check assumptions -cacheFileDirectory "$d" -cache -show progress -show progressnum -cacheFileName $sdf > $out1 2> $err1
    if($? -ne 'True')
    {
        write-host "     FAILED"
        $Failed++
    }
    
    write-host "   Second run started at $(get-date)"
    d:\codecontracts\Microsoft.Research\Clousot\bin\Devlab9\Clousot.exe $fn -premode combined -rep mem -warninglevel full -bounds -nonnull -arrays -sortwarns=false -infer methodensures -suggest methodensures -suggest propertyensures -suggest requires -suggest objectinvariants  -infer requires -suggest arrayrequires -adaptive -arithmetic -enum -check assumptions -cacheFileDirectory "$d" -cache -show progress -show progressnum -cacheFileName $sdf > $out2 2> $err2
    if($? -ne 'True')
    {
        write-host "     FAILED"
        $Failed++
    }
    
    write-host "   Second run ended   at $(get-date)"
}

write-host ""
write-host "Total failed: $Failed"