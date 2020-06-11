<?
	session_start();
	require_once('config.php');
	require_once('saveAdapter.class');
	global $_SESSION;
	$content= addslashes(mswordReplaceSpecialChars(stripslashes($_REQUEST['content'])));
	saveAdapter::writeXmlHeader($_REQUEST['action'], true);
	//User id here shold be the admin id of user logged in

	$user_id=$_SESSION['AID'];
	// trigger the appropriate command
	switch ($_REQUEST['action'])
	{
		case 'save' 	: saveAdapter::saveToDatabase($content) ;
		case 'draft'	: saveAdapter::saveToDatabase($content, true,$user_id);
	}

	saveAdapter::writeXmlFooter() ;

?>