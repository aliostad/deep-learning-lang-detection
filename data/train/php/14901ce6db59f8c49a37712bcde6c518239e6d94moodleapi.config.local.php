<?php 

/**
 * moodleapi.config.php
 * @author Robert Leonhardt
 */

## Moodle Server
define( 'MOODLE_API_SERVER',   	 'http://elearning.dev.com/' );

## Moodle Werbservicename
define( 'MOODLE_API_WEBSERVICE', 'cosmb' );
##define( 'MOODLE_API_WEBSERVICE', 'testpluginws' );

## API-Benutzer
#define( 'MOODLE_API_USER', 	     'thcc' );
#define( 'MOODLE_API_USER', 	     'wstu' );
define( 'MOODLE_API_USER', 	     'admin' );

## API-Benutzer Passwort
#define( 'MOODLE_API_PASSWORD',   'thccBeta14_' );
#define( 'MOODLE_API_PASSWORD',   'wstuBeta01_' );
define( 'MOODLE_API_PASSWORD',   'Geheim01!' );


## Token-URL
define( 'MOODLE_API_TOKEN_URL',	 MOODLE_API_SERVER . 'login/token.php?username=' . MOODLE_API_USER . '&password=' . MOODLE_API_PASSWORD . '&service=' . MOODLE_API_WEBSERVICE );

## SOAP-URL
define( 'MOODLE_API_SOAP_URL',   MOODLE_API_SERVER . 'webservice/soap/server.php?wsdl=1&wstoken=' );

?>