$DOCKERVM_CFG_DIR="$HOME\.dockervm"

$VM_NAME="dockervm"
$VBM="$env:ProgramW6432\Oracle\VirtualBox\VBoxManage.exe"

$DOCKER_PORT=4243
$SSH_HOST_PORT=2222

$VM_DISK_SIZE=40000
$VM_MEM=2048

$VM_DISK="$DOCKERVM_CFG_DIR\$VM_NAME.vmdk"
$BOOT2DOCKER_ISO="$DOCKERVM_CFG_DIR\boot2docker.iso"

$DOCKERVM_PUTTY="$DOCKERVM_CFG_DIR\putty.exe"
$DOCKERVM_PLINK="$DOCKERVM_CFG_DIR\plink.exe"

function Connect-Docker {
  if (prepare) { return }
  
  &$DOCKERVM_PUTTY -ssh docker@localhost -P $SSH_HOST_PORT -pw tcuser
}

function Format-Docker {
  if (prepare) { return }
  
  (&$VBM startvm $VM_NAME --type headless)
  wait_start
  (&echo y | &$DOCKERVM_PLINK -ssh -P $SSH_HOST_PORT -pw tcuser docker@localhost "mkfs.ext4 -F -L boot2docker-data /dev/sda && sudo poweroff")
  wait_stop
}

function Get-Docker {
  if (prepare) { return }
  
  if (is_running) {
    log "$VM_NAME is running."
  }
  elseif (is_paused) {
    log "$VM_NAME is paused."
  }
  elseif (is_saved) {
    log "$VM_NAME is saved."
  }
  elseif (is_suspended) {
    log "$VM_NAME is suspended."
  }
  elseif (is_stopped) {
    log "$VM_NAME is stopped."
  }
  elseif (is_aborted) {
    log "$VM_NAME is aborted."
  }
  else {    
    log "$VM_NAME does not exist."
  }
}

