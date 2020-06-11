<?php
$spark_config = array(
'charset' => 'utf-8',
'user_id' => '',
'key' => '',
'api_videos' => 'http://spark.bokecc.com/api/videos',
'api_user' => 'http://spark.bokecc.com/api/user',
'api_playcode' => 'http://spark.bokecc.com/api/video/playcode',
'api_deletevideo' => 'http://spark.bokecc.com/api/video/delete',
'api_editvideo' => 'http://spark.bokecc.com/api/video/update',
'api_video' => 'http://spark.bokecc.com/api/video',
'api_category' => 'http://spark.bokecc.com/api/video/category',
);
$spark_config['notify_url'] = 'http://' . $_SERVER['HTTP_HOST'] . dirname($_SERVER["REQUEST_URI"]) . '/notify.php';
