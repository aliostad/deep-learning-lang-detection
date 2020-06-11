<?php
// Do not store anything in this file that is not part of the array or the hook version.  This file will	
// be automatically rebuilt in the future. 
 $hook_version = 1; 
$hook_array = Array(); 
// position, file, function 
$hook_array['before_save'] = Array(); 
$hook_array['before_save'][] = Array(99, 'save_multiple_tags', 'modules/Tags/workflow.php','Tags_before_save', 'Tags_before_save'); 
$hook_array['after_save'] = Array(); 
$hook_array['after_save'][] = Array(99, 'save_tags', 'modules/Tags/workflow.php','Tags_after_save', 'Tags_after_save'); 
$hook_array['before_retrieve'] = Array(); 
$hook_array['before_retrieve'][] = Array(99, 'retrieve_tags', 'modules/Tags/workflow.php','Tags_before_retrieve', 'Tags_before_retrieve'); 



?>