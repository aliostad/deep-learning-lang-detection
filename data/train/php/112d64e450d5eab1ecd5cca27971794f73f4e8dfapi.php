<?php
return  array(
    /* 开发相关配置 */
    'API_DEV_MODE'              => false,   // 是否在开发模式下。如果是则不做签名验证和重攻击验证，并开启assert检测，输出结果自动美化。

    /* 请求相关配置 */
    'API_REQUEST_PARAM_REPLACE' =>  null,   // API公共请求参数名替换，示例：array('api_action' => 'a')

    /* 日志相关配置 */
    'API_LOG_ENABLED'           =>  true,  // 是否启用API日志。
    'API_LOG_CONNECTION'        =>  null,   // API日志数据库连接配置。
    'API_LOG_TABLENAME'         =>  'api_logs', // API基础日志表名。
    'API_LOG_DETAIL_ENABLED'    =>  true,   // 是否记录详细日志。
    'API_LOG_DETAIL_TABLENAME'  =>  'api_log_details',  // API详细日志表名。
    'API_LOGEX_MAP'             =>  null,   // API日志扩展配置，格式如：array('field1' => 'Col1', 'field2' => 'Col2')
    'API_LOG_GEO_ENABLED'       =>  true,   //是否分析API请求者的地理位置。
    'API_LOG_GEO_LIBPATH'       =>  'qqwry.dat',    // IP地址库文件路径。默认放置在与Org\Net\IpLocation类文件同一目录。

    /* 扩展标签配置 */
    'API_REQUEST_INIT_TAG'      =>  'api_request_init', // API请求开始行为标签。
    'API_LOG_INIT_TAG'          =>  'api_log_init', // API日志记录初始化行为标签。

    /* API签名相关配置 */
    'API_SIGN_ENABLED'          =>  false,  // 是否启用签名验证。
    'API_SIGN_APPID_ENABLED'    =>  false,  // 是否验证参数中的应用ID。值为false时表示不验证应用ID。
    'API_SIGN_KEY'              =>  null,   // API签名使用的密钥。
    'API_SIGN_EXPIRETIME'       =>  3600,   // API签名过期时间，单位为秒。
    'API_SIGN_CONNECTION'       =>  null,   // API签名信息数据库连接配置。
    'API_SIGN_TABLENAME'        =>  'api_apps', // API签名信息表名。

    /* 网络重攻击防御相关配置 */
    'API_SIGN_NONCE_ENABLED'    =>  false,      // 是否启用防御网络重攻击机制.
    'API_SIGN_NONCE_STORAGE'    =>  'mysql',    // 随机串存储引擎，支持memcache和mysql。
    'API_SIGN_NONCE_MEMCACHE'   =>  array('host'=>'127.0.0.1', 'port'=>'11211', 'persistent'=>false),    // memcache连接信息。
    'API_SIGN_NONCE_KEYPREFIX'  =>  'api_sign_nonce_',  // 随机串存储键名前缀，存储引擎为memcache时有效。
    'API_SIGN_NONCE_CONNECTION' =>  null,   // 随机串存储mysql连接配置。
    'API_SIGN_NONCE_TABLENAME'  =>  'api_sign_nonces',  // 随机串存储表名，存储引擎为mysql时有效。
    'API_SIGN_NONCE_CLEARRATE'  =>  1000,   // 自动清理概率，存储引擎为mysql时有效。
    'API_SIGN_NONCE_EXPIRETIME' =>  3900,   // 随机串过期多久后进行自动清理nonce，单位为秒，需大于API_SIGN_EXPIRETIME的设置。

    /* Model相关配置 */
    'API_LIST_DEFAULT_OPTIONS'  =>  null,   // 列表操作默认选项
    'API_DETAIL_DEFAULT_OPTIONS'=>  null,   // 详情操作默认选项
    'API_DELETE_DEFAULT_OPTIONS'=>  null,   // 删除操作默认选项

    /* 多语言相关配置 */
    'API_LANG_PKG_ENABLED'      =>  true,  // 是否启用语言包，启用后将根据api_lang指定的语言输出错误消息。
    'API_LANG_AUTOGEN'          =>  true,  // 是否根据错误码自动生成错误消息，启用后将根据api_lang指定的语言自动生成错误消息。
    'API_LANG_LIST'             =>  'zh-cn,en-us',  // 允许的语言包列表，用逗号分隔。
    'API_DEFAULT_LANG'          =>  'zh-cn',    // 默认语言包。

    /* 接口映射配置 */
    'API_ACTION_MAP'            =>  array(
    ),
);
