<?php

/**
 * @author Revan
 */
class Kore_Api_Map extends CAC_App_Map  {
    
    protected $defaultCommand = 'CAC_API_Default_Command';
    
	protected $methods = array(
		
        'user'		=> array(	'API_User',
                                'tag'	=>	array(	'follow'	=> array('API_User_Tag'),
													'unfollow'	=> array('API_User_Tag') ),
								'mod'	=>	array(	'bio'		=> array('API_User_Mod'),
													'email'		=> array('API_User_Mod') ),
                                'auth'  =>  array(  'login'     => array('API_User_Auth_Login'),
                                                    'logout'    => array('API_User_Auth_Logout') ),
                                'new'   =>  array( 'API_User_New' )
							),
		
		'tag'		=> array(	'API_Tag',
                                'create'=>	array('API_Tag_Create'),
								'search'=>	array('API_Tag_Search')
							),
		
		'link'		=> array(	'API_Link',
                                'visit' =>  array( 'API_Link_Follow' ),
                                'action'=>	array(	'like'		=> 'API_Link_Action_Like',
													'upload'	=> 'API_Link_Action_Upload')
							),
		
	);
    
}

?>
