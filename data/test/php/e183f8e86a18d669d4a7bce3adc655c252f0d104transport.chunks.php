<?php
/**
 * Add chunks to build
 * 
 * @package cybershop-site
 * @subpackage build
 */
$chunks = array();

$chunks_dir = $sources['data'].'/chunks/';
$chunk_ext = '.chunk.tpl';
$files_array = scandir($chunks_dir);

foreach ($files_array as $file_name) {
    if (!(strpos($file_name, $chunk_ext) === false)) {
        $chunk_file = $chunks_dir.$file_name;
        $chunk_name = substr($file_name, 0, strpos($file_name, $chunk_ext));
        $chunk = $modx->newObject('modChunk');
        $chunk->fromArray(array(
	'id' => 0,
	'name' => $chunk_name,
	'description' => '',
	'snippet' => file_get_contents($chunk_file),
        ),'',true,true);
        $chunks[] = $chunk;
    }
}

return $chunks;