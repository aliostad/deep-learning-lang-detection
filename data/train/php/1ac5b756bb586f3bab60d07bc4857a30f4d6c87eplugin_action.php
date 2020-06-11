<?php
/*
 * plugin_action.php     Zhuayi 插件库
 *
 * @copyright    (C) 2005 - 2010  zhuayi
 * @licenes      http://www.zhuayi.net
 * @lastmodify   2010-10-28
 * @author       zhuayi
 * @QQ			 2179942
 */                                                                                              
class plugin_action extends zhuayi
{

	/* 构造函数 */
	function __construct()
	{
		parent::__construct();
		$this->load_class('db');

	}

	function index()
	{
		$show['menu'] = 'plugin';

		$show['title'] = 'Zhuayi 插件库';

		$this->display($show);
	}

	function show($id)
	{
		$show['menu'] = 'plugin';
		
		$show['info'] = plugins_modle::plugins(array('name'=>$id));
		if (empty($show['info']['id']))
		{
			output::error('错误的来源地址!');
		}

		$show['info']['config'] = explode("\n",$show['info']['config']);

		$show['info']['name'] = 'plugins/'.$show['info']['name'].'/config/'.$show['info']['name'].'.config.php';

		$show['info']['fun'] = plugins_modle::fun_list(array('pid'=>$show['info']['id']),' id asc', ' 0 , 30');

		$show['title'] = $show['info']['title'];
		
		$this->display($show);
	}

	function right()
	{
		$show['plugin_list'] = plugins_modle::plugins(array(),' id asc ','0,100');

		require $this->load_tpl('plugin_right');
		
	}


}