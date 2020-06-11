<?php

/**
 * 资讯模块服务加载器
 * @author blueyb.java@gmail.com
 */
class NewsServiceFactory{
	
	/**
	 * 资讯分类服务接口
	 * @var INewsCategoryService
	 */
	private static $newsCategoryService;
	

	/**
	 * 资讯服务接口
	 * @var INewsService
	 */
	private static $newsService;
	
	/**
	 * @return INewsCategoryService
	 */
	public static function getNewsCategoryService(){
		if(self::$newsCategoryService == null){
			self::$newsCategoryService = new NewsCategoryService();
		}
		return self::$newsCategoryService;
	}
	

	/**
	 * @return INewsService
	 */
	public static function getNewsService(){
		if(self::$newsService == null){
			self::$newsService = new NewsService();
		}
		return self::$newsService;
	}
}

?>