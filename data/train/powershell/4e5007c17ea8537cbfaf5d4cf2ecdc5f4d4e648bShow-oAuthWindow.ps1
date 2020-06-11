   #region mini window, made by (Insert credits here)
    Function Show-OAuthWindow {
    param($url)
    Add-Type -AssemblyName System.Windows.Forms
 
    $form = New-Object -TypeName System.Windows.Forms.Form -Property @{Width=820;Height=920}
    $web  = New-Object -TypeName System.Windows.Forms.WebBrowser -Property @{Width=800;Height=900;Url=($url -f ($Scope -join "%20")) }
    $DocComp  = {
            $Global:uri = $web.Url.AbsoluteUri
            if ($Global:Uri -match "error=[^&]*|code=[^&]*") {$form.Close() }
    }
    
    $web.ScrollBarsEnabled = $false
    $web.ScriptErrorsSuppressed = $true
    $web.Add_DocumentCompleted($DocComp)
    $form.Controls.Add($web)
    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog() | Out-Null
    }
    #endregion

    #login to get an access code 