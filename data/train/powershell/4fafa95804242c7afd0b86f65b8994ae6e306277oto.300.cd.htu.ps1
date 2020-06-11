#oto.300.cd.htu.ps1

write-host "300 Content Delivery (http Upload)" -foregroundcolor yellow

# *.jars
$srcDir = $installCDDir + "\roles\upload\java"
$destDir = $httpUploadDir + "\bin\lib"
copy-item -path "$srcDir\lib\*.jar"             -destination "$destDir" -force -passthru
copy-item -path "$srcDir\third-party-lib\2.jar" -destination "$destDir" -force -passthru
# *.aspx
$srcDir = $installCDDir + "\roles\upload\dotNet"
$destDir = $httpUploadDir + "\"
copy-item -path "$srcDir\httpupload.aspx"       -destination "$destDir" -force -passthru
# *.dll
$srcDir = $installCDDir + "\roles\upload\dotNet\x86_64"
$destDir = $httpUploadDir + "\bin"
copy-item -path "$srcDir\httpupload.aspx"       -destination "$destDir" -force -passthru
