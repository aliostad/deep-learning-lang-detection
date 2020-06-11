# ################################################################
<#
 Script      : vSmartCard.ps1
 Description : Manage Virtual Smart Cards
 Author      : cblanken@microsoft.com
 Date        : 3/20/2015
 Version     : V 1.0
 ----------------------------------------------------------------

 Startup Arguments: 
    
    -List [-Name]                  : Display Virtual Smart Cards - Default shows all Virtual Smart Cards
    -Create [-Name]                : Create Virtual Smart Card - Default Name is vSmartCard
    -Remove [-Name] or [-DeviceID] : Remove by matching DisplayName or DeviceID
 
 Additional Arguments:

    -Name             : The Display Name of Virtual Smart Card
    -DeviceID         : The DeviceID of Virtual Smart Card
    -DefaultAdminKey  : Use Default Admin Key instead of randomizing
    -Details          : Display extended data on Virtual Smart Cards

 Example Syntax:

    *** Displays all Virtual Smart Cards ***
    vSmartCard

    *** Displays all Virtual Smart Cards with the name "vSmartCard" ***
    vSmartCard -List -Name "vSmartCard"
    
    *** Create Virtual Smart Card with the default name "vSmartCard" and Random Admin Key ***
    vSmartCard -Create

    *** Create Virtual Smart Card with the name "mySmartCard" and Random Admin Key ***
    vSmartCard -Create -Name "mySmartCard"

    *** Create Virtual Smart Card with the name "vSmartCard" and Default Admin Key ***
    vSmartCard -Create -Name "vSmartCard" -DefaultAdminKey

    *** Removes all Virtual Smart Cards with the name "vSmartCard" ***
    vSmartCard -Remove -Name "vSmartCard"

    *** Remove all Virtual Smart Cards with the DeviceID ROOT\SMARTCARDREADER\0001 ***
    vSmartCard -Remove -DeviceID ROOT\SMARTCARDREADER\0001


 Keywords    : Virtual SmartCard Smart Card
#>
# ###############################################################
[CmdletBinding(DefaultParameterSetName="ListSet")]
param(
    [parameter(Mandatory=$True,position=0,HelpMessage='Create a new Virtual Smart Card',ParameterSetName="CreateSet")]
    [Alias("C")][switch]$Create,

    [parameter(Mandatory=$True,position=0,HelpMessage='Remove an existing Virtual Smart Card',ParameterSetName="RemoveSet")]
    [Alias("R")][switch]$Remove,

    [parameter(Mandatory=$False,position=0,HelpMessage='List existing Virtual Smart Cards',ParameterSetName="ListSet")]
    [Alias("L")][switch]$List,
        
    [parameter(Mandatory=$False,position=1,HelpMessage='Name of the Virtual Smart Card')]
    [parameter(ParameterSetName="CreateSet")][parameter(ParameterSetName="ListSet")][parameter(ParameterSetName="RemoveSet")]
    [Alias("N")][string]$Name = "*",

    [parameter(Mandatory=$False,position=1,HelpMessage='DeviceID of the Virtual Smart Card')]
    [parameter(ParameterSetName="RemoveSet")][parameter(ParameterSetName="ListSet")]
    [Alias("D")][string]$DeviceID = "*",

    [parameter(Mandatory=$False,HelpMessage='Use Default Admin Key')]
    [parameter(ParameterSetName="CreateSet")]
    [switch]$DefaultAdminKey,

    [parameter(Mandatory=$False,HelpMessage='Show extended Virtual Smart Card Details')]
    [parameter(ParameterSetName="ListSet")]
    [switch]$Details

    )
$Error.Clear()
Set-StrictMode –Version Latest

