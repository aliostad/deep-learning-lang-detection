<?php
defined('_JEXEC') OR defined('_VALID_MOS') OR die('...Direct Access to this location is not allowed...');
### Copyright (C) 2006-2009 Acajoom Services. All rights reserved.
### http://www.ijoobi.com/index.php?option=com_content&view=article&id=12&Itemid=54

 class newsletter {

	function editmailing() {

		$show['sender_info'] = true;
		$show['published'] = true;
		$show['pub_date'] = true;
		$show['hide'] = true;
		$show['issuenb'] = true;
		$show['delay'] = false;
		$show['htmlcontent'] = true;
		$show['textcontent'] = true;
		$show['attachement'] = true;
		$show['images'] = true;
		$show['sitecontent'] = true;
		return $show;

	}


	function editlist() {
		$show['sender_info'] = true;
		$show['hide'] = true;
		$show['auto_option'] = false;
		$show['htmlmailing'] = true;
		$show['auto_subscribe'] = true;
		$show['email_unsubcribe'] = true;
		$show['unsusbcribe'] = true;
		return $show;

	}


	function showMailings() {

		$show['id'] = true;
		$show['dropdown'] = true;
		$show['select'] = true;
		$show['issue'] = true;
		$show['sentdate'] = true;
		$show['delay'] = false;
		$show['status'] = true;
		return $show;

	}


	function getQueue() {
		$query =  ' AND `published`= 2  ';
		$query .=  ' AND `type`= 1  ';
		return $query;
	}

	 function getActive() {

		$config['listype1'] = '1';
		$config['listname1'] = '_ACA_NEWSLETTER';
		$config['listnames1'] = '_ACA_MENU_NEWSLETTERS';
		$config['listshow1'] = '1';
		$config['listlogo1'] = 'inbox.png';
		$config['classes1'] ='newsletter';
		return $config;

	}
 }
