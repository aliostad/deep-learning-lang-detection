#region Import Required Assemblies

[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null;
[Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null;

#endregion

function Set-ControlProperties {
    Param(
        [Parametr(Required=$true)]
        [System.Windows.Forms.Control]$Control,
        
        [Parameter(Required=$false)]
        [object[]]$RemainingParameters
    )


}

function Set-ScrollableControlProperties {
    Param(
        [Parametr(Required=$true)]
        [System.Windows.Forms.ScrollableControl]$Control,
        
        [Parameter(Required=$false)]
        [object[]]$RemainingParameters
    )

    Set-ControlProperties @PSBoundParameters;
}

function Set-ContainerControlProperties {
    Param(
        [Parametr(Required=$true)]
        [System.Windows.Forms.ContainerControl]$Control,
        
        [Parameter(Required=$false)]
        [object[]]$RemainingParameters
    )

    Set-ScrollableControlProperties @PSBoundParameters;
}


function New-Form {
    System.Windows.Forms.Form

    
}

# $t = [Type]'System.Windows.Forms.Form'; while (-not $t.Equals([Type]'Object')) { $t.FullName; $t = $t.BaseType }
# $t = [Type]'System.Windows.Forms.Control'; $t.GetProperties() | Where-Object { $_.DeclaringType.Equals($t) -and $_.CanWrite } | ForEach-Object { Write-Host ("`t`t" + '[Parameter(Required=$false])'); Write-Host ("`t`t[$($_.PropertyType)]" + '$' + $_.Name); }
Export-ModuleMember -function New-Form, New-Test, Start-Test -alias gtt, ntt, stt