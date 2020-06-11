<?php
/**
* @package Admin-User-Access (com_pi_admin_user_access)
* @version 2.3.1
* @copyright Copyright (C) 2007-2011 Carsten Engel. All rights reserved.
* @license GPL available versions: free, trial and pro
* @author http://www.pages-and-items.com
* @joomla Joomla is Free Software
*/


//no direct access
if(!defined('_VALID_MOS') && !defined('_JEXEC')){
	die('Restricted access');
}

//get task
if( defined('_JEXEC') ){
	//joomla 1.5
	JRequest::getVar('params', 'task');
}else{
	//joomla 1.0.x
	$task = mosGetParam( $_REQUEST, 'task', '' );
}

//display menubar
if( defined('_JEXEC') ){
	//joomla 1.5
	if($task=='usergroups'){
		JToolBarHelper::addNewX('usergroup',_pi_ua_lang_new);
		JToolBarHelper::trash( 'usergroup_delete', _pi_ua_lang_delete, '', '', $listSelect = true );
	}
	
	if($task=='usergroup'){
		JToolBarHelper::save( 'usergroup_save', _pi_ua_lang_save );
		JToolBarHelper::cancel( 'usergroups', _pi_ua_lang_cancel );
	}
	
	if($task=='users'){
		JToolBarHelper::save('users_save', _pi_ua_lang_save);
	}
	
	if($task=='access_pages'){
		JToolBarHelper::save( 'access_pages_save', _pi_ua_lang_save );
	}
	
	if($task=='access_itemtypes'){
		JToolBarHelper::save( 'access_itemtypes_save', _pi_ua_lang_save );
	}
	
	if($task=='items'){
		JToolBarHelper::save( 'access_items_save', _pi_ua_lang_save );
	}
	
	if($task=='sections'){
		JToolBarHelper::save( 'access_sections_save', _pi_ua_lang_save );
	}
	
	if($task=='categories'){
		JToolBarHelper::save( 'access_categories_save', _pi_ua_lang_save );
	}
	
	if($task=='access_components'){
		JToolBarHelper::save( 'access_components_save', _pi_ua_lang_save );
	}
	
	if($task=='actions'){
		JToolBarHelper::save( 'actions_save', _pi_ua_lang_save );
	}
	
	if($task=='modules'){
		JToolBarHelper::save( 'modules_save', _pi_ua_lang_save );
	}
	
	if($task=='plugins'){
		JToolBarHelper::save( 'plugins_save', _pi_ua_lang_save );
	}
	
	if($task=='toolbars'){
		JToolBarHelper::save( 'toolbars_save', _pi_ua_lang_save );
	}
	
	if($task=='config'){
		JToolBarHelper::save( 'config_save', _pi_ua_lang_save );
		JToolBarHelper::apply( 'config_apply', _pi_ua_lang_apply );
		JToolBarHelper::cancel( 'cancel', _pi_ua_lang_cancel );
	}	
	
}else{
	//joomla 1.0.x
	mosMenuBar::startTable();

	if($task=='usergroups'){
		mosMenuBar::addNew('usergroup',_pi_ua_lang_new);
		mosMenuBar::spacer();
		mosMenuBar::trash( 'usergroup_delete', _pi_ua_lang_delete, '', '', $listSelect = true );
		mosMenuBar::spacer();	
	}
	
	if($task=='usergroup'){
		mosMenuBar::save( 'usergroup_save', _pi_ua_lang_save );
		mosMenuBar::spacer();
		mosMenuBar::cancel( 'usergroups', _pi_ua_lang_cancel );
		mosMenuBar::spacer();	
	}
	
	if($task=='users'){
		mosMenuBar::save('users_save', _pi_ua_lang_save);
		mosMenuBar::spacer();
	}
	
	if($task=='access_pages'){
		mosMenuBar::save( 'access_pages_save', _pi_ua_lang_save );
		mosMenuBar::spacer();		
	}
	
	if($task=='access_itemtypes'){
		mosMenuBar::save( 'access_itemtypes_save', _pi_ua_lang_save );
		mosMenuBar::spacer();		
	}
	
	if($task=='items'){
		mosMenuBar::save( 'access_items_save', _pi_ua_lang_save );
		mosMenuBar::spacer();		
	}
	
	if($task=='sections'){
		mosMenuBar::save( 'access_sections_save', _pi_ua_lang_save );
		mosMenuBar::spacer();		
	}
	
	if($task=='categories'){
		mosMenuBar::save( 'access_categories_save', _pi_ua_lang_save );
		mosMenuBar::spacer();		
	}
	
	if($task=='access_components'){
		mosMenuBar::save( 'access_components_save', _pi_ua_lang_save );
		mosMenuBar::spacer();		
	}
	
	if($task=='actions'){
		mosMenuBar::save( 'actions_save', _pi_ua_lang_save );
		mosMenuBar::spacer();		
	}
	
	if($task=='modules'){
		mosMenuBar::save( 'modules_save', _pi_ua_lang_save );
		mosMenuBar::spacer();		
	}
	
	if($task=='plugins'){
		mosMenuBar::save( 'plugins_save', _pi_ua_lang_save );
		mosMenuBar::spacer();		
	}
	
	if($task=='toolbars'){
		mosMenuBar::save( 'toolbars_save', _pi_ua_lang_save );
		mosMenuBar::spacer();		
	}
	
	if($task=='config'){
		mosMenuBar::save( 'config_save', _pi_ua_lang_save );
		mosMenuBar::spacer();
		mosMenuBar::apply( 'config_apply', _pi_ua_lang_apply );
		mosMenuBar::spacer();
		mosMenuBar::cancel( 'cancel', _pi_ua_lang_cancel );
		mosMenuBar::spacer();	
	}	
	
	mosMenuBar::endTable();
}


?>