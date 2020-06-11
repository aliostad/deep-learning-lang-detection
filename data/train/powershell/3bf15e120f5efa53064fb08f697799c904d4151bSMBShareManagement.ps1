<#
The MIT License (MIT)

Copyright (c) 2015 Tintri, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#>

<#

The following code snippet shows how to manage SMB shares on a Tintri VMstore using the Tintri Automation Toolkit 1.5.0.1.
In particular:
- View SMB shares
- Create and delete SMB shares
- View the Access Control List (ACL) of a share
- Grant a user access to a share (create an ACE)
- Revoke access to a user (remove an ACE)

#>

Param(
    [string] $tintriServer,
    [string] $shareName    
)

$knownGroup = "BUILTIN\Administrators"

# Connect to the VMstore, will prompt for credentials
Write-Host "Connecting to the Tintri server $tintriServer"
Connect-TintriServer -Server $tintriServer

# List all the SMB shares on the VMstore
Write-Host "Fetching all the SMB shares on $tintriServer"
Get-TintriSmbShare

# Create a new SMB share
Write-Host "Creating a new share: $shareName"
New-TintriSmbShare -Name $shareName

# Grant a user/group access to the above share
Write-Host "Granting the (known) group $knownGroup full access to the above share"
Grant-TintriSmbShareAccess -Name $shareName -User $knownGroup -Access FullControl

# Get the updated ACL
Write-Host "Fetching the updated ACL of the share"
$acl = Get-TintriSmbShareAccess -Name $shareName

# Revoke the access granted above (remove the Access Control Entry).
Write-Host "Revoking the access to $knownGroup granted above"
$acl[-1] | Revoke-TintriSmbShareAccess

# Remove the SMB share
Write-Host "Removing the share $shareName from the VMstore"
Remove-TintriSmbShare -Name $shareName
