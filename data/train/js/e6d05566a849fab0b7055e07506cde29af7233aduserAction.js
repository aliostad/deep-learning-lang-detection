import { LOGIN, REGISTE, GET_USER_BY_JWT } from '../types';

export const getUserByJWT = jwt => dispatch => {
  if(!jwt) dispatch({type: GET_USER_BY_JWT, username: '', isSuccess: false})
  else dispatch({
    type: GET_USER_BY_JWT,
    username: 'see',
    isSuccess: true
  });
};

export const login = (username, password) => dispatch => {
  dispatch({
    type: LOGIN,
    username,
    isSuccess: true
  });
};

export const registe = (username, email, password) => dispatch => {
  dispatch({
    type: REGISTE,
    username,
    email,
    isSuccess: true
  });
};
