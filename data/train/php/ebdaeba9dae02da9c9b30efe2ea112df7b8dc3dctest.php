<?php

require_once "lib/account.php";
require_once "lib/service.php";

$DataService = new DataService();

printf ("<h1>DataService Tests</h1>");
printf ("<h3>DataService Get</h3>");
printf ($DataService->service_get());
printf ("<hr>");

printf ("<h3>DataService Insert</h3>");
$data = array("title" => @date('dmy'));
printf ($oid = $DataService->service_post($data));
printf ("<br>");
printf ($DataService->service_get());
printf ("<hr>");

printf ("<h3>DataService Get One</h3>");
printf ($DataService->service_get_one($oid));
printf ("<hr>");

printf ("<h3>DataService Update</h3>");
$arrayName = array(
	'title' => "This has been changed",
	'body' => "Hello world!"
	);

printf ($DataService->service_get_one($oid));
printf ("<br>");
printf ("Returned: " . $DataService->service_update($oid, $arrayName));
printf ("<br>");
printf ($DataService->service_get_one($oid));
printf ("<hr>");

printf ("<h3>DataService Delete</h3>");
printf ($DataService->service_delete($oid));
printf ("<hr>");

printf ("<h3>DataService Final List</h3>");
printf ($DataService->service_get());
printf ("<hr>");

//printf (send_email());
?>