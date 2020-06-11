import AuthService from '../utils/AuthService'

export function loginUser() {
  return function (dispatch) {
    dispatch({ type: "LOGIN_REQUEST" });
    const auth = new AuthService(process.env.CLIENT_ID, process.env.DOMAIN);
    
    auth.login();
  }
}

export function checkLogin() {
  return function (dispatch) {
    if (AuthService.loggedIn()) {
      dispatch({ type: "LOGIN_SUCCESS", payload: "Ok" });
    } else {
      dispatch({ type: "LOGIN_FAILURE", payload: "No token" });
    }
  }
}

export function logoutUser() {
  return function (dispatch) {
    AuthService.logout();
    dispatch({ type: "LOGOUT_SUCCESS" });
  }
}
