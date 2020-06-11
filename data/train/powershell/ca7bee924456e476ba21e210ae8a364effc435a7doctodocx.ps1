[ref]$SaveFormat = "microsoft.office.interop.word.WdSaveFormat" -as [type] 
$word = New-Object -ComObject word.application 
$word.visible = $false 
$folderpath = Read-Host 'Path?'
$folderpath = $folderpath + '\*'
$fileType = "*doc" 
Get-ChildItem -recurse -path $folderpath -include $fileType | 
foreach-object { 
$path = ($_.fullname).substring(0,($_.FullName).lastindexOf(".")) 
$docxpath =($_.fullname).substring(0,($_.FullName).lastindexOf(".")) + ".docx"
  if (test-path $docxpath) {Write-Host "Skip $docxpath"
 }
else {"Converting $path to $fileType ..." 
$doc = $word.documents.open($_.fullname) 
$doc.saveas([ref] $path, [ref]$SaveFormat::wdFormatDocumentDefault) 
$doc.close() 
    }
} 
$word.Quit() 
$word = $null 
[gc]::collect() 
[gc]::WaitForPendingFinalizers()