$path = "C:\Users\Sandro\Documents\GitHub\INM21_Group_B\05_Eclipseprojekt\export.docx"
$PDFpath = "C:UsersSDocumentsGitHubissue-managerexport.docx"

# Required Word Variables
$wdExportFormatPDF = 17
$wdDoNotSaveChanges = 0

# Create a hidden Word window
$word = New-Object -ComObject word.application
$word.visible = $false

# Add a Word document
$doc = $word.documents.add()
$content = @()
$selection = $word.selection

Get-ChildItem -Recurse -Filter "*.java" | ForEach-Object{
    $Selection.Style = 'Überschrift 1'
    $Selection.TypeText($_.BaseName)
    $Selection.TypeParagraph()
    $selection.typeText($(Get-Content $_.FullName -Raw) + "`v")
    $selection.InsertBreak(7)
}



$doc.saveas([ref]$path, [ref]$saveFormat::wdFormatDocument)

<#
$doc.ExportAsFixedFormat($PDFpath,$wdExportFormatPDF)
#>

$doc.close([ref]$wdDoNotSaveChanges)
$word.Quit()
