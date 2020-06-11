<?php

$chunks = array();

/*$chunk_name = PKG_NAME_LOWER;
$content = getSnippetContent($sources['chunks'] . $chunk_name . '.chunk.tpl');
if(!empty($content)){
  $chunk = $modx->newObject('modChunk', array(
   'name'          => $chunk_name,
   'description'   => $chunk_name.'_desc',
   'snippet'       => $content,
  ));
  $chunks[] = $chunk;
}*/

$list = array(PKG_NAME_LOWER);

foreach($list as $v){

  $chunk_name = $v;
  $content = getSnippetContent($sources['chunks'] . $chunk_name . '.chunk.tpl');
  if(!empty($content)){
    $chunk = $modx->newObject('modChunk', array(
     'name'          => $chunk_name,
     'description'   => $chunk_name.'_desc',
     'snippet'       => $content,
    ));
    $chunks[] = $chunk;
  }
  
}

unset($chunk,$chunk_name,$content);
return $chunks;