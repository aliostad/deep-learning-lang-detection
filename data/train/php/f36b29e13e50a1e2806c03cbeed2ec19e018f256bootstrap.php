<?php

Autoloader::add_core_namespace('Eldis');

Autoloader::add_classes(array(
	/**
	 * Eldis classes.
	 */
	'EldisAPI'							=> __DIR__.'/eldis_api/EldisApi.php',
    
    'EldisApiAssets'					=> __DIR__.'/eldis_api/EldisApiAssets.php',
    'EldisApiCountries'					=> __DIR__.'/eldis_api/EldisApiCountries.php',
    'EldisApiDocuments'					=> __DIR__.'/eldis_api/EldisApiDocuments.php',
    'EldisApiItems'					    => __DIR__.'/eldis_api/EldisApiItems.php',
    'EldisApiItemTypes'					=> __DIR__.'/eldis_api/EldisApiItemTypes.php',
    'EldisApiOrganisations'				=> __DIR__.'/eldis_api/EldisApiOrganisations.php',
    'EldisApiRegions'					=> __DIR__.'/eldis_api/EldisApiRegions.php',
    'EldisApiSectors'					=> __DIR__.'/eldis_api/EldisApiSectors.php',
    'EldisApiSubjects'					=> __DIR__.'/eldis_api/EldisApiSubjects.php',
    'EldisApiThemes'					=> __DIR__.'/eldis_api/EldisApiThemes.php',
	

));