<?

class Hapyfish2_Rest_Factory
{
	public static function getRest($platform)
	{
		$apiInfo = Hapyfish2_Island_Bll_ApiInfo::getInfo($platform);
		if (!$apiInfo) {
			return null;
		}
		
		$rest = new Hapyfish2_Rest_Island($apiInfo['api_key'], $apiInfo['api_secret'], $apiInfo['host']);
		return $rest;
	}
	
	public static function getBot($platform)
	{
		$apiInfo = Hapyfish2_Island_Bll_ApiInfo::getInfo($platform);
		if (!$apiInfo) {
			return null;
		}
		
		$bot = new Hapyfish2_Rest_Bot($apiInfo['api_key'], $apiInfo['api_secret'], $apiInfo['host']);
		return $bot;
	}
}