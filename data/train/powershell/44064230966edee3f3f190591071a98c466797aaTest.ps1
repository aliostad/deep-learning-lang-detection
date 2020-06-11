# coding: Windows-31J
# Power Shell で Excel を操作するテスト
 
 
Add-Type -Assembly System.Windows.Forms
 
 
 
 
 
 
 
#Param(
#	[string]$computerName,
#	[string]$filePath
#)
 
# 
function OpenBook($path) {
 
	$excel = New-Object -ComObject Excel.Application
	$excel.Visible = $false
	$book = $excel.Workbooks.Open($path)
 
	$modified = $false
	foreach ($e in $book.Names) {
		$buffer = "[{0}]: {1}" -f $e.NameLocal, $e.Visible
		if($e.Visible = $false) {
			[System.Windows.Forms.MessageBox]::Show($buffer)
			$e.Visible = $true
			$modified = $true
		}
	}
 
	if($modified = $true) {
		$book.Save()
	}
	
	$excel.Quit()
 
	[System.Runtime.InteropServices.Marshal]::FinalReleaseComObject($excel) | Out-Null
}
 
function Main($argc, $argv) {
 
	Write-Host "### start ###"
 
#	Param(
#		[string]$computerName,
#		[string]$filePath
#	)
 
	'Length: ' + $argv.Length
	for ($i = 0; $i -lt $argc; ++$i)
	{
	    "[{0}]: {1}" -f $i, $argv[$i]
	}
 
	# [System.Windows.Forms.MessageBox]::Show("テスト")
 
	foreach ($e in $argv) {
		# Write-Host '[', $e, ']'
		OpenBook $e
	}
 
	# [System.Windows.Forms.MessageBox]::Show("テスト")
 
	Write-Host "--- end ---"
}
 
Main $Args.Length $Args
