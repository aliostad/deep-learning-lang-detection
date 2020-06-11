/**
 * Created by zhengan on 2017/4/14.
 */
(function(){
    "use strict";

    angular.module('app.dingDing.service',[])
        .factory('dingDingService',['DingService','AuthorityRestangular',dingDingService])
    ;

    function dingDingService(DingService,AuthorityRestangular){
        return {
            getAllService:DingService.all('api/service/getAllService'),//获取服务数据
            updateStatus:DingService.all('api/service/updateStatus'),//修改服务权限
            getToken:DingService.one('api/service/getToken'),//获取sevice在dingding上注册的token
            sendMessage:DingService.all('api/dingtalk/sendMessage')//发送dingding消息
        }
    }
})();
