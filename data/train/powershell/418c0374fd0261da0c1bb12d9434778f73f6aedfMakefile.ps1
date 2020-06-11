$nasmPath = "C:\Program Files (x86)\Nasm"
$virtualBoxPath = "C:\Program Files\Oracle\VirtualBox"

$env:Path += ";" + $nasmPath
$env:Path += ";" + $virtualBoxPath

# --- Clean START
rm asm/*.o
rm bin/*
# --- Clean END

nasm asm/mbc.asm -o asm/mbc.o
nasm asm/mbr.asm -o asm/mbr.o
nasm asm/sector0.asm -o asm/sector0.o

gc asm/mbc.o, asm/mbr.o, asm/sector0.o -Enc Byte -Read 1024 `
  | sc bin/disk.img -Enc Byte

VBoxManage convertfromraw bin/disk.img bin/disk.vdi
VBoxManage unregistervm "MyBootable" --delete
VBoxManage createvm --name "MyBootable" --register
VBoxManage storagectl "MyBootable" --name "DiskController" --add ide `
  --bootable on
VBoxManage storageattach "MyBootable" --storagectl "DiskController" --port 0 `
  --device 0 --type hdd --medium bin/disk.vdi
VBoxManage startvm "MyBootable"