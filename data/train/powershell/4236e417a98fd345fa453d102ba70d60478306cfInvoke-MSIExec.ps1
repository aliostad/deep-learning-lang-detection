function Invoke-MSIExec {
    <#
    .SYNOPSIS
    Invokes msiexec.exe

    .DESCRIPTION
    Runs msiexec.exe, passing all the arguments that get passed to `Invoke-MSIExec`.

    .EXAMPLE
    Invoke-MSIExec /a C:\temp\EwsManagedApi.MSI /qb TARGETDIR=c:\Scripts\EWSAPI

    Runs `/a C:\temp\EwsManagedApi.MSI /qb TARGETDIR=c:\temp\EWSAPI`, which extracts the contents of C:\temp\EwsManagedApi.MSI into c:\temp\EWSAPI
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        $Args
    )
    
    Write-Verbose ($Args -join " ")
    # Note: The Out-Null forces the function to wait until the prior process completes, nifty
    & (Join-Path $env:SystemRoot 'System32\msiexec.exe') $Args | Out-Null
}
