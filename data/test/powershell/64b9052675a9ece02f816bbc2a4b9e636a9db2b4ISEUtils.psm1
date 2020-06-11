Function Save-IseSession{
    [CmdletBinding()]
    Param(
        [Parameter(Position=0)]
        [String]$Path = "$env:tempIse.txt"
    )
 
    Begin{
    }
    Process{
        $psISE.CurrentPowerShellTab.Files | % {$_.SaveAs($_.FullPath)}
        "ise ""$($psISE.PowerShellTabs.Files.FullPath -join',')""" | Out-File -Encoding utf8 -FilePath $Path
    }
    End{
    }
}

Function Restore-IseSession{
    [CmdletBinding()]
    Param(
        [Parameter(Position=0)]
        [String]$Path = "$env:tempIse.txt"
    )
 
    Begin{
    }
    Process{
        Invoke-Expression (Get-Content $Path)
    }
    End{
    }
}



<#Declaração de exportação do módulo#>

export-modulemember -function Restore-IseSession
export-modulemember -function Save-IseSession
#export-modulemember -function * -Alias *