'use strict';
var API = require('./lib/api_common');
// 商品接口
API.mixin(require('./lib/api_item'));
// 类目接口
API.mixin(require('./lib/api_category'));
// 物流接口
API.mixin(require('./lib/api_logistics'));
// 交易接口
API.mixin(require('./lib/api_trade'));
// 客户接口
API.mixin(require('./lib/api_user'));

// var youzanAPI = null;

// //确保只有一个instance
// var createAPI = function(proxy, appid, appsecret, format, version, signMethod) {
//   if(youzanAPI === null){
//     youzanAPI = new API(proxy, appid, appsecret, format, version, signMethod);
//   }
//   return youzanAPI;
// };

module.exports = API;