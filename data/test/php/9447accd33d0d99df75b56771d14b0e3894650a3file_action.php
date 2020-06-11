<?php

    if (defined('LOADED') == false)
        exit;

    define('FILE_ACTION_RENAME_MULTI', 'rename_multi');
    define('FILE_ACTION_COPY_MULTI',   'copy_multi');
    define('FILE_ACTION_DELETE_MULTI', 'delete_multi');
    define('FILE_ACTION_ZIP_MULTI',    'zip_multi');
    define('FILE_ACTION_CHMOD_MULTI',  'chmod_multi');

    define('FILE_ACTION_COPY_MULTI_MODE_COPY', 1);
    define('FILE_ACTION_COPY_MULTI_MODE_MOVE', 2);

    define('FILE_ACTION_COPY_MULTI_EXISTS_FUNC_OVERRIDE', 1);
    define('FILE_ACTION_COPY_MULTI_EXISTS_FUNC_SKIP',     2);
    define('FILE_ACTION_COPY_MULTI_EXISTS_FUNC_RENAME',   3);

?>