# utils

function Log {
    param(
        $Message,
        $Type,
        $Out
    )
    switch($Type){
        0 { 
            Write-Host -BackgroundColor DarkGreen -ForegroundColor Black $Message 
            "OK :$Message" | Out-File -FilePath $Out -Append 
          }
        1 { 
            Write-Host -BackgroundColor Red -ForegroundColor Black $Message 
            "Error :$Message" | Out-File -FilePath $Out -Append 
          }
        2 { 
            Write-Host -BackgroundColor Yellow -ForegroundColor Black $Message 
            "Warning :$Message" | Out-File -FilePath $Out -Append 
          }
        default { 
            Write-Host $Message 
            $Message | Out-File -FilePath $Out -Append 
          }
    }

}

function ParseDN {
    param(
        $DN
    )

    $result = {} | Select domain,ou,cn

    $DN.split(",") | % {
        if($_.substring(0,2) -eq 'CN'){
            $result.cn = $_.substring(3)

        } elseif($_.substring(0,2) -eq 'OU'){
            $result.ou = "/$($_.substring(3))"+$result.ou

        } elseif($_.substring(0,2) -eq 'DC'){
            $result.domain += "$($_.substring(3))."
        }
    }

   $result.domain = $result.domain.Remove($result.domain.Length -1)
   $result
}