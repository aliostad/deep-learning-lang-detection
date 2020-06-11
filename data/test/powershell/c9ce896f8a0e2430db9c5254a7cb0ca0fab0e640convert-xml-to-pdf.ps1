param([string]$workspacePath)

$wordApplication = New-Object -ComObject Word.Application
$noSave = [microsoft.office.interop.word.WdSaveOptions]::wdDoNotSaveChanges

Get-ChildItem -Path $workspacePath -Filter *.xml | ForEach-Object {
  # Create a blank Word document, print xml, save as pdf and close
  $document = $wordApplication.Documents.Add()
  $document.Activate()
  $wordApplication.Selection.Font.Name = "Arial"
  $wordApplication.Selection.Font.Size = "10"
  $wordApplication.Selection.TypeText(((Get-Content $_ -encoding "UTF8") -join "`r`n"))
  $wordApplication.Selection.TypeParagraph()
  $pdfPath = "$($_.DirectoryName)\$($_.BaseName).pdf"
  $document.SaveAs([ref] $pdfPath, [ref] 17)
  $document.Close(([ref] $noSave))
}

$wordApplication.Quit([ref] $noSave)
