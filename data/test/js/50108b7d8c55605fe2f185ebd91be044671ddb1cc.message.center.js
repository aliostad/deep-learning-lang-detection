/**
* @author l_wang王磊 <l_wang@Ctrip.com>
* @namespace Common.cMessageCenter
* @description 消息广播机制
*/
define([], function () {
  var messageQueue = {};
  var MessageCenter = {
    /**
     * 发布消息
     * @method Common.cMessageCenter.publish
     * @param {string} message 消息标示
     * @param {array} args 参数
     */
    publish: function(message, args)
    {
      if (messageQueue[message])
      {
        _.each(messageQueue[message], function(item){
          item.handler.apply(item.scope?item.scope: window, args);  
        });
      }  
    },

    /**
     * 订阅消息
     * @method Common.cMessageCenter.subscribe
     * @param {string} message 消息标示
     * @param {function} handler 消息处理
     * @param {object} [scope] 函数作用域
     */
    subscribe: function(message, handler, scope)
    {
      if (!messageQueue[message]) messageQueue[message] = [];
      messageQueue[message].push({scope: scope, handler: handler});
    },

    /**
     * 取消订阅
     * @method Common.cMessageCenter.unsubscribe
     * @param {string} message 消息标示
     * @param {function} handler 消息处理函数句柄
     */
    unsubscribe: function(message, handler)
    {
      if (messageQueue[message]) {
        if (handler) {
          messageQueue[message] = _.reject(messageQueue[message], function(item){ return item.handler ==  handler});
        } else {
          delete messageQueue[message];
        }
      }
    }
  }
  return MessageCenter;
});