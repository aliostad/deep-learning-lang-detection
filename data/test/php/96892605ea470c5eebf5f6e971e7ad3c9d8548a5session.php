<?php
// =============================================================================
// SESSION
// =============================================================================

// 使用memcache存放session数据。
if(SESSION_SAVE_HANDLER == 'memcache'  && session_module_name( ) != "memcache"){
    session_module_name( SESSION_SAVE_HANDLER );
    session_save_path( SESSION_SAVE_PATH );    
}else if(SESSION_SAVE_HANDLER == 'user'  && session_module_name( ) != "user"){
    // TODO 实现user存储方式。
}else if(SESSION_SAVE_HANDLER == 'file'  && session_module_name( ) != "file"){
    // TODO 实现file存储方式。只需设置seesion_module_name("file");,但目前暂不提供。
}
session_start();



