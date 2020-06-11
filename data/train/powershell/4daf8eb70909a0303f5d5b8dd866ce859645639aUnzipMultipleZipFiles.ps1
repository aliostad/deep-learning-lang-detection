Function ZipEverything($src, $dest)
{
   [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
   $zps = Get-ChildItem $src -Filter *.zip

   foreach ($zp IN $zps)
   {
       $all = $src + $zp
       [System.IO.Compression.ZipFile]::ExtractToDirectory($all, $dest)
   }
}

ZipEverything -src "\\sourcelocation\tracefiles\" -dest "\\destinationlocation\tracefiles\"
 
<#

Function ZipEverything($src, $dest)
{
   [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
   $zps = Get-ChildItem $src -Filter *.zip
   ## Move exceptions:
   $exc = $dest + "Exceptions\"

   foreach ($zp IN $zps)
   {
       $all = $src + $zp
       try
       {
            [System.IO.Compression.ZipFile]::ExtractToDirectory($all, $dest)
            
       }
       catch
       {
            Move-Item $all $exc
       }
   }
}

ZipEverything -src "\\sourcelocation\tracefiles\" -dest "\\destinationlocation\tracefiles\"


#>
