New-Alias VBoxManage "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

# Get the path of the home Accordance directory
$ACCORDANCE_DIR = (get-item $script:MyInvocation.MyCommand.Path).Directory.parent.FullName

IF(!$Env:DOCKER_MACHINE_NAME) {
  $Env:DOCKER_MACHINE_NAME = "dev"
}

VBoxManage sharedfolder add "$Env:DOCKER_MACHINE_NAME" -name accordance -hostpath $ACCORDANCE_DIR
VBoxManage modifyvm "$Env:DOCKER_MACHINE_NAME" --natpf1 "orientdb-bin,tcp,127.0.0.1,2424,,2424"
VBoxManage modifyvm "$Env:DOCKER_MACHINE_NAME" --natpf1 "orientdb-web,tcp,127.0.0.1,2480,,2480"
VBoxManage modifyvm "$Env:DOCKER_MACHINE_NAME" --natpf1 "nginx,tcp,127.0.0.1,8000,,8000"
VBoxManage modifyvm "$Env:DOCKER_MACHINE_NAME" --natpf1 "redis,tcp,127.0.0.1,6379,,6379"
VBoxManage modifyvm "$Env:DOCKER_MACHINE_NAME" --natpf1 "consul,tcp,127.0.0.1,8500,,8500"
VBoxManage modifyvm "$Env:DOCKER_MACHINE_NAME" --natpf1 "mongo,tcp,127.0.0.1,27017,,27017"
