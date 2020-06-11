# Code for Virtualbox 5.0.x
# Code version: 1.2

param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]$location = "C:\Program Files\Oracle\VirtualBox\",
    [String]$vm_name = "OS X NAME",
    [int]$vm = -1
)

function checkPath() {

    # Include description text
    description

    # Installed VirtualBox?
    if ( -Not (Test-Path "$location\VBoxManage.exe") ) {

        [String]$location = ""
        Write-Host "Installed VirtualBox?"

        do {
            [String]$location = $( Read-Host "Please write that has been installed (folder) to the program" )
            $location = ($location -replace '"','')
        } until ( (Test-Path "$location\VBoxManage.exe") )
    }
    
    # If valid folder
    createOSXVM
}

function description() {
    clear
    Write-Host "Hello!`r`nWith this script to set the VirtualBox to work with OSX.`r`n"
}

function setExtraData {

    # Set Virtual Machina name
    $vm_name = $collection[$vm].Name

    if ( -Not ([string]::IsNullOrEmpty($vm_name)) ) {

        switch -Regex ($vm_ver) {
            '^4' { fourDotX; break; }
            '^5.0.' { fiveDotNull; break; }
            default { Write-Host "[x] This version untested!" -foregroundcolor yellow; fiveDotNull; break; }
        }
    } else {

        Write-Host "Invalid Virtual Machine name!`r`nTry again!" -foregroundcolor Red
    }
}

function createOSXVM {

    # Include description text
    description

    # VirtualBox list
    $vm_list = & "$location\VBoxManage.exe" list vms

    # VirtualBox installed version
    $vm_ver = & "$location\VBoxManage.exe" -v
    $vm_ver = $vm_ver.Split('r')[0]
    Write-Host "Installed VirtualBox version": $vm_ver

    # Add to Array and remove unnecessary chars
    $trees = @($vm_list) -replace '({|})',''

    # Add Virtual Machine list to array
    $collection = @()

    for($i = 0; $i -lt $trees.length; $i++)
    {
        $temp = New-Object System.Object
        $temp | Add-Member -MemberType NoteProperty -Name "ID" -Value [$i]
        $temp | Add-Member -MemberType NoteProperty -Name "Name" -Value $trees[$i].Split('"')[1].Trim()
        $temp | Add-Member -MemberType NoteProperty -Name "UUID" -Value $trees[$i].Split('"')[2].Trim()
        $collection += $temp
    }

    # Print Virtual Machine list
    Write-Host "-------------------------------`r`nChoose between Virtual Machine!`r`n-------------------------------"
    Write-Host ($collection | Out-String)

    # Read choosed Virtual Machine
    [int]$vm = $( Read-Host "Please choose the Virtual Machine" )

    switch -Regex ($vm)
    {
        -1 { "Please select correct/valid number!" }
        "[0-9]" { setExtraData }
    }
}


function fourDotX {

    Write-Host "Run 4.x.x version script"

    & "$location\VBoxManage.exe" modifyvm $vm_name --cpuidset 00000001 000306a9 04100800 7fbae3ff bfebfbff
    & "$location\VBoxManage.exe" setextradata $vm_name "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "MacBookPro11,3"
    & "$location\VBoxManage.exe" setextradata $vm_name "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
    & "$location\VBoxManage.exe" setextradata $vm_name "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Iloveapple"
    & "$location\VBoxManage.exe" setextradata $vm_name "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
    & "$location\VBoxManage.exe" setextradata $vm_name "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1
}

function fiveDotNull {

    Write-Host "Run 5.0.x version script"

    & "$location\VBoxManage.exe" modifyvm $vm_name --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff
    & "$location\VBoxManage.exe" setextradata $vm_name "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac11,3"
    & "$location\VBoxManage.exe" setextradata $vm_name "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
    & "$location\VBoxManage.exe" setextradata $vm_name "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Iloveapple"
    & "$location\VBoxManage.exe" setextradata $vm_name "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
    & "$location\VBoxManage.exe" setextradata $vm_name "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1
}

# Run script
checkPath