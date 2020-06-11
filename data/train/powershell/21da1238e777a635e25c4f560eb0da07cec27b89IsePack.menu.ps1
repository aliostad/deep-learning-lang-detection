﻿
$myModule = Get-PSCallStack | 
    Where-Object { $_.InvocationInfo.MyCommand.Module } | 
    Select-Object -First 1 -ExpandProperty InvocationInfo | 
    Select-Object -ExpandProperty MyCommand | 
    Select-Object -ExpandProperty Module


$moduleRoot = Split-Path $myModule.Path

$iseMan= [ScriptBlock]::Create(
    "Import-Icicle -File '$moduleRoot\Icicles\IseMan.Icicle.ps1' -Force"
)

$showClock = [ScriptBlock]::Create(
    "Import-Icicle -File '$moduleRoot\Icicles\Clock.Icicle.ps1' -Force"
)

$showToDo = [ScriptBlock]::Create(
    "Import-Icicle -File '$moduleRoot\Icicles\Todo.Icicle.ps1' -Force"
) 

$showRegions = [ScriptBlock]::Create(
    "Import-Icicle -File '$moduleRoot\Icicles\Regions.Icicle.ps1' -Force"
)

 


$showPasty =  [ScriptBlock]::Create(
    "Import-Icicle -File '$moduleRoot\Icicles\Pasty.Icicle.ps1' -Force"
) 

$showPipeworks =  [ScriptBlock]::Create(
    "Import-Icicle -File '$moduleRoot\Icicles\Pipeworks.Icicle.ps1' -Force"
) 

$findInFiles=  [ScriptBlock]::Create(
    "Import-Icicle -File '$moduleRoot\Icicles\Find.Icicle.ps1' -Force"
)

$randomizer=  [ScriptBlock]::Create(
    "Import-Icicle -File '$moduleRoot\Icicles\Randomizer.Icicle.ps1' -Force"
) 


@{
	"Edit" =  . $moduleRoot\Menus\Edit.Menu.ps1
    "Show" = @{
        "Show-Regions" = $showRegions |
            Add-Member NoteProperty ShortcutKey "CTRL+ALT+R" -PassThru        
        "Show-Member" = {
		    Show-Member
	    } |
            Add-Member NoteProperty ShortcutKey "ALT+M" -PassThru        
        "Show-SyntaxForCurrentCommand" = {
		    Show-SyntaxForCurrentCommand
	    } |
            Add-Member NoteProperty ShortcutKey "ALT+Y" -PassThru
        "Show-Clock" = $showClock 
        "Show-ToDo" = $showToDo |
            Add-Member NoteProperty ShortcutKey "ALT+T" -PassThru

        "Pipeworks" = $showPipeworks  |
            Add-Member NoteProperty ShortcutKey "CTRL+P" -PassThru            
        "Show-LastOutput" = {
            Show-LastOutput
        } |
            Add-Member NoteProperty ShortcutKey "ALT+O" -PassThru            
        "Show-TypeConstructorForCurrentType" = {
		    Show-TypeConstructorForCurrentType
	    } |
            Add-Member NoteProperty ShortcutKey "ALT+C" -PassThru	
        "Pasty" =  $showPasty |
            Add-Member NoteProperty ShortcutKey "CTRL+ALT+V" -PassThru	
        "Randomizer" =  $randomizer |
            Add-Member NoteProperty ShortcutKey "CTRL+SHIFT+ALT+R" -PassThru	
        "IseMan" = $iseMan|
            Add-Member NoteProperty ShortcutKey "ALT+I" -PassThru	
            
    }
	"Close-AllOpenedFiles" = { Close-AllOpenedFiles } |
        Add-Member NoteProperty ShortcutKey "CONTROL+SHIFT+F4" -PassThru		

    "Write-FormatView" = {
        Add-Icicle -Command (Get-command Write-FormatView) -Force
    } | Add-Member NoteProperty ShortcutKey "CONTROL+ALT+F" -PassThru

    "Write-TypeView" = {
        Add-Icicle -Command (Get-command Write-TypeView) -Force
    } | Add-Member NoteProperty ShortcutKey "CONTROL+ALT+T" -PassThru
			
    "Find-InFiles" = $findInFiles |
        Add-Member NoteProperty ShortcutKey "CONTROL+SHIFT+F" -PassThru
    "Search-Bing" = {
        $Shell = New-Object -ComObject Shell.Application
        Select-CurrentText | Where-Object { $_ } | ForEach-Object {
            $shell.ShellExecute("http://www.bing.com/search?q=$_")
        } 
    } | Add-Member NoteProperty ShortcutKey "CONTROL+B" -PassThru	
	"Write-_UI" = @{
		'Show-Selection' = {
            Select-CurrentText -NotInOutput -NotInCommandPane | 
                Where-Object { 
                    $_ 
                } |
                ForEach-Object { 
                    $sb = [ScriptBlock]::Create($_)
                    Invoke-Expression "$sb -Show"
                }
                
        } | Add-Member NoteProperty ShortcutKey 'ALT+F8' -PassThru

        'Show-Selection -AsJob' = {
            Select-CurrentText -NotInOutput -NotInCommandPane | 
                Where-Object { 
                    $_ 
                } |
                ForEach-Object { 
                    $sb = [ScriptBlock]::Create($_)
                    Invoke-Expression "$sb -AsJob"
                }
                
        } | Add-Member NoteProperty ShortcutKey 'CONTROL+ALT+F8' -PassThru
	}
}


