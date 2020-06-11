# Create a HTML from DOCX through web archive to keep the images where they are at
# then save it as a Word DOC so that it can be imported in some other app
# 
$docPath = "C:\
$htmlpath = "C:\html"
$srcfiles = Get-ChildItem -Path $docPath -filter "*.docx"  
$saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatWebArchive");  
$word = new-object -comobject word.application  
$word.Visible = $False  

function saveas-html{  
  $name = $doc.basename  
  $savepath = "$htmlpath\" + $name + ".html"  
  write-host $name  
  Write-Host $savepath  
  $opendoc = $word.documents.open($doc.FullName);  
  $opendoc.saveas([ref]$savepath, [ref]$saveFormat);  
  $opendoc.close();
}  

function saveas-docx{  
  $name = $doc.basename  
  $htmldocx = "$htmlpath\" + $name + ".html"  
  $docx = $htmlpath + "\" + $name
  write-host "Name: $name"
  write-host "HTMLDocx: $htmldocx"
  write-host "docx: $docx"
  $saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatDocument");
  $doc = $word.documents.open($htmldocx)
  $doc.saveas([ref]$docx, [ref]$saveFormat)
  $doc.close()
}  

ForEach ($doc in $srcfiles) {  
  Write-Host "Processing :" $doc.FullName  
  saveas-html
  saveas-docx  
}  
$word.quit();  
