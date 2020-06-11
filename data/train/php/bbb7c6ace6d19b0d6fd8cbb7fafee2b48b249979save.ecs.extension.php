<?php
if (XT::getValue("livetpl") == 1){
	$GLOBALS['plugin']->contribute("editcontents_buttons", "Save", "saveContentSimple","disk_blue.png","0","");
	$GLOBALS['plugin']->contribute("editcontents_buttons", "Save and exit", "saveAndExitContentSimple","disk_blue.png","0","","","","opener.document.location.href=opener.document.location.href;window.close();");
}else {
	$GLOBALS['plugin']->contribute("editcontents_buttons", "Save", "saveContentSimple","disk_blue.png","0","");
	$GLOBALS['plugin']->contribute("editcontents_buttons", "Save and exit", "saveAndExitContentSimple","disk_blue.png","0","");
}
?>
