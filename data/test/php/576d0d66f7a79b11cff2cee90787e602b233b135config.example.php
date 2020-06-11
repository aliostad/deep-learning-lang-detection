<?php
$api_key = '';
$api_base = 'http://thetvdb.com/';
$api_url = $api_base . 'api/';
$api_url_banners_base = $api_base . 'banners/';
$api_url_search = $api_url . 'GetSeries.php?language=es&seriesname=';
$api_url_serie = $api_url . $api_key . '/series/%s/%s.xml';
$api_url_all = $api_url . $api_key . '/series/%s/all/%s.xml';
$api_url_banners = $api_url . $api_key . '/series/%s/banners.xml';

$cache_days = 1;

$search_saved = array();

$search_saved_anime = array();

sort( $search_saved );
sort( $search_saved_anime );
