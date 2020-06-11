Add-PSSnapin wasp
$ws = new-object -comobject wscript.shell
"start bastion tunnel" | out-host
& "C:\Program Files\PuTTY\putty.exe" -load bastion_forward
sleep 10
$w = Select-Window -Title "Bastion Tunnel"
$w.Minimize()
sleep 2
"start case-dev5" | out-host
& "C:\Program Files\PuTTY\putty.exe" -load dcase-dev5
sleep 10
$w = Select-Window -Title "Case-Dev5"
if($w){
	Set-WindowActive -Window $w
	sleep 1
	$ws.sendkeys("screen -d -r rule_dev{ENTER}")
}


#& "C:\Program Files\PuTTY\putty.exe" -load jp-case-dev5
#sleep 5

& "C:\Program Files\Pidgin\pidgin.exe"

$w = @(Select-Window -Title "Rules Inspector")
if ($w.Count -ne 1) {
	"start rule inspector" | out-host
	start C:\WINDOWS\system32\windowspowershell\v1.0\powershell.exe c:/scripts/explain_rule.ps1
} else {
	"rule inspector exists" | out-host
}
