
$sw = [System.Diagnostics.Stopwatch]::StartNew()
foreach($i in 1..100)
{
    Invoke-WebRequest  http://localhost:61321/api/memory?bytes=500000 | out-null
}
$sw.Stop()
write-host "Memory test: " + $sw.Elapsed.ToString()
$sw.Reset()

#######################################
# create a file
$localfn = "c:\testing.txt"
New-Item $localfn -type file -force -value (new-object System.String('*', 500000)) | out-null
$sw.Start()
foreach($i in 1..100)
{
    Invoke-WebRequest  http://localhost:61321/api/file?filename="$localfn" | out-null
}
$sw.Stop()
write-host "Local file test: " + $sw.Elapsed.ToString()
$sw.Reset()

#########################################
# create a file
$netfn = "\\it-ep2-engrfs2\public\ENelson\testing.txt"
New-Item $netfn -type file -force -value (new-object System.String('*', 500000)) | out-null
$sw.Start()
foreach($i in 1..100)
{
    Invoke-WebRequest http://localhost:61321/api/file?filename="$netfn" | out-null
    $i++
}
$sw.Stop()
write-host "Network file test: " + $sw.Elapsed.ToString()
$sw.Reset()

#########################################

$sw.Start()
foreach($i in 1..100)
{
    Invoke-WebRequest http://localhost:50807/api/file | out-null
    $i++
}
$sw.Stop()
write-host "Double api local file sync test: " + $sw.Elapsed.ToString()
$sw.Reset()

#########################################

$sw.Start()
foreach($i in 1..100)
{
    Invoke-WebRequest http://localhost:50807/api/fileasync | out-null
    $i++
}
$sw.Stop()
write-host "Double api local file async test: " + $sw.Elapsed.ToString()
$sw.Reset()
