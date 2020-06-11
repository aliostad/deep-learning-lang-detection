<#
# ==============================================================================
#
# Varying Vagrant Vagrants for Windows
#
# ---- vvv-installer.ps1 v0.0.1
# ==============================================================================

@todo VBoxManage extpack install <.vbox-extpack> --replace # https://www.virtualbox.org/manual/ch08.html#vboxmanage-extpack
#>

param(
    [switch]$checkonly = $false,
    [switch]$vbext = $false,
    [string]$vvvsource = "https://github.com/Varying-Vagrant-Vagrants/VVV.git", # -vvvsource "https://github.com/Varying-Vagrant-Vagrants/VVV"
    [string]$vvvpath = "C:\vvv" # -vvvpath "C:\path\to\vvv"
)

#############
# Variables #
#############
$vbVersion = "4.3.14"     # VirtualBox Target Version
$vbRevision = "95030"       # VirtualBox Revision linked to version
$vagrantVersion = "1.6.3" # Vagrant Target Version
$vvvVersion = "master"    # VVV Target Version


####################
# Helper Functions #
####################
function prepareTempDir() {

    $tempDir = Join-Path $env:TEMP "vvv"

    function createDir($dir) {
        [System.IO.Directory]::CreateDirectory($dir)
    }
    
    if ( ![System.IO.Directory]::Exists($tempDir) ) {
        createDir($tempDir)
    }
    #else { # no need to delete the temp directory if present
    #    [System.IO.Directory]::Delete($tempDir,1)
    #    createDir($tempDir)
    #}

    return $tempDir

} # END prepareTempDir

function downloadFile {
    <#
    .SYNOPSIS
        Downloads a file showing the progress of the download
    .DESCRIPTION
        This Script will download a file locally while showing the progress of the download
    .EXAMPLE
        .\Download-File.ps1 'http:\\someurl.com\somefile.zip'
    .EXAMPLE
        .\Download-File.ps1 'http:\\someurl.com\somefile.zip' 'C:\Temp\somefile.zip'
    .PARAMETER url
        url to be downloaded
    .PARAMETER localFile
        the local filename where the download should be placed
    .NOTES
        FileName     : Download-File.ps1
        Author       : CrazyDave
        LastModified : 18 Jan 2011 9:39 AM PST
    #Requires -Version 2.0
    #>
    param(
        [Parameter(Mandatory=$true)]
        [String] $url,
        [Parameter(Mandatory=$false)]
        [String] $localFile = (Join-Path $pwd.Path $url.SubString($url.LastIndexOf('/')))
    )
       
    begin {
        $client = New-Object System.Net.WebClient
        $Global:downloadComplete = $false
     
        $eventDataComplete = Register-ObjectEvent $client DownloadFileCompleted `
            -SourceIdentifier WebClient.DownloadFileComplete `
            -Action {$Global:downloadComplete = $true}
        $eventDataProgress = Register-ObjectEvent $client DownloadProgressChanged `
            -SourceIdentifier WebClient.DownloadProgressChanged `
            -Action { $Global:DPCEventArgs = $EventArgs }    
    }
     
    process {
        Write-Progress -Activity 'Downloading file' -Status $url
        $client.DownloadFileAsync($url, $localFile)
       
        while (!($Global:downloadComplete)) {                
            $pc = $Global:DPCEventArgs.ProgressPercentage
            if ($pc -ne $null) {
                Write-Progress -Activity 'Downloading file' -Status $url -PercentComplete $pc
            }
        }
       
        Write-Progress -Activity 'Downloading file' -Status $url -Complete
    }
     
    end {
        Unregister-Event -SourceIdentifier WebClient.DownloadProgressChanged
        Unregister-Event -SourceIdentifier WebClient.DownloadFileComplete
        $client.Dispose()
        $Global:downloadComplete = $null
        $Global:DPCEventArgs = $null
        Remove-Variable client
        Remove-Variable eventDataComplete
        Remove-Variable eventDataProgress
        [GC]::Collect()    
    }

} # END downloadFile


<#
Check the current VirtualBox installation

@return <$false|$revision>
#>
function getVirtualBoxVersion {
    
    function getVirtualBoxRevision($installPath) {

        # @todo
        #$vboxManagePath = Join-Path $installPath "VBoxManage.exe"
        #$vbInstalledVersion = Start-Process $vboxManagePath -ArgumentList "-v" # 4.3.14r95030
        $vbInstalledVersion = "4.3.14r95030" # temp
        $vbInstalledVersion = $vbInstalledVersion.Split("r")
        $revision = $vbInstalledVersion[1]

        return $revision

    } # END getVirtualBoxRevision

    if ( ( $env:VBOX_INSTALL_PATH ) ) {
        $revision = getVirtualBoxRevision($env:VBOX_INSTALL_PATH)
    }
    elseif ( $env:VBOX_MSI_INSTALL_PATH ) {
        $revision = getVirtualBoxRevision($env:VBOX_MSI_INSTALL_PATH)
    } 
    else {
        $revision = $false
    }

    return $revision

} # END getVirtualBoxVersion

function getVagrantVersion {

    function fetchVagrantVersion($installPath) {

        # @todo
        #$vagrantManagePath = Join-Path $installPath "VBoxManage.exe"
        #$vagrantInstalledVersion = Start-Process $vboxManagePath -ArgumentList "-v" # 4.3.14r95030
        $vagrantInstalledVersion = "Vagrant 1.6.3" # temp
        $vagrantInstalledVersion = $vagrantInstalledVersion.Split(" ")
        $version = $vagrantInstalledVersion[1]

        return $version
    }
    
    if ( ( $env:VBOX_INSTALL_PATH ) ) {
        $version = fetchVagrantVersion($env:VBOX_INSTALL_PATH)
    }
    else {
        $version = $false
    }

    return $version

} # END getVagrantVersion

