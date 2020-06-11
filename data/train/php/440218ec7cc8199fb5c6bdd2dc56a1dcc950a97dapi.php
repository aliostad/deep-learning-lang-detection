<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
$config['api_base_url']        = 'http://www.ledinside.cn/api';
$config['api_user_login']      = $config['api_base_url'].'/user/login';
$config['api_news_page']       = $config['api_base_url'].'/news/page';
$config['api_news_recommened'] = $config['api_base_url'].'/news/get_recommend';
$config['api_news_view']       = $config['api_base_url'].'/news/view';
$config['api_news_focus']      = $config['api_base_url'].'/news/get_focus';