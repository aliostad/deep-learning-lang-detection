$global:TFPromptSettings = New-Object PSObject -Property @{
    DefaultForegroundColor    = $Host.UI.RawUI.ForegroundColor

    BeforeText                = ' ['
    BeforeForegroundColor     = [ConsoleColor]::Yellow
    BeforeBackgroundColor     = $Host.UI.RawUI.BackgroundColor
    DelimText                 = ' |'
    DelimForegroundColor      = [ConsoleColor]::Yellow
    DelimBackgroundColor      = $Host.UI.RawUI.BackgroundColor

    AfterText                 = ']'
    AfterForegroundColor      = [ConsoleColor]::Yellow
    AfterBackgroundColor      = $Host.UI.RawUI.BackgroundColor

    ChangesForegroundColor      = [ConsoleColor]::DarkGreen
    ChangesBackgroundColor      = $Host.UI.RawUI.BackgroundColor

    DetectedForegroundColor    = [ConsoleColor]::DarkRed
    DetectedBackgroundColor    = $Host.UI.RawUI.BackgroundColor

    ShowStatusWhenZero        = $true
    EnablePromptStatus        = !$Global:TFMissing
    EnableFileStatus          = $true

    Debug                     = $false
}

function Write-Prompt($Object, $ForegroundColor, $BackgroundColor = -1) {
    if ($BackgroundColor -lt 0) {
        Write-Host $Object -NoNewLine -ForegroundColor $ForegroundColor
    } else {
        Write-Host $Object -NoNewLine -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    }
}

function Write-TFStatus($status) {
    $s = $global:TFPromptSettings
    if ($status -and $s) {
        Write-Prompt $s.BeforeText -BackgroundColor $s.BeforeBackgroundColor -ForegroundColor $s.BeforeForegroundColor

        if($s.EnableFileStatus -and $status.HasError) {
            Write-Prompt "+? ~? -? ^?" -BackgroundColor $s.ChangesBackgroundColor -ForegroundColor $s.ChangesForegroundColor
        } else {
            if($s.EnableFileStatus -and $status.HasChanges) {
                if($s.ShowStatusWhenZero -or $status.Changes.Added) {
                  Write-Prompt "+$($status.Changes.Added)" -BackgroundColor $s.ChangesBackgroundColor -ForegroundColor $s.ChangesForegroundColor
                }
                if($s.ShowStatusWhenZero -or $status.Changes.Modified) {
                  Write-Prompt " ~$($status.Changes.Modified)" -BackgroundColor $s.ChangesBackgroundColor -ForegroundColor $s.ChangesForegroundColor
                }
                if($s.ShowStatusWhenZero -or $status.Changes.Deleted) {
                  Write-Prompt " -$($status.Changes.Deleted)" -BackgroundColor $s.ChangesBackgroundColor -ForegroundColor $s.ChangesForegroundColor
                }
                if($s.ShowStatusWhenZero -or $status.Changes.Rollbacked) {
                  Write-Prompt " ^$($status.Changes.Rollbacked)" -BackgroundColor $s.ChangesBackgroundColor -ForegroundColor $s.ChangesForegroundColor
                }

                if($status.HasDetected) {
                    Write-Prompt $s.DelimText -BackgroundColor $s.DelimBackgroundColor -ForegroundColor $s.DelimForegroundColor
                }
            }

            if($s.EnableFileStatus -and $status.HasDetected) {
                if($s.ShowStatusWhenZero -or $status.Detected.Added) {
                  Write-Prompt " +$($status.Detected.Added)" -BackgroundColor $s.DetectedBackgroundColor -ForegroundColor $s.DetectedForegroundColor
                }
                if($s.ShowStatusWhenZero -or $status.Detected.Modified) {
                  Write-Prompt " ~$($status.Detected.Modified)" -BackgroundColor $s.DetectedBackgroundColor -ForegroundColor $s.DetectedForegroundColor
                }
                if($s.ShowStatusWhenZero -or $status.Detected.Deleted) {
                  Write-Prompt " -$($status.Detected.Deleted)" -BackgroundColor $s.DetectedBackgroundColor -ForegroundColor $s.DetectedForegroundColor
                }
            }
        }

        Write-Prompt $s.AfterText -BackgroundColor $s.AfterBackgroundColor -ForegroundColor $s.AfterForegroundColor
    }
}

if((Get-Variable -Scope Global -Name VcsPromptStatuses -ErrorAction SilentlyContinue) -eq $null) {
    $Global:VcsPromptStatuses = @()
}
function Global:Write-VcsStatus { $Global:VcsPromptStatuses | foreach { & $_ } }

# Add scriptblock that will execute for Write-VcsStatus
$Global:VcsPromptStatuses += {
    $Global:TFStatus = Get-TFStatus
    Write-TFStatus $TFStatus
}
