<#
.SYNOPSIS
	Converts JPG images to PDF using MS Word

.PARAMETER Images
	Path to images to be converted

.PARAMETER CombinedFilename
	Optional filename to output a single document with one image per page

.EXAMPLE
	ls .\pictures\*.jpg | Convert-JpgToPdf.ps1 -CombinedFilename .\pictures.pdf
	Generate a single pictures.pdf with one images per page

.NOTES
	Version 1.0.0 (2015-05-27)
	Written by Paul Vaillant

.LINK
	http://paul.vaillant.ca/help/ConvertTo-JpgToPdf.html
#>

[CmdletBinding()]
param(
	[Parameter(ValueFromPipeline=$true)][string[]]$Images,
	[Parameter()][string]$CombinedFilename
	#[Parameter()][switch]$RemoveImages = $false
)

BEGIN {
	$word = New-Object -ComObject Word.Application
	# this is the default
	# $word.visible = $false
	$doc = $null
	$first = $true

	if($CombinedFilename) {
		Write-Verbose "Creating combined document"
		$doc = $word.Documents.Add()
	}
}

PROCESS {
	foreach($img in $Images) {
		Write-Verbose "Converting $img"
		if(!$doc) {
			Write-Verbose "Creating individual document"
			$doc = $word.Documents.Add()
		}

		#6 is [Microsoft.Office.Interop.Word.wdunits]::wdstory
		$word.Selection.EndKey(6) | Out-Null
		$word.Selection.InlineShapes.AddPicture($img) | Out-Null
		if($CombinedFilename) {
			if($first) {
				Write-Verbose "CombinedFilename; first page"
				$first = $false
			} else {
				Write-Verbose "CombinedFilename; inserting page"
				$word.Selection.InsertNewPage()
			}
		}

		if(!$CombinedFilename) {
			$pdf = $img.Substring(0, $img.LastIndexOf('.')) + ".pdf"
			Write-Verbose "Saving individual document $pdf"
			#17 is [microsoft.office.interop.word.WdSaveFormat]::wdFormatPDF
			$doc.SaveAs([ref]$pdf, [ref]17)
			#0 is [microsoft.office.interop.word.wdsaveoptions]::wdDoNotSaveChanges
			$doc.Close([ref]0)
			$doc = $null
		}

		#if($RemoveImages) {
		#	Write-Verbose "Removing image $img"
		#	rm $img
		#}
	}
}

END {
	if($CombinedFilename) {
		Write-Verbose "Saving combined document $CombinedFilename"
		$doc.SaveAs([ref]$CombinedFilename, [ref]17)
		#0 is [microsoft.office.interop.word.wdsaveoptions]::wdDoNotSaveChanges
		$doc.Close([ref]0)
	}

	#0 is [microsoft.office.interop.word.wdsaveoptions]::wdDoNotSaveChanges
	$word.Quit([ref]0)
	$word = $null
	[gc]::Collect()
	[gc]::WaitForPendingFinalizers()
}
