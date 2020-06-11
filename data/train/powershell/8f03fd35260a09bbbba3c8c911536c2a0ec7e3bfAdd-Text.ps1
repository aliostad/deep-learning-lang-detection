#iTextSharp is Download from https://github.com/itext/itextsharp/releases
#unzip to c:\usr\lib directory

#load iText Library
[System.Reflection.Assembly]::LoadFrom("C:\usr\lib\itextsharp.dll")

#Create Pdf Document Object
$doc = New-Object iTextSharp.text.Document

#Set Pdf File Stream
$stream = [IO.File]::OpenWrite("b:\pdf\NewPdf.pdf")

#Set PdfWriter
$writer = [iTextSharp.Text.Pdf.PdfWriter]::GetInstance($doc, $stream)

$doc.Open()

#Set Paragraph
$text = New-Object iTextSharp.Text.Paragraph("Hellow iTextSharp")

$doc.add($text)

#Objects Closing
$doc.Close()
$writer.Close()
$stream.Close()