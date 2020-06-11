<?php
namespace Weixin\Log;
class ResponseLog {

	public static function wxReceiveLog( $ecid, $wechatMsg ) {
		$m = M( "Company_".$ecid."_wx_log" );
		$saveArr['time'] = date('Y-m-d H:i:s');
		$saveArr['FromUserName'] = $wechatMsg['FromUserName'];
		$saveArr['MsgType'] = $wechatMsg['MsgType'];
		$saveArr['Content'] = $wechatMsg['Content'];
		$saveArr['Event'] = $wechatMsg['Event'];
		$saveArr['EventKey'] = $wechatMsg['EventKey'];
		$saveArr['PicUrl'] = $wechatMsg['PicUrl'];
		$m->add($saveArr);
	}
}
?>
