// action 会收到 store 作为它的第一个参数
// 既然我们只对事件的分发（dispatch 对象）感兴趣。（state 也可以作为可选项放入）
// 我们可以利用 ES6 的解构（destructuring）功能来简化对参数的导入

import * as types from './mutation-types'
// import gloabl from '../../../api/globConfig'
/**
 * 打开右侧开关
 */
// export const switchRight = ({
//     dispatch
//   }, type, id, parent) => {
//     $('.CONTENT_HEADERT_RIGHT a').removeClass('tab_active');
//     $('.icon_' + type).addClass('tab_active');
//     dispatch(types.SWITCH_RIGHT, type, id, parent)
//     console.log(222);
//     gloabl.golableTab();
//   }
/**
 * 改变当前联系人
 */
//export const changeHeadName = ({
//	dispatch
//}, threads) => {
//	dispatch(types.CHANGE_HEADER_NAME, threads)
//
//}
export const getDepartmentPerson = ({
  dispatch
}, list) => {
  dispatch(types.DEPART_LIST_PERSON, list);

}
export const chooseAllPerson = ({
    dispatch
  }, list) => {
    list = list ? list : [];
    dispatch(types.CHOOSE_ALL_PERSON, list);

  }
  //频组信息
export const showGroupList = ({
    dispatch
  }, list) => {
    list = list ? list : [];
    dispatch(types.SHOW_GROUP_ICON, list);

  }
  //发送消息
export const sendNowMessage = ({
  dispatch
}, list) => {

  dispatch(types.SEND_MESSAGE, list);

}

//export const manageListData = ({
//	dispatch
//}, orgSid) => {
//	console.log(orgSid);
//	dispatch(types.MANAGE_LIST, orgSid);
//
//}
