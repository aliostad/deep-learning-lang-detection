$esxcli.storage.core.claimrule.add("vmhba1",$null,0,$null,$null,$null,$null,$null,$null,2,$null,"MASK_PATH",282,0,$null,"location",$null,$null,$null)
$esxcli.storage.core.claimrule.load()
$esxcli.storage.core.claiming.unclaim("vmhba1",0,$null,$null,$null,2,$null,$null,"MASK_PATH",0,"location",$null)

$esxcli.storage.core.claimrule.add("vmhba1",$null,0,$null,$null,$null,$null,$null,$null,2,$null,"MASK_PATH",283,1,$null,"location",$null,$null,$null)
$esxcli.storage.core.claimrule.load()
$esxcli.storage.core.claiming.unclaim("vmhba1",0,$null,$null,$null,2,$null,$null,"MASK_PATH",1,"location",$null)

$esxcli.storage.core.claimrule.add("vmhba1",$null,0,$null,$null,$null,$null,$null,$null,2,$null,"MASK_PATH",284,2,$null,"location",$null,$null,$null)
$esxcli.storage.core.claimrule.load()
$esxcli.storage.core.claiming.unclaim("vmhba1",0,$null,$null,$null,2,$null,$null,"MASK_PATH",2,"location",$null)

$esxcli.storage.core.claimrule.add("vmhba1",$null,0,$null,$null,$null,$null,$null,$null,2,$null,"MASK_PATH",285,3,$null,"location",$null,$null,$null)
$esxcli.storage.core.claimrule.load()
$esxcli.storage.core.claiming.unclaim("vmhba1",0,$null,$null,$null,2,$null,$null,"MASK_PATH",3,"location",$null)

$esxcli.storage.core.claimrule.run()