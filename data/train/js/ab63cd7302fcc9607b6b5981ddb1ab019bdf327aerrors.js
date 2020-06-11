var Errors = {
  GENERAL_ERROR: function (message) {
    return{code: 0, message: message || '一般错误'}
  },
  NOT_LOGIN: function (message) {
    return{code: 1001, message: message || '未登录'}
  },
  WRONG_PASSWORD: function (message) {
    return{code: 1002, message: message || '密码错误'}
  },
  NOT_FOUND: function (message) {
    return{code: 1004, message: message || '没有找到'}
  },
  DUPLICATED: function (message) {
    return{code: 1005, message: message || '重复的'}
  },
  PARAMETER_REQUIRED: function (message) {
    return {code: 1007, message: message || '缺少参数'};
  },
  NOT_AUTHORIZED: function (message) {
    return {code: 1008, message: message || '没有权限'};
  }
};


module.exports = Errors;
