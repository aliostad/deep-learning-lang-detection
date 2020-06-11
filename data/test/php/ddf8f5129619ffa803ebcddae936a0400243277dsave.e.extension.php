<?php

$GLOBALS['plugin']->contribute("edit_buttons", "Save", "saveArticle","disk_blue.png","0");
if(XT::getValue('liveedit')!=true){
$GLOBALS['plugin']->contribute("edit_buttons", "Save and preview", "saveArticleAndPreview","save_view.png","0");
}
$GLOBALS['plugin']->contribute("edit_buttons", "Save and close", "saveArticleAndClose","save_close.png","0");

$GLOBALS['plugin']->contribute("edit2_buttons", "Cancel", "close","delete.png","0");
$GLOBALS['plugin']->contribute("edit2_buttons", "Save and publis[h]", "saveArticleAndPublish","check.png","0","","h");
?>
