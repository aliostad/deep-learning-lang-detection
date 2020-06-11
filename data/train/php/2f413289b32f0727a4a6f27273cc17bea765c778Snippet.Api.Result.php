<?php

/**
 * Renders the result of an API in jSON format
 *
 * @param	array	$apiArguments	The list of arguments received by the API
 * @param	mixed	$apiResult		The result of the API
 *
 * @return	mixed	$apiResult		The result of the API
 * @return	bool	$isRaw			True to display the result in raw format, false otherwise
 */


// Get the arguments and result

$apiArguments = fv('apiArguments');
$apiResult = fv('apiResult');


// Convert the API result into JSON

$apiResult = json_encode($apiResult);


// Should we display the result in raw format?

$isRaw = (isset($apiArguments['encodeHtmlEntities']) == true);


// Prepare variables for the view

v('apiResult', $apiResult);
v('isRaw', $isRaw);

?>
