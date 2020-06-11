const makeAction = function(type) {
  return ({ dispatch }, ...args) => dispatch(type, ...args);
};
//消息框保持滚动在底部
const keepBottom = () => {
  setTimeout(function () {
    document.getElementById("msg-board").scrollTop = 999999999;
  }, 300)
};

//加入聊天室错误
export const setError = ({ dispatch },msg) => {
  dispatch('SET_ERROR', msg);
};

//设置个人信息
export const setSelf =  ({ dispatch },data) => {
    dispatch('SET_SELF', data);
};

//更新群聊成员信息
export const setMembers = makeAction('SET_MEMBERS');

//接受通知
export const getInform =  ({ dispatch },msg) => {
  dispatch('GET_INFORM', msg);
  keepBottom();
};

//接收消息
export const getMsg = function ({ dispatch }, data) {
  dispatch('GET_MSG',data);
  keepBottom();
};