function Install-Docker {
  if (prepare) { return }

  (&$VBM showvminfo $VM_NAME) 2>&1>$null
  if ($LastExitCode -eq 0) {
    Write-Output "$VM_NAME Virtual Box vm already exists"
    return
  }

  $VM_OSTYPE="Linux26_64"
  $VM_NIC="82540EM"
  $VM_CPUS=(get_cores)

  if ((port_in_use $DOCKER_PORT)) {
    Write-Output "DOCKER_PORT=$DOCKER_PORT on localhost is used by an other process!"
    return
  }
  
  if ((port_in_use $SSH_HOST_PORT)) {
    Write-Output "DOCKER_PORT=$SSH_HOST_PORT on localhost is used by an other process!"
    return
  }

  log "Creating VM $VM_NAME..."
  (&$VBM createvm --name $VM_NAME --register) >$null
  log "Applying interim patch to VM $VM_NAME (https://www.virtualbox.org/ticket/12748)..."
  (&$VBM setextradata $VM_NAME VBoxInternal/CPUM/EnableHVP 1)

  log "Setting VM settings..."
  
  (&$VBM modifyvm $VM_NAME `
    --ostype $VM_OSTYPE `
    --cpus $VM_CPUS `
    --memory $VM_MEM `
    --rtcuseutc on `
    --acpi on `
    --ioapic on `
    --hpet on `
    --hwvirtex on `
    --vtxvpid on `
    --largepages on `
    --nestedpaging on `
    --firmware bios `
    --bioslogofadein off --bioslogofadeout off --bioslogodisplaytime 0 --biosbootmenu disabled `
    --boot1 dvd)

  log "Setting VM networking..."
  (&$VBM modifyvm $VM_NAME `
    --nic1 nat `
    --nictype1 $VM_NIC `
    --cableconnected1 on)
  
  $vminfo = (&$VBM showvminfo dockervm)
  
  if ((($vminfo) -match "Rule.*ssh")[0] -match "ssh") {
    (&$VBM modifyvm $VM_NAME --natpf1 delete ssh)
  }
  if ((($vminfo) -match "Rule.*docker")[0] -match "docker") {
    (&$VBM modifyvm $VM_NAME --natpf1 delete docker)
  }
  (&$VBM modifyvm $VM_NAME `
    --natpf1 "ssh,tcp,127.0.0.1,$SSH_HOST_PORT,,22" `
    --natpf1 "docker,tcp,127.0.0.1,$DOCKER_PORT,,4243")
  
  $netadp=(get-wmiobject win32_networkadapter | Where ServiceName -eq VBoxNetAdp | Select Name)[0].Name

  (&$VBM modifyvm $VM_NAME `
    --nic2 hostonly `
    --nictype2 $VM_NIC `
    --hostonlyadapter2 "$netadp" `
    --cableconnected2 on)
  
  If (!(Test-Path $BOOT2DOCKER_ISO)) {
    log "boot2docker.iso not found."
    Update-Docker
  }

  log "Setting VM disks..."
  if ((($vminfo) -match "SATA")[0] -match "SATA") {
    (&$VBM storagectl $VM_NAME --name SATA --remove)
  }
  
  If (!(Test-Path $VM_DISK)) {
    log "Creating $VM_DISK_SIZE Meg hard drive..."
    (&$VBM createhd --filename "$VM_DISK" --size $VM_DISK_SIZE --format VMDK) 2>&1>$null
  }
  
  (&$VBM storagectl $VM_NAME --name "SATA" --add sata --hostiocache on)
  (&$VBM storageattach $VM_NAME --storagectl "SATA" --port 0 --device 0 --type dvddrive --medium "$BOOT2DOCKER_ISO")
  (&$VBM storageattach $VM_NAME --storagectl "SATA" --port 1 --device 0 --type hdd --medium "$VM_DISK")
  
  log "Formating $VM_DISK_SIZE Meg hard drive..."
  Format-Docker
  Start-Docker
}

function Measure-Docker {
  if (prepare) { return }
  
  if (is_installed) {
    Write-Output (get_info)
  } else {
    Write-Output "$VM_NAME does not exist."
  }
}

function Restart-Docker {
  if (prepare) { return }
  
  if (is_running) {
    Stop-Docker
    Start-Docker
  } else {
    Start-Docker
  }
}

function Start-Docker {
  if (prepare) { return }
  
  if (!(is_running)) {
    if (is_paused) {
      log "Resuming $VM_NAME"
      (&$VBM controlvm $VM_NAME resume) >$null
      wait_start
      log "Resumed."
    } else {
      log "Starting $VM_NAME..."
      (&$VBM startvm $VM_NAME --type headless) >$null
      wait_start
      log "Started."
    }
  } else {
    log "$VM_NAME is already running."
  }
  
  if ((((get-item env:).Name) -like "*DOCKER_HOST*") -and ((get-item env:DOCKER_HOST).Value -ne "tcp://localhost:${DOCKER_PORT}")) {
    Write-Output
    Write-Output "To connect the docker client to the Docker daemon, please set:"
    Write-Output "export DOCKER_HOST=tcp://localhost:${DOCKER_PORT}"
    Write-Output
  }
}

function Stop-Docker {
  if (prepare) { return }
  
  if (is_running) {
    log "Shutting down $VM_NAME"
    while (is_running) {
      (&$VBM controlvm $VM_NAME acpipowerbutton) 2>&1>$null
      sleep 1
    }
  } else {
    log "$VM_NAME is not running."
  }
}

function Suspend-Docker {
  if (prepare) { return }
  
  if (is_running) {
    log "Suspending $VM_NAME"
    (&$VBM controlvm $VM_NAME savestate) >$null
    wait_stop
  } else {
    log "$VM_NAME is not running."
  }
}

function Uninstall-Docker {
  if (prepare) { return }
  
  if (!(is_installed)) {
    Write-Output "$VM_NAME does not exist."
    return
  }
  $confirm = Read-Host "Are you sure you want to delete the '$VM_NAME' VM? [y/N]"
  if ($confirm.ToLowerInvariant() -ne "y") {
    return
  }
  if ((!(is_stopped)) -and (!(is_aborted))) {
    Stop-Docker
  }
  log "Deleting VM $VM_NAME"
  (&$VBM unregistervm --delete $VM_NAME) 2>&1>$null
}

function Update-Docker {
  if (prepare) { return }
  
  $LATEST_RELEASE=(get_latest_release_name)
  if ($LATEST_RELEASE -ne "ERROR") {
    log "Latest version is $LATEST_RELEASE, downloading..."
    Invoke-RestMethod "https://github.com/boot2docker/boot2docker/releases/download/$LATEST_RELEASE/boot2docker.iso" -OutFile $BOOT2DOCKER_ISO
  } else {
    log "Could not get latest release name! Cannot download boot2docker.iso."
  }
}

function is_installed {
  while ($True) {
    $res = (&$VBM list vms)
    if (($res -match "error").Count -eq 0) {
      return ($res -match "$VM_NAME").Count -eq 1
    }
    sleep 1
  }
}

function is_running {
  ((get_info) -match "State")[0] -match "running"
}

function is_paused {
  ((get_info) -match "State")[0] -match "paused"
}

function is_saved {
  ((get_info) -match "State")[0] -match "saved"
}

function is_suspended {
  ((get_info) -match "State")[0] -match "suspended"
}

function is_stopped {
  ((get_info) -match "State")[0] -match "powered off"
}

function is_aborted {
  ((get_info) -match "State")[0] -match "aborted"
}

function wait_start {
  while (!(test_connection localhost $SSH_HOST_PORT)) {
    sleep 1
  }
}

function wait_stop {
  while (is_running) {
    sleep 1
  }
}

function get_info {
  while ($True) {
    $res = (&$VBM showvminfo $VM_NAME)
    if (($res -match "ERROR").Count -eq 0) {
      return $res
    }
    sleep 1
  }
}

function prepare {
  !((vbm_found) -and (cfg_dir_found) -and (ssh_found))
}

function cfg_dir_found {
  If (!(Test-Path $DOCKERVM_CFG_DIR)) { mkdir $DOCKERVM_CFG_DIR | out-null }
  $res = !(Test-Path $DOCKERVM_CFG_DIR)
  If ($res) {
    Write-Output "Directory '$DOCKERVM_CFG_DIR' not found."
  }
  !($res)
}

function vbm_found {
  $res = !(Test-Path $VBM)
  If ($res) {
    Write-Output "Command 'vboxmanage' is required but not installed."
  }
  !($res)
}

function ssh_found {
  If (!(Test-Path $DOCKERVM_PUTTY)) { Invoke-RestMethod "http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe" -OutFile $DOCKERVM_PUTTY }
  If (!(Test-Path $DOCKERVM_PLINK)) { Invoke-RestMethod "http://the.earth.li/~sgtatham/putty/latest/x86/plink.exe" -OutFile $DOCKERVM_PLINK }
  $res = (!(Test-Path $DOCKERVM_PUTTY)) -or (!(Test-Path $DOCKERVM_PLINK))
  If ($res) {
    Write-Output "Commands 'putty' and 'plink' are required but not installed."
  }
  !($res)
}

function get_latest_release_name {
  try {
    (Invoke-RestMethod "https://api.github.com/repos/boot2docker/boot2docker/releases")[0].tag_name
  } catch {
    "ERROR"
  }
}

function log {
  Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $args" -foreground "cyan"
}

function port_in_use {
  (Get-NetTCPConnection).LocalPort -contains $args
}

function test_connection {
  try {
    $t = New-Object Net.Sockets.TcpClient
    $t.Connect($args[0],$args[1])
    $t.Connected
  } catch {
    $False
  }
}

function get_cores {
  (gwmi Win32_ComputerSystem).NumberOfLogicalProcessors
}

export-modulemember *-*
