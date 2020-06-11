function Out-Toast {
    param(
        [parameter(
            Mandatory=$true,
            ValueFromPipeline=$True)]
    	[AllowEmptyString()]
        [string]$Message,
        [string]$Title
    )
    BEGIN {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        $objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon

        $objNotifyIcon.Icon = "C:\Windows\System32\PerfCenterCpl.ico"
        $objNotifyIcon.BalloonTipIcon = "Info"
        $objNotifyIcon.BalloonTipTitle = $Title

        $lastMessageTime = Get-Date
    }
    PROCESS {
        if ($Message -eq "") { return }

        if (((Get-Date) - $lastMessageTime).TotalMilliseconds -gt 5000) {
            $objNotifyIcon.BalloonTipText = $Message
        } else {
            $objNotifyIcon.BalloonTipText = $objNotifyIcon.BalloonTipText + "`n" + $Message
        }

        $objNotifyIcon.Visible = $True
        $objNotifyIcon.ShowBalloonTip(10000)

        $lastMessageTime = Get-Date
    }
    END {
        # Start-Sleep -Milliseconds 5000
        # $objNotifyIcon.Dispose()
    }
}

npm start | Out-Toast -Title esLint
