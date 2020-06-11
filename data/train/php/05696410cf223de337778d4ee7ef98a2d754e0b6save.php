<?php
	$save_what = $_REQUEST['save_what'];
	$date = date("mdY");
	
	if($save_what=="trailers"){
		$save_file = 'trailers/trailer'. $_REQUEST['file'].'.html';
		$save_content = stripslashes($_REQUEST['content']);
		
		echo 'File: <a href="/'. $save_file .'">Download '. $save_file .'</a><br />';
		echo "Content Saved<br />";
		
		file_put_contents($save_file, $save_content);	
	}else if($save_what=="newsletter"){
		$save_file = 'emails/nl_'.$date.'.html';
		$save_content = stripslashes($_REQUEST['content']);
		
		echo 'File: <a href="/'. $save_file .'">Download '. $save_file .'</a><br />';
		echo "Content Saved<br />";
		
		file_put_contents($save_file, $save_content);		
	}else if($save_what=="sa"){
		$save_file = 'emails/sa_'. $date.'.html';
		$save_content = stripslashes($_REQUEST['content']);
		
		echo 'File: <a href="/'. $save_file .'">Download '. $save_file .'</a><br />';
		echo "Content Saved<br />";
		
		file_put_contents($save_file, $save_content);		
	}else if($save_what=="sa_upsell"){
		$save_file = 'emails/sa_'. $date.'_upsell.html';
		$save_content = stripslashes($_REQUEST['content']);
		
		echo 'File: <a href="/'. $save_file .'">Download '. $save_file .'</a><br />';
		echo "Content Saved<br />";
		
		file_put_contents($save_file, $save_content);		
	}
?>