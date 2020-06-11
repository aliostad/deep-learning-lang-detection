<?php

abstract class PagarMe 
{
	public static $api_key; 
	const live = 1;
	const endpoint = "https://api.pagar.me/1";
	const api_version = '1';

	public function full_api_url($path) {
		// return self::endpoint . '/' . self::api_version . $path;
		return self::endpoint . $path;
	}

	public static function setApiKey($api_key) {
		self::$api_key = $api_key; 
	}

	public static function getApiKey() {
		return self::$api_key;
	}

	public static function validateFingerprint($id, $fingerprint) {
			return (sha1($id."#".self::$api_key) == $fingerprint);
	}
}


?>
