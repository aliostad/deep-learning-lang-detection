<?php

require_once 'simple_php_cache.php';

$cache = new simple_php_cache('cache/' );

$cache_data = array('string'=>'This string will be cached');

define('START_TIME', microtime(true));
define('START_MEMORY_USAGE', memory_get_usage());

for ($i=0; $i<100; $i++) {

    $cache->save($cache_data, 'save_filename');
    $cache->save($cache_data, 'save_filename1');
    $cache->save($cache_data, 'save_filename2');
    $cache->save($cache_data, 'save_filename3');
    $cache->save($cache_data, 'save_filename4');
    $cache->save($cache_data, 'save_filename5');
    $cache->save($cache_data, 'save_filename6');
    $cache->save($cache_data, 'save_filename7');
    $cache->save($cache_data, 'save_filename8');
    $cache->save($cache_data, 'save_filename9');

}

//$cache->remove('save_filename');

//$cache->clear();


$time = round((microtime(true) - START_TIME), 5);
$persecond = 1/$time;

?>
<div style="background:#F4FFEA;margin-top:60px;padding:15px">
<p>Page rendered in <?php print $time ?> seconds | <?php print $persecond ?> per second
taking <?php print round((memory_get_usage() - START_MEMORY_USAGE) / 1024, 2); ?> KB
(<?php print (memory_get_usage() - START_MEMORY_USAGE); ?> Bytes).</p>
</div>