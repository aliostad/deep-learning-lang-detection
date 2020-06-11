<?php

/* following two lines are simple protectors against deletion */
$cfg_UnguardedHGInventoryService = array(
	"use"=>"permissions/InventoryService/HG1_0",
	"service"=>"Inventory"
);

$cfg_UnguardedHGAssetService = array(
	"use"=>"permissions/AssetService/HG",
	"service"=>"Asset"
);

/* following lines are session guards */
$cfg_HGInventoryService = array(
	"use"=>"services/hypergrid/InventoryGuardService",
	"service"=>"UnguardedHGInventory"
);

$cfg_HGAssetService = array(
		"use"=>"services/hypergrid/AssetGuardService",
		"service"=>"UnguardedHGAsset"
);


$cfg_HGGroupsService = array(
	"use"=>"linkto:Groups"
);

$cfg_HGFriendsService = array(
	"use"=>"services/hypergrid/HGFriendsService"
);
