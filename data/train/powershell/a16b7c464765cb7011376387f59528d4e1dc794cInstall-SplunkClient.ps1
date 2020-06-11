<#
    .SYNOPSIS
        Install Splunk client on Windows
    .DESCRIPTION
        This script will install the Splunk client on a Windows Server.
    .PARAMETER SplunkLocation
        This is the path to where the Splunk MSI file can be found. The default value
        for this parameter is the location on the network where SplunkClients live.
    .PARAMETER SplunkMsi
        This is the name of the Splunk MSI to install. The default value for this 
        parameter is the current Splunk Client.
    .EXAMPLE
        .\Install-SplunkClient.ps1 -SplunkLocation C:\temp -SplunkMsi Splunk.msi

        Description
        -----------
        This is the basic syntax of the script. 
    .NOTES
        ScriptName : Install-SplunkClient.ps1
        Created By : jspatton
        Date Coded : 01/14/2013 13:28:48
        ScriptName is used to register events for this script
 
        ErrorCodes
            100 = Success
            101 = Error
            102 = Warning
            104 = Information
    .LINK
        https://code.google.com/p/mod-posh/wiki/Production/Install-SplunkClient.ps1
#>
[CmdletBinding()]
Param
    (
    [string]$SplunkLocation = "\\groups1.home.ku.edu\it\Units\EIO\ITSA\SplunkClients",
    [string]$SplunkMsi = "splunkforwarder-4.3.1-119532-x64-release.msi"
    )
 Begin
   {
        $ScriptName = $MyInvocation.MyCommand.ToString()
        $ScriptPath = $MyInvocation.MyCommand.Path
        $Username = $env:USERDOMAIN + "\" + $env:USERNAME
 
        New-EventLog -Source $ScriptName -LogName 'Windows Powershell' -ErrorAction SilentlyContinue
 
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nStarted: " + (Get-Date).toString()
        Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
 
        #	Dotsource in the functions you need.
        $SplunkDirectory = "C:\Program Files\Splunk"
        $Splunk = (Get-WmiObject Win32_Product -Filter "Name='Splunk'")
        $SplunkKey = "IdentifyingNumber=`"$($Splunk.IdentifyingNumber)`",Name=`"$($Splunk.Name)`",version=`"$($Splunk.Version)`""
        $SplunkInstall = $false

        if ($Splunk)
        {
            Write-Verbose "Check installed version against current version"
            if ($Splunk.PackageName -ne $SplunkMsi)
            {
                Write-Verbose "Uninstall existing client"
                $Return = ([wmi]"Win32_Product.$($SplunkKey)").Uninstall()
                Write-Verbose "Return value is : $($Return)"
                Write-Verbose "Did uninstall happen"
                if ($Return.ReturnValue = 0)
                {
                    Write-Verbose "Set install flag to true"
                    $SplunkInstall = $true
                    }
                }
            }
        else
        {
            Write-Verbose "Splunk not found, set install flag to true"
            $SplunkInstall = $true
            }
        }
Process
    {
        if ($SplunkInstall)
        {
            Write-Verbose "Install splunk client"
            $ArgumentList = "/i `"$($SplunkLocation)\$($SplunkMsi)`" INSTALLDIR=`"$($SplunkDirectory)`" LAUNCHSPLUNK=0 WINEVENTLOG_APP_ENABLE=0 WINEVENTLOG_SEC_ENABLE=0 WINEVENTLOG_SYS_ENABLE=0 SPLUNK_APP=`"`" AGREETOLICENSE=Yes /QUIET"
            $FilePath = "C:\Windows\System32\msiexec.exe " 
            $Process = Start-Process -FilePath $FilePath -ArgumentList $ArgumentList -Wait -PassThru
            if ($process.ExitCode -eq 0)
            {
                Write-Verbose "Copy configuration files local"
                Copy-Item "$($SplunkLocation)\deployWin\etc" "$($SplunkDirectory)" -Recurse
                Write-Verbose "This doesn't actually do anything"
                Copy-Item "$($SplunkDirectory)\etc\splunk-forwarder.license" "$($SplunkDirectory)\etc\splunk.license" -Force
                $ArgumentList = "restart --accept-license --no-prompt --answer-yes"
                $FilePath = "$($SplunkDirectory)\bin\splunk.exe"
                $Process = Start-Process -FilePath $FilePath -ArgumentList $ArgumentList -Wait -PassThru
                if ($Process.ExitCode -ne 0)
                {
                    $Message = "Splunk not started, please check event logs."
                    Write-Verbose $Message
                    Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
                    }
                }
            else
            {
                $Message = "Splunk not installed, please check eventn logs."
                Write-Verbose $Message
                Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
                }
            }
        else
        {
            $Message = "Please check the application log for MsiInstaller event 1040 for the start of the splunk uninstallation transaction.`r`n"
            $Message += "Splunk was not removed from this system"
            Write-Verbose $Message
            Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
            }
        }
End
    {
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nFinished: " + (Get-Date).toString()
        Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
        }