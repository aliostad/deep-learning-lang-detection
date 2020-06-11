import * as APIUtil from '../util/session_api_util';
import { receiveErrors } from './error_actions';

export const RECEIVE_CURRENT_USER = "RECEIVE_CURRENT_USER";

export const receiveCurrentUser = currentUser => {
  return {
    type: RECEIVE_CURRENT_USER,
    currentUser
  };
};

export function signup(user) {
  return (dispatch) => {
    return APIUtil.signup(user).then(
      (currentUser) => dispatch(receiveCurrentUser(currentUser)),
      (err) => dispatch(receiveErrors(err))
    );
  };
}

export function logout() {
  return (dispatch) => {
    return APIUtil.logout().then(
      (currentUser) => dispatch(receiveCurrentUser(null)),
      (err) => dispatch(receiveErrors(err))
    );
  };
}

export function login(user) {
  return (dispatch) => {
    return APIUtil.login(user).then(
      (currentUser) => dispatch(receiveCurrentUser(currentUser)),
      (err) => dispatch(receiveErrors(err))
    );
  };
}