# ################################################################
# Functions and Variable Definitions
# ################################################################
function get-vCards() {
    param(
        [parameter(Mandatory=$False,HelpMessage='Display Name for the Virtual Smart Card')]
        [string]$name,
        [parameter(Mandatory=$False,HelpMessage='Device ID for the Virtual Smart Card')]
        [string]$deviceID
    )

    [object]$items = Get-WmiObject -Class Win32_PnPEntity -Namespace 'root/CIMV2' | `
        Where-Object { $_.Name -like $name -and $_.DeviceID -like $deviceID -and $_.Description -eq 'Microsoft Virtual Smart Card (WUDF)' }

    return $items
}

function remove-vCards() {
    param(
        [parameter(Mandatory=$True,HelpMessage='Virtual Smart Cards object')]
        [ValidateNotNullOrEmpty()][object]$vCards
    )

    $vCards | ForEach-Object {
        $result = Start-Process tpmvscmgr -ArgumentList "destroy /instance $($_.DeviceID)" -wait -NoNewWindow -PassThru
    
        if ( $result.ExitCode -eq 0 ) { 
            Write-Host -ForegroundColor Green ('{0} : {1} has been destroyed' -f $_.Name, $_.DeviceID)
        } else {
            Write-Warning ("Unexpected error occurred removing the Virtual Smart Card [Exit Code {0}]" -f $result.ExitCode)
        }
    }
}

function create-vCard() {
    param(
        [parameter(Mandatory=$True,HelpMessage='Name of the Virtual Smart Card to create')]
        [ValidateNotNullOrEmpty()][string]$name,
        [parameter(Mandatory=$False,HelpMessage='Use Default Admin Key')]
        [Boolean]$defaultAdminKey
    )
    
    if ($name -eq "*") { $name = "vSmartCard"}

    Write-Host -ForegroundColor Green "Creating Virtual Smart Card"
    
    if ($defaultAdminKey) { 
        [string]$keyValue = "010203040506070801020304050607080102030405060708"
        [object]$result = Start-Process tpmvscmgr -ArgumentList "create /name $name /pin default /adminkey Default /generate" -wait -NoNewWindow -PassThru
    } else {
        [string]$keyValue = "Randomized [Unknown]"
        [object]$result = Start-Process tpmvscmgr -ArgumentList "create /name $name /pin default /adminkey Random /generate" -wait -NoNewWindow -PassThru
    }

    if ( $result.ExitCode -eq 0 ) {

        [string]$deviceID = "*"
        $vCards = get-vCards $name $deviceID
        $latest = $vCards

        if($vCards.GetType().Name -ne "ManagementObject") {
            $latest = $vCards[($vCards.Count -1)]
        }

        Write-Host -ForegroundColor Cyan "`tName      : $name"
        Write-Host -ForegroundColor Cyan ("`tDeviceID  : {0}" -f $latest.DeviceID)
        Write-Host -ForegroundColor Cyan "`tAdmin Key : $keyValue"
        Write-Host -ForegroundColor Cyan "`tUser PIN  : 12345678"

    } else {
        Write-Warning ("Virtual Smart Card has not been created : Exit Code [{0}]" -f $result.ExitCode)
    }
}

function isAdmin {
# Function from: http://powershell.com/cs/media/p/200.aspx
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    $admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    $principal.IsInRole($admin)
}

function isTPMReady() {
    $tpm = Get-Tpm
    return $tpm.TpmReady
}
# ################################################################
# Script tasks starting
# ################################################################
If (-not (isAdmin)) {
    Write-Warning "MUST BE RUN FROM AN ELEVATED ADMIN POWERSHELL CONSOLE"
    Exit
}

if(-not(isTPMReady)) {
    Write-Warning "The TPM must already be configured before creating a Virtual Smart Card."
    Exit
}

# Get Virtual Smart Cards
[object]$vSmartCards = get-vCards $Name $DeviceID

if ($Create) {

    create-vCard $Name $DefaultAdminKey.IsPresent

} elseif ($Remove) {

    if (-not($vSmartCards)) {
        Write-Warning 'No Virtual Smart Cards were found'
    
    } elseif($Name -eq $DeviceID) {
        Write-Warning "Virtual Smart Card removal requires either a Name or Device ID"

    } else {
        remove-vCards $vSmartCards
    }

} else {
    
    if (-not($vSmartCards)) {
        Write-Warning 'No Virtual Smart Cards were found'
    } else {

        if($Details) {
            $vSmartCards

        } else {
            $vSmartCards | Select-Object Name, DeviceID
        
        }        
    }
}