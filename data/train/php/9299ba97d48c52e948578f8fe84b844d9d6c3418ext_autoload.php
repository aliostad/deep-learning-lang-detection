<?php
$extensionClassesPath = t3lib_extMgm::extPath('pchart') . 'Classes/';
return array(
	'tx_pchart_service_barcode128' => $extensionClassesPath . 'Service/Barcode128.php',
	'tx_pchart_service_barcode39' => $extensionClassesPath . 'Service/Barcode39.php',
	'tx_pchart_service_bubble' => $extensionClassesPath . 'Service/Bubble.php',
	'tx_pchart_service_cache' => $extensionClassesPath . 'Service/Cache.php',
	'tx_pchart_service_data' => $extensionClassesPath . 'Service/Data.php',
	'tx_pchart_service_draw' => $extensionClassesPath . 'Service/Draw.php',
	'tx_pchart_service_image' => $extensionClassesPath . 'Service/Image.php',
	'tx_pchart_service_indicator' => $extensionClassesPath . 'Service/Indicator.php',
	'tx_pchart_service_pie' => $extensionClassesPath . 'Service/Pie.php',
	'tx_pchart_service_radar' => $extensionClassesPath . 'Service/Radar.php',
	'tx_pchart_service_scatter' => $extensionClassesPath . 'Service/Scatter.php',
	'tx_pchart_service_split' => $extensionClassesPath . 'Service/Split.php',
	'tx_pchart_service_spring' => $extensionClassesPath . 'Service/Spring.php',
	'tx_pchart_service_stock' => $extensionClassesPath . 'Service/Stock.php',
	'tx_pchart_service_surface' => $extensionClassesPath . 'Service/Surface.php',
);
?>