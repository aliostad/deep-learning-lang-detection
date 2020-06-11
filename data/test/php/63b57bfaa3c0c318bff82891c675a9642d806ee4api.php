<?php
$Api["name"] = "Api";
$Api["event"][0]["name"] = "subcontroler";
$Api["event"][0]["physical"] = "api.action.api.subcontroler()";
$Api["event"][0]["view"]["API_RESPONSE"] = "api.view.api.api_response()";
$Api["event"][0]["view"]["API_RESPONSE_COUNT"] = "api.view.api.api_response_count()";
$Api["event"][0]["view"]["API_ERROR"] = "api.view.api.api_error()";
$Api["event"][0]["view"]["API_RESPONSE_PAGE"] = "api.view.api.api_response_page()";
$Api["event"][0]["view"]["API_RESPONSE_WRAP"] = "api.view.api.api_response_wrap()";

$Api["event"][0]["view"]["API_ERROR_DETAIL"] = "api.view.api.api_error_detail()";
$Api["event"][0]["view"]["API_RESPONSE_PRODUCTLIST_WRAP"] = "api.view.api.api_response_productlist_wrap()";
$Api["event"][0]["view"]["API_RESPONSE_SIMPLE"] = "api.view.api.api_response_simple()";

$bunshop["module"][] = $Api;
