Remove-Module PSReadLine -Force -ErrorAction SilentlyContinue
Clear-Host
if ( -not ( Get-Module PSClrCli ) ) { Import-Module PSClrCli }
$Splat = @{ Top = 4 ; Left = 4 ; Width = 60  ; Height = 32 ; Border = 'Thick' }
$CWindow = CWindow -Id Window {
	CDialog -Id Dialog -Text "List Running Processes" @Splat {
		CLabel -Text 'Running Processes' -Top 2 -Left 2
		CButton -Text 'Get Processes' -Top 4 -Left 6  -Width 25 -OnClicked { 
			Get-Process | Select -Unique ProcessName | Select -ExpandProperty ProcessName | Foreach {
				$List.Items.Add($_)
			}
		}
		CButton -Text 'Show Alternate Window' -Top 4 -Left 34 -Width 25 -OnClicked { $Dialog.Hide() ; $Dialog2.Show() }
		CListBox -Id List -Top 10 -Left 4 -Width 32 -Height 6 -Border Thin
	}
	CDialog -Id Dialog2 -Text "ooooh" -Top 6 -Left 6 -Width 32 -Height 5 -Border Thick -Visible:$False {
		CButton -Text 'Bye' -Top 1 -Left 1 -Width 8 -Height 3 -OnClicked { $Dialog2.Hide() ; $Dialog.Show() }
	}
} -PassThru
$CWindow.Run()