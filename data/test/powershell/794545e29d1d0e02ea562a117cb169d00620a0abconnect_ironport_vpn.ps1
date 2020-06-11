# remove net use

net use | ? {$_ -like "*:*"} | % {$_.split(" ")} | ? {$_ -like "*:"} | % { "net use "+$_+" /delete"} | % { Invoke-Expression $_}

net use o: /delete
net use p: /delete
net use v: /delete

# stop window update

net stop "Automatic Updates"

# load greenarrow

. c:/scripts/load_green_arrow.ps1

# start vpn client

& "C:\Documents and Settings\qi.zheng\Application Data\Microsoft\Internet Explorer\Quick Launch\VPN Client.lnk"

sleep 5

Select-Window -ProcessName vpngui | sv vw

sleep 1

Set-WindowActive -Window $vw | out-null
sleep -milliseconds 500;


new-object -comobject wscript.shell | sv ws

$ws.sendkeys("i")

sleep 1

$ws.sendkeys("{ENTER}")

wait-mark "ciscomark"

$ws.sendkeys("IQgnehz25")

sleep 1

$ws.sendkeys("{ENTER}")

sleep 5


c:/scripts/login_msn.ps1

c:/scripts/start_commonly_used_program.ps1

