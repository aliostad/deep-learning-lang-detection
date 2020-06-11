Function Create-Share{
<#
.SYNOPSIS
.DESCRIPTION
For more information please visit http://msdn.microsoft.com/en-us/library/aa394435(v=vs.85).aspx and following.
.EXAMPLE
#>
Param(
    [Parameter(
        Mandatory = $True,
        HelpMessage = "Path to the Folder to be share (e.g. c:\share)")]
    [String]$Path,
    [Parameter(
        Mandatory = $True,
        HelpMessage = "The Name of the share")]
    [String]$Name,
    [Parameter(
        Mandatory = $False,
        HelpMessage = "Description for the Share")]
    [String]$Description,
    [Parameter(
        HelpMessage = "Type of Share")]
    [Int]$Type = 0,
    [Parameter(
        HelpMessage = "Maximum allowed Users for the Share")]
    [String]$MaximumAllowed = 100,
    [Parameter(
        Mandatory = $False,
        HelpMessage = "Password for the Share")]
    [String]$Password,
    [Parameter(
        HelpMessage = "Win32_SecurityDescriptor Access")]
    $SecurityDescriptor = $Null
)
    $Class = [WMICLASS] "\\$env:COMPUTERNAME\Root\Cimv2:Win32_Share"


    $Work = $Class.create($Path,$Name,$Type,$MaximumAllowed,$Description,$Password,$SecurityDescriptor)
    
    $Message = "Message for creating Share $Name ($Path) is:"
    
    Switch($Work.returnvalue){
        0{"$Message Success"}
        2{"$Message Access Denied"}
        8{"$Message Unknown Failure"}
        9{"$Message Invalid Name"}
        10{"$Message Invalid Level"}
        21{"$Message Invalid Parameter"}
        22{"$Message Duplicate Share"}
        23{"$Message Redirected Path"}
        24{"$Message Unkown Device or Directory"}
        25{"$Message Net Name Not Found"}
    }
}


Function Copy-AccessList{
<#
.SYNOPSIS
.EXAMPLE
Set-Acl C:\test1\ C:\test2\
.PARAMETER Source
.PARAMETER Target
#>
Param(
    [Parameter(
        Mandatory = $True,
        Position = 0,
        HelpMessage = "Path to the Source ACL")]
    [String]$Source,
    [Parameter(
        Mandatory = $True,
        Position = 1,
        HelpMessage = "Path to the Target Directory")]
    [String[]]$Target
)
    ForEach($entry in $Target){
        Set-Acl -Path $entry -AclObject (Get-Acl $Source)
    }
}


Function Set-AccessRule{
<#
.SYNOPSIS
.DESCRIPTION
.EXAMPLE
Set-AccessRule -Path C:\test\ -User Testuser - Rights read,write -InheritanceFlag none -PropagationFlag none -Type allow 
#>
Param(
    [Parameter(
        Mandatory = $True,
        Position = 0,
        HelpMessage = "Specify the User for the Accessrule")]
    [System.Security.Principal.NTAccount]$User,
    [Parameter(
        Mandatory = $True,
        Position = 1,
        HelpMessage = "Path to the file for the access rule")]
    [String]$Path,
    [Parameter(
        Mandatory = $True,
        Position = 2,
        HelpMessage = "Specify the Rights to be set")]
    [System.Security.AccessControl.FileSystemRights]$Rights,
    [Parameter(
        Mandatory = $True,
        Position = 3,
        HelpMessage = "Specify the Inheritance Flag")]
    [System.Security.AccessControl.InheritanceFlags]$InheritanceFlag,
    [Parameter(
        Mandatory = $True,
        Position = 4,
        HelpMessage = "Specify the Propagation Flag")]
    [System.Security.AccessControl.PropagationFlags]$PropagationFlag,
    [Parameter(
        Mandatory = $True,
        Position = 5,
        HelpMessage = "Specify the Type of the access rule")]
    [System.Security.AccessControl.AccessControlType]$Type,
    [Parameter(
        Mandatory = $False,
        Position = 6,
        HelpMessage = "Specify if you want to overwrite previous ACRs")]
    [System.Boolean]$Overwrite = $False

)
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($User,$Rights,$InheritanceFlag,$PropagationFlag,$Type)
    
    If($Overwrite -eq $False){
        $AccessList = Get-Acl $Path
        $AccessList.AddAccessRule($AccessRule)
    }Else{
        $AccessList = $AccessRule
    }
    Set-Acl -Path $Path -AclObject $Accesslist
}

Function Create-Folder{
<#
.SYNOPSIS
.DESCRIPTION
.EXAMPLE
Create-Folder C:\test\test2
#>
Param(
    [Parameter(
        Mandatory = $True,
        HelpMessage = "Literal Path to the directory")]
    [String[]]$Path
)
    ForEach($Entry in $Path){
        If(!([System.IO.Directory]::Exists($entry))){
            try{
                [System.IO.Directory]::CreateDirectory($Entry) | Out-Null
                Write-Output "Directory $entry on $env:COMPUTERNAME : created"
            }
            catch{
            }
            
        }Else{
            Write-Output "Directory $entry on $env:COMPUTERNAME : already present"
        }
    }
}

Function Create-File{
<#
#>
[CmdletBinding()]
Param(
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Literal path of the file, only works with "\"'
    )]
    [String[]]$File
)
    ForEach($entry in $File){
        $parentfolder = $entry.remove($entry.LastIndexOf("\"))
        If(!([System.IO.Directory]::Exists($parentfolder))){
            Write-Verbose "Parentfolder not present, creating it"
            Create-Folder $parentfolder | Out-Null
        }
        If(!([System.IO.File]::Exists($entry))){
            try{
                [System.IO.File]::Create($entry) | Out-Null
                Write-Output "File $entry on $env:COMPUTERNAME : created"
            }
            catch{
            }
        }Else{
            Write-Output "File $entry on $env:COMPUTERNAME : already present"
        }
    }
}


Function Find-Shares{
<#
.SYNOPSIS
.EXAMPLE
#>
    $Shares = Get-WmiObject Win32_Share
    
    $Shares | Select-Object Name,Path,Description,PSComputername
}
