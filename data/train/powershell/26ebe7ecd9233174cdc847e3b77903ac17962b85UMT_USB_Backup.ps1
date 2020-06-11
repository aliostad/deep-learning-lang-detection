#REQUIRES -Version 2.0

<#
.SYNOPSIS
    Assist in migrating user data from old to new PC [STUB:USB_Backup ONLY]
.DESCRIPTION
    Add and remove user accounts from AD on the Dept of Primary Industries SA 
    Easily allow users to move their UserData and %USERPROFILE% from their old 
    machine to their new machine. This tool is designed primarily for Department 
    of Primary Industries IT staff to use when assisting users migrate their 
    data directly. Prompt based application via Command Prompt and will exit 
    if a wrong choice is made along the way. This is a safety feature. Allows 
    the data to be directly transferred, backed up and restored from a large 
    enough USB drive or backed up and restored from a network drive (when the 
    user is swapping the computer at the desk and doesn't have access to an 
    external USB drive or a second network point to connect the machine 
    simultaneously.	
.NOTES
    File Name      : UMT_USB_Backup.ps1
    Author         : Danijel James (danijel.james@gmail.com)
    Prerequisite   : PowerShell V2 over Vista and upper.
    Copyright 2017 - Danijel James/danijeljw
.LINK
    Script posted over:
    http://www.github.com/danijeljw/
.EXAMPLE
    Example 1
.EXAMPLE
    Example 2
#>

<#
======================================
1. DECLARE GLOBAL VARIABLES (AS $NULL)
======================================
#>

$global:UserID2Backup = $NULL
$global:USBDriveLetter = $NULL


<#
===========================
2. IMPORT DEPENDANT MODULES
===========================
#>


<#
===========================
3. DECLARE GLOBAL FUNCTIONS
===========================
#>

function global:ExitClause{
    Clear-Host
    Write-Host ""
    Write-Host "Invalid entry received!" -ForegroundColor Red -BackgroundColor Black
    Write-Host ""
    Write-Host "Exiting script!" -ForegroundColor DarkYellow -BackgroundColor Black
    Start-Sleep -s 5
    exit
}


function global:ConfirmUserID{
    Clear-Host
    Write-Host "Is your UserID " -NoNewLine
    Write-Host $env:UserName -ForegroundColor Yellow -BackgroundColor Black -NoNewline
    Write-Host "?"
    Start-Sleep -s 1
    Write-Host "Press " -NoNewline
    Write-Host "[1]" -ForegroundColor DarkYellow -NoNewline
    Write-Host " for yes or " -NoNewLine
    Write-Host "[2]" -ForegroundColor DarkYellow -NoNewLine
    $global:IsUserIDCorrect = Read-Host " to change"
}




<#
$BackupUserID now becomes the UserID that we need to grab files from, and then create the $env:UserName folder
in the target 'cos that means the user may have changed their name!
#>


write-host $env:UserName -ForegroundColor Yellow -BackgroundColor Black


































<#
.SYNOPSIS
    Hung's User Admin Tool (HUAT) to manage and implement changes in AD for
	user accounts in the PISADOM01 domain
.DESCRIPTION
    Add and remove user accounts from AD on the Dept of Primary Industries SA
	PISADOM01 domain. Update WiFi certificate requirements by MAC Address. Filter
	the MAC Addresses assigned to user accounts to a report. Remove and add user
	accounts to AD Group Memberships.
.NOTES
    File Name      : HUAT.ps1
    Author         : Danijel James (danijel.james@gmail.com)
    Prerequisite   : PowerShell V2 over Vista and upper.
    Copyright 2017 - Danijel James/danijeljw
.LINK
    Script posted over:
    http://www.github.com
.EXAMPLE
    Example 1
.EXAMPLE
    Example 2
#>

<#
=================
1. IMPORT MODULES
=================
#>
import-module ActiveDirectory

<#
=====================
2. FOREGROUND COLOURS
=====================

Colours that can be used with the '-foreground' switch on the 'write-host' command

    Black
    Blue
    Cyan
    DarkBlue
    DarkCyan
    DarkGray
    DarkGreen
    DarkMagenta
    DarkRed
    DarkYellow
    Gray
    Green
    Magenta
    Red
    White
    Yellow
#>

<#
=========================
3. SET PARAMETER REQUIRED
=========================

	TestUserAdmin	bool test of elevated environment
	AdminDotAcct	op's PISADOM01\admin.XXX user admin account
	AdminDotPass	op's PISADOM01\admin.XXX network password as a secure string (revoked at this time)
	nl				New line for environment text (same ase '\n' in C)
#>
$nl = [Environment]::NewLine
$TestUserAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
$AdminDotAcct = Read-Host 'What is your PISADOM01 Admin account?'
#$AdminDotPass = Read-Host 'What is your PISADOM01 Admin password?' -AsSecureString


<#
====================
3. DECLARE FUNCTIONS
====================
#>
<#
function AdminDotAcct{
	$AdminDotAcct2 = Read-Host 'What is your admin account ID?'
}
#>



<#
################################################################################
    Main - Option 1
################################################################################
#>