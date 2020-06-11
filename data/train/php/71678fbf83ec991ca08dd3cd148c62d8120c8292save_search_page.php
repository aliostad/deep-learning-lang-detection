<?php $_SESSION['direct_to'] = BASE_URL."save_search/"; 	
	 include_once('sessioninc.php');
	 
	$username = $session->get_username();
	$employee_id = $user_id = $session->get_user_id();

if( isset($_GET['action']) ) {
	//save the search query into database
	if( $_GET['action'] == "save" && isset($_GET['reference'])) {
		$reference = $_GET['reference'];
		$reference_name = $_GET['name'];
				
		if( !SaveSearch::already_existed( $employee_id, $reference) ){			
			$save_search = new SaveSearch();
			$save_search->fk_employee_id	= $employee_id;
			$save_search->reference_name	= $reference_name;
			$save_search->reference 		= $reference;
			
			if( $save_search->save() ) {
				$message = "<div class='success'>".format_lang('success','save_search')."</div>";
			}else{
				$message = "<div class='error'>".format_lang('errormsg',62)."</div>";
			}
		}else{
			$message = "<div class='error'>".format_lang('errormsg',63)."</div>";
		}
	}
	
	elseif( $_GET['action'] == 'search' && isset($_REQUEST['search_id']) ){
		 $id = (int)$_REQUEST['search_id'];
		$found = SaveSearch::find_by_id( $id );
		if($found){
			redirect_to( BASE_URL. "search/?". urldecode(urldecode($found->reference)) );
			die;
		}
			redirect_to( BASE_URL. "save_search/");
			die;
	}
	
	/**deleting */
	elseif( $_GET['action'] == 'delete' && isset($_GET['search_id']) ){
		$id = (int)$_REQUEST['search_id'];	
		$save_search = new SaveSearch();
		$save_search->fk_employee_id = $employee_id;
		$save_search->id = $id;

		if( $save_search->delete_saveSearch()){
			$message = "<div class='success'>".format_lang('success','delete_success')."</div>";
		}else{
			$message = "<div class='error'>".format_lang('errormsg',64)."</div>";
		}		
	}
	else{
		redirect_to( BASE_URL. "save_search/");
		die;
	}
	$session->message ( $message );
	redirect_to(BASE_URL. "save_search/");
}
	$save_search_arr = SaveSearch::find_by_user_id( $user_id );
	if ( !empty( $save_search_arr ) ){
		$search = array();
		$i=1;
		foreach( $save_search_arr as $save_search ):
			$search[$i]['id'] = $save_search->id;
			$search[$i]['reference_name'] = $save_search->reference_name;
			$search[$i]['reference'] = urldecode( $save_search->reference );
			$search[$i]['is_deleted'] = $save_search->is_deleted;
			$search[$i]['created_at'] = strftime(DATE_FORMAT, strtotime($save_search->date_save) );
		  $i++;
		endforeach;
		$smarty->assign( 'save_search', $search );
	}
	
$html_title 		= SITE_NAME . " -  ".format_lang('page_title','save_search'). chr(10).strip_html($employee->full_name() );
$smarty->assign('lang', $lang);
$smarty->assign( 'message', $message );	
$smarty->assign('rendered_page', $smarty->fetch('save_search.tpl') );
?>