function compareVersion($package, $installedVersion, $targetVersion) {

    if ( $installedVersion -eq $targetVersion ) {
        Write-Host "Current Version: $installedVersion"
        Write-Host "Target Version:  $targetVersion`n"

        if ($checkonly -eq $false) {
            Write-Host "Nothing to do here. Skipping this step...`n`n"
        }
    }
    elseif ( $installedVersion -lt $targetVersion ) {
        Write-Host "Current Version: $installedVersion"
        Write-Host "Target Version:  $targetVersion`n"

        if ($checkonly -eq $false) {
            Write-Host "Starting Upgrade to target version...`n`n"
            setupPackage $package
        }
    }
    elseif ( $installedVersion -gt $targetVersion ) {
        Write-Host "Current Version: $installedVersion"
        Write-Host "Target Version:  $targetVersion`n"

        if ($checkonly -eq $false) {
            Write-Host "Starting Downgrade to target version...`n`n"
            setupPackage $package -force
        }
    }
    elseif ( $installedVersion -eq $false ) {
        Write-Host "Current Version: [Not Installed]"
        Write-Host "Target Version:  $targetVersion`n"

        if ($checkonly -eq $false) {
            Write-Host "Starting Installation of target version...`n`n"
            setupPackage $packages
        }
    }

}

function setupPackage() {

    param (
        [string]$package,
        [switch]$force
    )
    
    if ($package -eq "VirtualBox") {

        if ($force) {
            setupVirtualBox -force
        } else {
            setupVirtualBox
        }

    }
    elseif ($package -eq "Vagrant") {

        if ($force) {
            setupVagrant -force
        } else {
            setupVagrant
        }

    }

}

function setupVirtualBox() {

    param( [switch] $force )

    # Format: http://download.virtualbox.org/virtualbox/4.3.14/VirtualBox-4.3.14-95030-Win.exe
    $vbSource = "http://download.virtualbox.org/virtualbox/$vbVersion/VirtualBox-$vbVersion-$vbRevision-Win.exe"
    $vbFile = Join-Path $tempDir "VirtualBox-$vbVersion.exe"


    # download VirtualBox
    Write-Host "Download & Install VirtualBox" # @todo
    downloadFile $vbSource $vbFile

    # extract archive
    Start-Process "$vbFile" -ArgumentList "--extract -path `"$tempDir`" -silent"

    # install VirtualBox
    # determine architecture
    $archKey = "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment"
    $arch = (Get-ItemProperty -Path $archKey -Name PROCESSOR_ARCHITECTURE).PROCESSOR_ARCHITECTURE

    $vbFileInstaller = Join-Path $tempDir "VirtualBox-$vbVersion-r$vbRevision-MultiArch_$arch.msi"

    # run the msi package (in forced mode to allow for downgrades)
    if ($force) {
        Start-Process msiexec -ArgumentList "/fa `"$vbFileInstaller`" /passive /norestart" -Wait
    }
    else {
        Start-Process msiexec -ArgumentList "/i `"$vbFileInstaller`" /passive /norestart" -Wait
    }
    
} # END setupVirtualBox

function setupVagrant() {

    param( [switch] $force )

    # Format: https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3.msi
    $vagrantSource = "https://dl.bintray.com/mitchellh/vagrant/vagrant_$vagrantVersion.msi"
    $vagrantFile = Join-Path $tempDir "vagrant_$vagrantVersion.msi"
    
    # download Vagrant
    Write-Host "Download & Install Vagrant" # @todo
    downloadFile $vagrantSource $vagrantFile

    # run the msi package (in forced mode to allow for downgrades)
    if ($force) {
        Start-Process msiexec -ArgumentList "/fa `"$vagrantFile`" /passive /norestart" -Wait
    }
    else {
        Start-Process msiexec -ArgumentList "/i `"$vagrantFile`" /passive /norestart" -Wait
    }
    
} # END setupVagrant


########################
# Installation Process #
########################

$tempDir = prepareTempDir # set temp directory

# == Splesh Screen ==
Write-Host "# ==============================================================================`n"
Write-Host "# Varying Vagrant Vagrants for Windows`n"
Write-Host "# `t`- VirtualBox: $vbVersion (r$vbRevision)`n"
Write-Host "# `t`- Vagrant: $vagrantVersion`n"
Write-Host "# `t`- VVV: $vvvVersion`n"
Write-Host "# ==============================================================================`n`n"


# == VirtualBox ==
Write-Host "== VirtualBox =="

# === Check VirtualBox ===
$vbInstalled = getVirtualBoxVersion # <$false|"revision">
compareVersion "VirtualBox" $vbInstalled $vbRevision

 if ( $vbext ) {
    # check and setup VirtualBox Extension Pack
}


# == Vagrant ==
Write-Host "== Vagrant =="

# === Check Vagrant ===
$vagrantInstalled = getVagrantVersion # <$false|"revision">
compareVersion "Vagrant" $vagrantInstalled $vagrantVersion
# vagrant plugins: How to update? Force install every time?

# vagrant plugin install vagrant-hostsupdater
# vagrant plugin install vagrant-triggers


# == VVV ==
Write-Host "== VVV =="
