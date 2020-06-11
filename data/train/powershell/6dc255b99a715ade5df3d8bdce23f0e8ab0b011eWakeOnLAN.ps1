######## LICENSE ####################################################################################################################################
<#
 # Copyright (c) 2014, Daiki Sakamoto
 # All rights reserved.
 #
 # Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 #   - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 #   - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer
 #     in the documentation and/or other materials provided with the distribution.
 #
 # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 # THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 # HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 # LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 # ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 # USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 #
 #>
 # http://opensource.org/licenses/BSD-2-Clause
#####################################################################################################################################################

######## HISTORY ####################################################################################################################################
<#
 # Package Builder Toolkit for PowerShell
 #
 #  2014/07/03  Version 1.1.0.0    Add this file "Wake-on-LAN.ps1".
 #  2014/07/07                     Remove from PackageBuilder Module.
 #>
<#
 # WakeOnLAN
 #  
 #  2014/07/07  Version 1.0.0.0    Forked from PackageBuilder Module as a stand-alone script.
 #
 #>
#####################################################################################################################################################

# Version
$version = New-Object System.Version(1,0,0,0)

# Exception
trap { return }


# Import Module (if required)
if (($module = (Get-Module -Name PackageBuilder)) -eq $null)
{
    try { Import-Module -Name PackageBuilder }
    catch { throw $_ }
}

# Start Message (Verbose)
Write-Verbose "WakeOnLAN (Version $version)"

# Help Message
$help_Message = @'
Please check the following file.

%HOMEDRIVE%%HOMEPATH%\Documents
  \WindowsPowerShell\Modules\PackageBuilder\mac-addresses

($env:HOMEDRIVE | Join-Path -ChildPath $env:HOMEPATH
  | Join-Path -ChildPath \Documents\WindowsPowerShell\Modules
  | Join-Path -ChildPath \PackageBuilder\mac-addresses)

The format of 'mac-addresses' file is [Name](tab)[MAC Address], like the following.

  PC1   00:00:00:00:00:00:00:AA
  PC2   00:00:00:00:00:00:00:FF
'@


$caption = 'Wake on LAN'

$list_FileName = 'mac-addresses'
$list_FilePath = $env:PSModulePath.Split(';')[0] | Join-Path -ChildPath $module.Name | Join-Path -ChildPath $list_FileName


if (-not (Test-Path -Path $list_FilePath))
{
    ##### TextBox #####

    # Show InputBox (TextBox)
    if (($address = Show-InputBox -Text 'Please input MAC Address:' -Caption $caption) -eq [string]::Empty)
    {
        return [string]::Empty
    }

    # Show Help Message
    if ($address.ToLower() -eq 'help') { Show-Message -Text $help_Message -Caption $caption }
}
else
{
    ##### ComboBox #####

    [string[]]$list = $null
    Get-Content -Path $list_FilePath | ? { $_ -ne [string]::Empty } | % { $list += $_ }

    # Validation
    if ($list -eq $null) { Show-Message -Text $help_Message -Caption $caption }

    [string[]]$names = $null
    [string[]]$addresses = $null
    $list | % {
        $names += $_.Split("`t")[0]
        $addresses += $_.Split("`t")[1]
    }


    # Show InputBox (ComboBox)
    if (($name = Show-InputBox -Text 'Please select MAC Address:' -Selectable $names -Caption $caption) -eq [string]::Empty)
    {
        return [string]::Empty
    }


    $address = [string]::Empty
    for ($i = 0; $i -lt $names.Count; $i++)
    {
        if ($name -eq　$names[$i]) { $address = $addresses[$i] }
    }
    if ($address -eq [string]::Empty) { Show-Message -Text $help_Message -Caption $caption }
}

# Wake on LAN
Start-Computer -MacAddress $address

# Show Message
Show-Message -Text "Magic Packet has been sent to '$name'." -Caption $caption

# Complete Message (Verbose)
Write-Verbose ("Magic Packet has been sent to '$name' ($address).")
