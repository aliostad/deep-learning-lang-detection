<?php

/**
 * 常用模块服务加载器
 * @author blueyb.java@gmail.com
 * @since 1.0 2012-08-01
 */
class CommonServiceFactory{
	
	/**
	 * 配置服务
	 * @var IConfigService
	 */
	private static $configService;
	
	/**
	 * 地区服务
	 * @var IRegionService
	 */
	private static $regionService;
	
	/**
	* Email服务
	* @var IEmailService
	*/
	private static $emailService;
	
	/**
	 * @return IConfigService
	 */
	public static function getConfigService(){
		if(self::$configService == null){
			self::$configService = new ConfigService();
		}
		return self::$configService;
	}
	
	/**
	 * @return IRegionService
	 */
	public static function getRegionService(){
		if(self::$regionService == null){
			self::$regionService = new RegionService();
		}
		return self::$regionService;
	}
	
	/**
	 * @return IEmailService
	 */
	public static function getEmailService(){
		if(self::$emailService == null){
			self::$emailService = new EmailService();
		}
		return self::$emailService;
	}
}

?>