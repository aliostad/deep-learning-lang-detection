function Show-BaloonTip{
    <#
        .SYNOPSIS
        バルーンアイコンを表示します。
    #>
    [CmdletBinding()]
    Param(
        [ValidateRange(1,3600)]
        #表示する時間(秒)
        [int]$showSecond=10,
        
        #バルーンのタイトル
        [string]
        $title="",
        
        #バルーンの本文
        $body="balloon",
        
        #バルーンのアイコン
        [ValidateSet("None", "Info", "Warning", "Error")]
        [string]
        $toolTipIcon="Info",
        
        #バルーン表示後にキー入力待ちをしないオプション
        #これを指定した場合、タスクトレイのアイコンが消えなくなります。
        [switch]
        $disableUserComfirm
    )
    Process{
        [Void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        $notifyIcon = New-Object System.Windows.Forms.NotifyIcon

        #PowerShell.exeのアイコンを取得してセットする
        $powerShellExe = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
        $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($powerShellExe)
        $notifyIcon.Icon = $icon

        $notifyIcon.Visible = $true

        $notifyIcon.ShowBalloonTip($showSecond*1000, $title, $body, $toolTipIcon)

        if($disableUserComfirm -eq $false){
            Read-Host "バルーン表示中です。終了するにはキーを入力してください"
            $notifyIcon.Visible = $false
        }
    }
}
