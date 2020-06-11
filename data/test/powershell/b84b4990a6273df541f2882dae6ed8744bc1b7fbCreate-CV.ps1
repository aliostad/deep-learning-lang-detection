#
# Script to create a CV from an XML file
#
# see http://dilutedthoughts.com/dilutedthoughts/2012/12/19/using-powershell-to-create-a-custom-word-document
#     https://richardspowershellblog.wordpress.com/2012/10/15/powershell-3-and-word/
#     https://msdn.microsoft.com/en-us/library/office/aa220734%28v=office.11%29.aspx
#     http://blogs.technet.com/b/bshukla/archive/2010/07/29/how-to-convert-a-word-document-to-other-formats-using-powershell.aspx
#     https://msdn.microsoft.com/en-us/library/microsoft.office.interop.word.wdsaveformat.aspx
#     http://www.petri.com/format-microsoft-word-docs-powershell.htm
#     http://powershell.com/cs/forums/t/16939.aspx
#

param ($xmlCvFile="P:\Users\Bill\Documents\CV\Bill Powell CV 2015-05.xml",
  [ValidateSet('doc','docx','rtf')]
   [string]$wordFormat="docx")

$file = $xmlCvFile -replace "\.xml$","-new.${wordFormat}"

switch ($wordFormat) {
  "doc" {$saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatDocument97");}
  "rtf" {$saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatRTF");}
  default {$saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatDocumentDefault");}
}

$cvInfo = [xml](Get-Content $xmlCvFile)

$word = New-Object -ComObject "Word.application"            
$word.visible = $true            
$doc = $word.Documents.Add()            
$doc.Activate()            
            
$word.Selection.Font.Name = "Cambria"            
$word.Selection.Font.Size = "20"
$t1 = $cvInfo.CV.DocTitle.line[0]."#text"           
$word.Selection.TypeText($t1)            
$word.Selection.TypeParagraph()            
            
$word.Selection.Font.Name = "Calibri"            
$word.Selection.Font.Size = "12"            
$t2 = $cvInfo.CV.DocTitle.line[1]."#text"           
$word.Selection.TypeText($t2)            
$word.Selection.TypeParagraph()            
            
$doc.SaveAs([ref]$file,[ref]$saveFormat)            
            
$Word.Quit()
