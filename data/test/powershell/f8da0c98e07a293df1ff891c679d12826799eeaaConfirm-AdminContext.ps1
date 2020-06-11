Function Confirm-AdminContext
{
    <#
        .SYNOPSIS
        Makes sure that the script is run within an elevated admin context
        .DESCRIPTION
        Throws an exception if the script isn't run within an elevated admin context
        .PARAMETER ErrorMessage
        The exception message
    #>
    Param
    (
        $ErrorMessage = "An elevated admin context is required to run this script. Please start PowerShell with 'Run as administrator'."
    )

    $role = [Security.Principal.WindowsBuiltInRole]::Administrator
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    if (-not ([Security.Principal.WindowsPrincipal]$id).IsInRole($role))
    {
        throw $ErrorMessage
    }
}