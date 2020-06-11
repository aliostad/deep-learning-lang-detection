import { routeActions } from 'redux-simple-router';
import authService from 'services/auth';

function success(tokens) {
  return dispatch => {
    dispatch({ type: 'AUTH_SUCCESS', tokens });
  };
}

export function requestAuthorization(username, password) {
  return dispatch => {
    dispatch({ type: 'AUTH_REQUEST' });
    return authService
      .authorize(username, password)
      .then(tokens => dispatch(success(tokens)))
      .catch(() => dispatch({ type: 'AUTH_FAIL' }));
  };
}

export function logout() {
  return dispatch => {
    dispatch({ type: 'AUTH_LOGOUT' });
    authService.logout();
    dispatch(routeActions.replace('/login'));
  };
}

export function checkStorage() {
  return dispatch => {
    const tokens = authService.checkStorageInitially();
    dispatch({ type: 'auth/init' });
    if (tokens) {
      dispatch(success(tokens));
    } else {
      dispatch(logout());
    }
  };
}
