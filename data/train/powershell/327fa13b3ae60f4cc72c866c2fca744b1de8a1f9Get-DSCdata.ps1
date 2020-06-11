function Get-DSCdata
{ 
[cmdletbinding()]
Param(
    [validateset("Attribute","DSCnode","Role","Configuration")]
    [string]$Type
)
    $DataRoot = "$env:ProgramData\DSCconfig"
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"

    if(-not(Test-Path -Path "$DataRoot\Attribute"))
    { 
        New-Item -Path "$DataRoot\Attribute" -ItemType directory        
    }

    if (-not(Test-Path -Path "$DataRoot\DSCnode"))
    { 
        New-Item -Path "$DataRoot\DSCnode" -ItemType directory
    }

    if (-not(Test-Path -Path "$DataRoot\Role"))
    { 
        New-Item -Path "$DataRoot\Role" -ItemType directory
    }

    if (-not(Test-Path -Path "$DataRoot\Configuration"))
    { 
        New-Item -Path "$DataRoot\Configuration" -ItemType directory
    }

    $data = "$DataRoot\$Type\$Type.json"
    if ((Test-Path -Path "$data"))
    { 
        [string]$json = Get-Content -Path $Data -Encoding UTF8
        Write-Verbose -Message "$f -  Returning data for $Type at '$data'"
        if(-not $json)
        {
            Write-Verbose -Message "$f -  Unable to find content in file '$data', no items saved to disk"
            return $null
        }
        $json | ConvertFrom-Json
    }
    else
    { 
        Write-Verbose -Message "$f -  No data found"
    }

    Write-Verbose -Message "$f - END"
}