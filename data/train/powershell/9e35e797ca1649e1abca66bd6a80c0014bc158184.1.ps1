    
    <#
.Synopsis
    Help before the function
    #>
function Show-HelpBefore { 
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$param
        )
}

function Show-HelpAfter{ 
    <#
.Synopsis
    Help after function
    #>
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$param
        )

}


function Show-HelpAtTheEnd { 
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$param
        )
    <#
.Synopsis
    Help at the end of the function
    #>
}

Get-Help Show-HelpBefore 
Get-Help Show-HelpAfter
Get-Help Show-HelpAtTheEnd 
