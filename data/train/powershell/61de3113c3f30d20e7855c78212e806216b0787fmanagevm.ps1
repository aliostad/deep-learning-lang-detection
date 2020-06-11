#Set the environment to the VirtualBox directoy
$env:Path = "C:\Program Files\Oracle\VirtualBox\";

#Set an array for each vm I want to boo up. This is just the name of the vm in VirtualBox
$vms = @("git01","web01","salt01","dns01","docker01")

function vmloop {

    $vmcommand = $args[0] 
    $vmcommandopt = $args[1]
	$vmcommandopt2 = $args[2]
	foreach ($i in $vms) {
	
        VBoxManage $vmcommand $i $vmcommandopt $vmcommandopt2

	}
	
}

$vmoption = $args[0]

switch ($vmoption)
	{
		#start all the vm's specified in the $vm array
		start {
            vmloop startvm 
		}
		#save the state of all the vm's specified in the $vm array
		save {			
			vmloop controlvm savestate
		}
		snapshot {
			vmloop snapshot take test
		}

	}