# SIG # Begin signature block
# MIINGAYJKoZIhvcNAQcCoIINCTCCDQUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUPumtGribjkoblzMO8LPcHSfD
# ofCgggpaMIIFIjCCBAqgAwIBAgIQAupQIxjzGlMFoE+9rHncOTANBgkqhkiG9w0B
# AQsFADByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFz
# c3VyZWQgSUQgQ29kZSBTaWduaW5nIENBMB4XDTE0MDcxNzAwMDAwMFoXDTE1MDcy
# MjEyMDAwMFowaTELMAkGA1UEBhMCQ0ExCzAJBgNVBAgTAk9OMREwDwYDVQQHEwhI
# YW1pbHRvbjEcMBoGA1UEChMTRGF2aWQgV2F5bmUgSm9obnNvbjEcMBoGA1UEAxMT
# RGF2aWQgV2F5bmUgSm9obnNvbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
# ggEBAM3+T+61MoGxUHnoK0b2GgO17e0sW8ugwAH966Z1JIzQvXFa707SZvTJgmra
# ZsCn9fU+i9KhC0nUpA4hAv/b1MCeqGq1O0f3ffiwsxhTG3Z4J8mEl5eSdcRgeb+1
# jaKI3oHkbX+zxqOLSaRSQPn3XygMAfrcD/QI4vsx8o2lTUsPJEy2c0z57e1VzWlq
# KHqo18lVxDq/YF+fKCAJL57zjXSBPPmb/sNj8VgoxXS6EUAC5c3tb+CJfNP2U9vV
# oy5YeUP9bNwq2aXkW0+xZIipbJonZwN+bIsbgCC5eb2aqapBgJrgds8cw8WKiZvy
# Zx2qT7hy9HT+LUOI0l0K0w31dF8CAwEAAaOCAbswggG3MB8GA1UdIwQYMBaAFFrE
# uXsqCqOl6nEDwGD5LfZldQ5YMB0GA1UdDgQWBBTnMIKoGnZIswBx8nuJckJGsFDU
# lDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwdwYDVR0fBHAw
# bjA1oDOgMYYvaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC1j
# cy1nMS5jcmwwNaAzoDGGL2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWFz
# c3VyZWQtY3MtZzEuY3JsMEIGA1UdIAQ7MDkwNwYJYIZIAYb9bAMBMCowKAYIKwYB
# BQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwgYQGCCsGAQUFBwEB
# BHgwdjAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME4GCCsG
# AQUFBzAChkJodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEy
# QXNzdXJlZElEQ29kZVNpZ25pbmdDQS5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG
# 9w0BAQsFAAOCAQEAVlkBmOEKRw2O66aloy9tNoQNIWz3AduGBfnf9gvyRFvSuKm0
# Zq3A6lRej8FPxC5Kbwswxtl2L/pjyrlYzUs+XuYe9Ua9YMIdhbyjUol4Z46jhOrO
# TDl18txaoNpGE9JXo8SLZHibwz97H3+paRm16aygM5R3uQ0xSQ1NFqDJ53YRvOqT
# 60/tF9E8zNx4hOH1lw1CDPu0K3nL2PusLUVzCpwNunQzGoZfVtlnV2x4EgXyZ9G1
# x4odcYZwKpkWPKA4bWAG+Img5+dgGEOqoUHh4jm2IKijm1jz7BRcJUMAwa2Qcbc2
# ttQbSj/7xZXL470VG3WjLWNWkRaRQAkzOajhpTCCBTAwggQYoAMCAQICEAQJGBtf
# 1btmdVNDtW+VUAgwDQYJKoZIhvcNAQELBQAwZTELMAkGA1UEBhMCVVMxFTATBgNV
# BAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEkMCIG
# A1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4XDTEzMTAyMjEyMDAw
# MFoXDTI4MTAyMjEyMDAwMFowcjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lD
# ZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UEAxMoRGln
# aUNlcnQgU0hBMiBBc3N1cmVkIElEIENvZGUgU2lnbmluZyBDQTCCASIwDQYJKoZI
# hvcNAQEBBQADggEPADCCAQoCggEBAPjTsxx/DhGvZ3cH0wsxSRnP0PtFmbE620T1
# f+Wondsy13Hqdp0FLreP+pJDwKX5idQ3Gde2qvCchqXYJawOeSg6funRZ9PG+ykn
# x9N7I5TkkSOWkHeC+aGEI2YSVDNQdLEoJrskacLCUvIUZ4qJRdQtoaPpiCwgla4c
# SocI3wz14k1gGL6qxLKucDFmM3E+rHCiq85/6XzLkqHlOzEcz+ryCuRXu0q16XTm
# K/5sy350OTYNkO/ktU6kqepqCquE86xnTrXE94zRICUj6whkPlKWwfIPEvTFjg/B
# ougsUfdzvL2FsWKDc0GCB+Q4i2pzINAPZHM8np+mM6n9Gd8lk9ECAwEAAaOCAc0w
# ggHJMBIGA1UdEwEB/wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQM
# MAoGCCsGAQUFBwMDMHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDov
# L29jc3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5k
# aWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MIGBBgNVHR8E
# ejB4MDqgOKA2hjRodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
# cmVkSURSb290Q0EuY3JsMDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20v
# RGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3JsME8GA1UdIARIMEYwOAYKYIZIAYb9
# bAACBDAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BT
# MAoGCGCGSAGG/WwDMB0GA1UdDgQWBBRaxLl7KgqjpepxA8Bg+S32ZXUOWDAfBgNV
# HSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzANBgkqhkiG9w0BAQsFAAOCAQEA
# PuwNWiSz8yLRFcgsfCUpdqgdXRwtOhrE7zBh134LYP3DPQ/Er4v97yrfIFU3sOH2
# 0ZJ1D1G0bqWOWuJeJIFOEKTuP3GOYw4TS63XX0R58zYUBor3nEZOXP+QsRsHDpEV
# +7qvtVHCjSSuJMbHJyqhKSgaOnEoAjwukaPAJRHinBRHoXpoaK+bp1wgXNlxsQyP
# u6j4xRJon89Ay0BEpRPw5mQMJQhCMrI2iiQC/i9yfhzXSUWW6Fkd6fp0ZGuy62ZD
# 2rOwjNXpDd32ASDOmTFjPQgaGLOBm0/GkxAG/AeB+ova+YJJ92JuoVP6EpQYhS6S
# kepobEQysmah5xikmmRR7zGCAigwggIkAgEBMIGGMHIxCzAJBgNVBAYTAlVTMRUw
# EwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20x
# MTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBDb2RlIFNpZ25pbmcg
# Q0ECEALqUCMY8xpTBaBPvax53DkwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwx
# CjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGC
# NwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFPR/qEg0Y0RRdjZq
# NkfmKpBHrJqvMA0GCSqGSIb3DQEBAQUABIIBAEisDeA2vHX0Vd5AvanCwwAXxyae
# eQ/DAAkUcSbQhim4dvcKrH64V4NNhjSivW3mX4gKYu4t9iJkzxSs7aQ/jh7+2cH9
# 5Roy7nzGbxKC8eg1TsIl05djLMzboBIbZ6uUA3BJZ4AKdd9fOat77j4SCk/XBQ0l
# JAzejNHf2dTmNnjxoozu7tKwVoc9Ixq7geCSFvfKNDap7DPt48Y3vm4AK8ejFV2I
# EFNaLyNWM9ACuIccvYL5OELS1e6PCWtNaQwNfdVrPI9MrjqRMg9z8KDrppS8yrmJ
# 0gGL8Az+wGFa//xdnxe+u9ob9f2LvkclWjftQjn4oZNXWmbCK6KnHoFqvi0=
# SIG # End signature block
