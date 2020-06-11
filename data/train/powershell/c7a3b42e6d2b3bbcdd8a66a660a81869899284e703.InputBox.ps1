Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#---------------------------------------------
# InputBox
#---------------------------------------------
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")

$str = [Microsoft.VisualBasic.Interaction]::InputBox("メッセージ", "タイトル", "初期値")
if ( $str -eq "" ) {
	Write-Host "未入力かキャンセルが押されました"
} else {
	Write-Host $str
}

#---------------------------------------------
# MessageBox
#---------------------------------------------
Add-Type -Assembly System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show("ここにメッセージ", "タイトル")

$ret = [System.Windows.Forms.MessageBox]::Show("ここにメッセージ", "タイトル", "OKCancel")
if ( $ret -eq "OK" ) {
	Write-Host "OKが選択されました"
} elseif ( $ret -eq "Cancel" ) {
	Write-Host "Cancelが選択されました"
}

[System.Windows.Forms.MessageBox]::Show("ここにメッセージ", "タイトル", "YesNo")

[System.Windows.Forms.MessageBox]::Show("ここにメッセージ", "タイトル", "YesNoCancel")

