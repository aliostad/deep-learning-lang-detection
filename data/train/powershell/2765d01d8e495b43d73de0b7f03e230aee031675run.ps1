param([switch] $debug)

Write-Host "Start script"

#Remove windows CR

$files = gci ./etc *.* -File -rec | where {! $_.ps1} | %{$_.FullName}
foreach ($file in $files){
	sed -i 's/\r//' ${file}
}

# Name of config file
$conf="idp_config.py"

# Image name
$image="itsdirg/pefim_idp"

# Name of container
$name="pefim_idp"

# relative path to volume
$volume="etc"

$dir = Convert-Path .
$dir = $dir -replace "C:", "/c"
$dir = $dir -replace "\\", "/"

$port = cat ${volume}/${conf} | grep PORT | head -1 | sed 's/[^0-9]//g'

$ssh_path = "c:\Program Files (x86)\Git\bin"

[int]$port_check=[convert]::ToInt32($(netstat -an | grep ${port} | wc -l))
[int]$port_b2d=[convert]::ToInt32($(& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" showvminfo "boot2docker-vm" --details | grep ${port} | wc -l))

IF ($port_b2d -eq 0){
	IF ($port_check -eq 0 ){
		$port_b2d=1
		& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "boot2docker-vm" natpf1 "${name},tcp,127.0.0.1,${port},,${port}"
	}
	ELSE{
		Write-Host "Port: ${port} is already used! Change port in the file ${conf}"
		Exit
	}
}

IF (!($Env:Path | Select-String -SimpleMatch $ssh_path)){
	$Env:Path = "${Env:Path};$ssh_path"
}

IF ($(Boot2Docker status) -ne "running"){
	$(Boot2Docker start)
}

IF ($Env:DOCKER_HOST.length -eq 0){
	boot2docker shellinit | Invoke-Expression
}

IF ($(docker ps | %{ $_.Split(' ')[0];} | grep ${name} | wc -l) -eq 1){
	docker kill ${name}
}


docker rm ${name} 2>&1> $null;

mkdir ./etc/logs 2>&1> $null;
mkdir ./etc/db 2>&1> $null;

$debug_args = ""

IF ($debug){
	docker run --rm=true --name ${name} --hostname localhost -v ${dir}/${volume}:/opt/pefim/etc -p ${port}:${port} --entrypoint /bin/bash -i -t ${image}
}
ELSE{
	docker run --rm=true --name ${name} --hostname localhost -v ${dir}/${volume}:/opt/pefim/etc -p ${port}:${port} -i -t ${image}
}


IF ($port_b2d -eq 1){
	# delete port forwarding
	& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "boot2docker-vm" natpf1 delete "${name}"
}
Write-Host "End script"
