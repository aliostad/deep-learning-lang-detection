import request from 'superagent';
import * as types from '../const/actionTypes';
import * as notification from './notification';
const urlRoot = 'https://handshake-dashboard-api.herokuapp.com/';

export function getHelps(appId) {
  return dispatch => {
    dispatch({
      type : types.SET_IS_GETTING_HELPS
    });
    request
    .get(`${urlRoot}applications/${appId}/helps`)
    .set('Content-Type', 'application/json')
    .end((err, res) => {
      if (res.ok) {
        dispatch(getHelpsSuccess(JSON.parse(res.text)));
      } else {
        dispatch(getHelpsError());
      }
    });
  }
}

export function getHelpsSuccess(data) {
  return dispatch => {
    dispatch({
      type : types.GET_HELPS_SUCCESS,
      data : data
    });
  }; 
}

export function getHelpsError() {
  return dispatch => {
    dispatch({
      type : types.GET_HELPS_ERROR
    });
    dispatch(notification.set('error', 'ヘルプの取得に失敗しました。時間をおいてから再度お試しください。'));
  }; 
}

export function postHelp(appId, params) {
  return dispatch => {
    dispatch({
      type : types.SET_IS_POSTING_HELP
    });
    request
    .post(`${urlRoot}applications/${appId}/helps`)
    .send(params)
    .end((err, res) => {
      if (res.ok) {
        params.id = JSON.parse(res.text).help_id;
        dispatch(postHelpSuccess(params));
      } else {
        dispatch(postHelpError());
      }
    });
  }
}

export function postHelpSuccess(data) {
  return dispatch => {
    dispatch({
      type : types.POST_HELP_SUCCESS,
      data : data
    });
    dispatch(notification.set('success', 'ヘルプの作成に成功し、一覧に追加されました。'));
  }; 
}

export function postHelpError() {
  return dispatch => {
    dispatch({
      type : types.POST_HELP_ERROR
    });
    dispatch(notification.set('error', 'ヘルプの作成に失敗しました。時間をおいてから再度お試しください。'));
  }; 
}

export function putHelp(appId, helpId, params) {
  return dispatch => {
    dispatch({
      type : types.SET_IS_PUTTING_HELP
    });
    request
    .put(`${urlRoot}applications/${appId}/helps/${helpId}`)
    .send(params)
    .end((err, res) => {
      if (res.ok) {
        dispatch(putHelpSuccess(params, helpId));
      } else {
        dispatch(putHelpError());
      }
    });
  }
}

export function putHelpSuccess(data, helpId) {
  return dispatch => {
    dispatch({
      type   : types.PUT_HELP_SUCCESS,
      data   : data,
      helpId : helpId
    });
    dispatch(notification.set('success', 'ヘルプの編集に成功しました。'));
  }; 
}

export function putHelpError() {
  return dispatch => {
    dispatch({
      type : types.PUT_HELP_ERROR
    });
    dispatch(notification.set('error', 'ヘルプの編集に失敗しました。時間をおいてから再度お試しください。'));
  }; 
}

export function deleteHelp(appId, helpId) {
  return dispatch => {
    dispatch({
      type : types.SET_IS_DELETING_HELP
    });
    request
    .del(`${urlRoot}applications/${appId}/helps/${helpId}`)
    .end((err, res) => {
      if (res.ok) {
        dispatch(deleteHelpSuccess(helpId));
      } else {
        dispatch(deleteHelpError());
      }
    });
  }
}

export function deleteHelpSuccess(helpId) {
  return dispatch => {
    dispatch({
      type   : types.DELETE_HELP_SUCCESS,
      helpId : helpId
    });
    dispatch(notification.set('success', 'ヘルプの削除に成功しました。'));
  }; 
}

export function deleteHelpError() {
  return dispatch => {
    dispatch({
      type : types.DELETE_HELP_ERROR
    });
    dispatch(notification.set('error', 'ヘルプの削除に失敗しました。時間をおいてから再度お試しください。'));
  }; 
}

export function selectHelp(helpId) {
  return dispatch => {
    dispatch({
      type   : types.SELECT_HELP,
      helpId : helpId
    });
  }; 
}
