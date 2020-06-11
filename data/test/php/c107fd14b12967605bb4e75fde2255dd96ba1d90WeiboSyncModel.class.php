<?php

class WeiboSyncModel extends Model {

    var $tableName = 'weibo';


    //发布微博
    function doSaveWeibo($uid, $content, $from_data = null, $from = 11, $type = 0, $type_data = null) {
        /* if(!$data['content']){
          return false;
          } */

        if (!function_exists('getContentUrl'))
            require_once SITE_PATH . '/apps/weibo/Common/common.php';
        $save['content'] = $content;
        $save['uid'] = $uid;
        $save['transpond_id'] = 0;
        $save['from'] = intval($from);  //11新浪微博
        $save['transpond'] = 0;
        $save['isdel'] = 0;
        $save['comment'] = 0;
        $save['ctime'] = time();
        $save['from_data'] = $from_data;
        $save['type'] = $type;
        if($type_data){
            $save['type_data'] = serialize($type_data);
        }
        // 微博内容处理
        /*
        if (Addons::requireHooks('weibo_publish_content')) {
            Addons::hook("weibo_publish_content", array(&$save));
        } else {
            $save['content'] = preg_replace('/^\s+|\s+$/i', '', html_entity_decode($data['content'], ENT_QUOTES));
            $save['content'] = preg_replace("/#[\s]*([^#^\s][^#]*[^#^\s])[\s]*#/is", '#' . trim("\${1}") . '#', $save['content']); // 滤掉话题两端的空白
            $save['content'] = preg_replace_callback('/((?:https?|ftp):\/\/(?:www\.)?(?:[a-zA-Z0-9][a-zA-Z0-9\-]*\.)?[a-zA-Z0-9][a-zA-Z0-9\-]*(?:\.[a-zA-Z0-9]+)+(?:\:[0-9]*)?(?:\/[^\x{4e00}-\x{9fa5}\s<\'\"“”‘’]*)?)/u', getContentUrl, $save['content']);
            $save['content'] = t(getShort($save['content'], $GLOBALS['ts']['site']['length']));
        }
         */

        //写入数据库
        if ($id = $this->add($save)) {
            $save['weibo_id'] = $id;
            $this->_setWeiboCache($id, $save);

            $weiboInfoWithLink['type'] = $save['type'];
            $weiboInfoWithLink['transpond_id'] = $save['transpond_id'];
            D('Topic', 'weibo')->addTopic(html_entity_decode($save['content'], ENT_QUOTES), $id, $weiboInfoWithLink);
            return $id;
        } else {
            return false;
        }
    }

    public function _setWeiboCache($id,$data){
        object_cache_set("weibo_".$id,$data);
        return F('weibo_detail_'.$id,$data);
    }
}
