$DebugPreference = "Continue"

<#
    This script searches computer registries ($key and $key64) for installed programs. 
    SW which will be seeked is defined in configuration file ($conf_file) 
    so there is no need for frequent changes in script.

    File needs to be run with two parameters:
    /conf - path to configuration file (ex. 'C:\Mole\MoleConfig.txt')
    /res - html file to be generated
#>

$conf_file = 'C:\_Run\Script\System\Install\GetSoftwareList.txt'
$to_show = (Get-Content -Path $conf_file -TotalCount 4)[-1] |% {$_.split(',')} 
$sysinfo = systeminfo /FO CSV | ConvertFrom-CSV   
$key = '\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
$key64 = 'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
$SwList = @()
$swListDd = @()
$installed = @()
$result = 'C:\_Run\Script\Multimedia\SoftwareList.html'
#------------------------------------------------------------------------#

$keys = Get-ChildItem HKLM:$key -ErrorAction SilentlyContinue | foreach {
    $CurrentKey = (Get-ItemProperty -Path $_.PsPath)
    $SwList += $CurrentKey.DisplayName
    }

$keys64 = Get-ChildItem HKLM:$key64 -ErrorAction SilentlyContinue | foreach {
    $CurrentKey64 = (Get-ItemProperty -Path $_.PsPath)
    $SwList += $CurrentKey64.DisplayName
    }

foreach ($s in $SwList)
    {
        if ($swListDd -notcontains $s)
            {
                $swListDd += $s
            }
            
    }



foreach ($show in $to_show)
    {
        foreach ($sw in $swListDd)
            {
                try {
                            $cont = $sw.contains($show)
                    }
                catch {
                            Write-Debug -Message 'null-valued object'
                      }
                if ($cont -eq $true)
                      {
                            $installed += $sw
                      }
            }
    }


$html = @"
<html>
<head> 

<style>
h1 {
    font-family: Verdana, Sans-serif;
    font-size: 1.5em;
    color: #8b8e8f;
}
p {
    font-family: Verdana, Sans-serif;
}

#base {
    position: fixed;
    top: 2%;
    left: 7%;
    width: 90%;
    height: 70%;
    
}
</style>

</head>
<body>
    <div id='base'>
    <img src="http://dkprojects/10090700/Published%20material/Tools/Corporate%20Identity/Logos/DHI_Logo/RGB_PNG/DHI_Logo_Pos_RGB.png" width='300'>
    <div>
    <h1>System info for $($sysinfo.'Host Name')</h1>
    <div>
    <p>Host name: $($sysinfo.'Host Name')   </br>
    Operating System: $($sysinfo.'OS name')     </br>
    Install Date: $($sysinfo.'Original Install Date')</br>
    Total Memory: $($sysinfo.'Total Physical Memory')</br>
    Domain: $($sysinfo.'Domain')       </br>
    Logon Server: $($sysinfo.'Logon Server') </br></p>
    </div>
    <div>      
    <h1>Installed software</h1>
    <p>
    $($installed | ForEach-Object {Write-Output $_'<br>'})
    </p>
    </div>
    </div>
</body>
</html>
"@

$html | Out-File $result