<!-- API使用说明 -->
<pre style="color: green; border: 1px solid blue; left: 500px; top: 60px; position: absolute; padding: 20px; background-color: #eeeeee;">
<b style="color: red;">Xweibo API 使用说明: </b>

	$http = APP::ADP('http');
	//$http->verbose = true;

	//用于防止　APP_KEY  APP_SKEY　泄密　时保证接口安全的加密　KEY　默认为空
	$api_key	= '';
	$app_key	= '2523327590';
	$app_skey	= '01bd1b333c3514c99c3da75e3262fff1';


	//请求时间
	$api_time	= time();
	//要调用的API
	$api		= 'update';
	//API　URL
	$apiUrl		= 'http://demo.xweibo.cn/index.php?m=api/weibo/action.'.$api;
	//API　以某个用户的身份访问接口，UID　为本站UID(非SINA_UID)，只有绑定后才可调用
	$api_uid	= 10000 ;

	//请求签名算法
	$api_sign = md5($app_key.'#'.$api_uid.'#'.$api_time.'#'.$app_skey.'#'.$api.'#'.$api_key);

	//常规参数
	$params['api_time']	= $api_time;
	$params['api_sign']	= $api_sign;
	$params['api_uid']	= $api_uid;
	$params['api_time']	= $api_time;

	//接口参数(特定接口的参数，见主站：XweiboAPI.rar　文档)
	$params['text'] 	= '测试Xweibo API 演示数据:'.date("Y-m-d H:i:s");

	//发送API请求
	$result = $http->setUrl($apiUrl)->setData($params)->request('post');
	
</pre>
