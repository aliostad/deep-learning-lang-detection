function Save-MyFavoriteModule
{
    $path = Join-Path $env:USERPROFILE "Documents\WindowsPowerShell\Modules" -Resolve
    $modules = @(
        "xFailOverCluster",
        "xDscDiagnostics",
        "xSqlPs",
        "xAdcsDeployment",
        "xStorage",
        "xPSDesiredStateConfiguration",
        "xWebDeploy",
        "xWindowsUpdate",
         "xWebAdministration",
         "xHyper-V",
         "xActiveDirectory",
         "xCertificate",
         "xSmbShare",
         "xNetworking",
         "xComputerManagement",
         "xSQLServer",
         "xDhcpServer",
         "xPowerShellExecutionPolicy",
         "xWindowsEventForwarding"
    )
    return Save-Module -Name $modules -Path $path -Force -Verbose
}