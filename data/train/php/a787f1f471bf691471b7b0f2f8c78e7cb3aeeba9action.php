<?php
/* 
 * アプリケーションの設定ファイル
 *アクション関連設定
 */
return  array (

/*  キャッシュ関連     */
'CACHE_ENABLE'=>CACHE_ENABLE,
'CACHE_ENGINE_CLASS'=>FRAMEWORK_DIR.'.cache.ApcCache',

//'REPOSITORY_OBJECTS'=>'classes.repository.ProductRepository,classes.repository.Setting,classes.repository.AdcodeRepository',
'REPOSITORY_OBJECTS'=>'classes.repository.ProductRepository',

/*  広告からきた場合の固定文字     */
'ADCODE'=>'adcode,a,ar',
/*  友達からきた場合の固定文字     */
'FRIEND_CODE'=>'f'
    
    
    
);

?>
