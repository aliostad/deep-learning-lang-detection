

function CopyToClipboard
{
	$text = @($Prop["Title"].Value,$Prop["Description"].Value,$Prop["Category Name"].Value,$Prop["State"].Value)
	$text = $text -join ","
	[Windows.Forms.Clipboard]::SetText($text)
}


function SaveToCSV
{
	$text = @($Prop["Title"].Value,$Prop["Description"].Value,$Prop["Category Name"].Value,$Prop["State"].Value)
	$text | Export-Csv C:\temp\mycsv.csv 
}


function CopyTitleToClipboard
{
	[Windows.Forms.Clipboard]::SetText($Prop["Title"].Value)
}