import * as ApiUtil from '../utils/user_util';

export const RECEIVE_USER = 'RECEIVE_USER';
export const RECEIVE_ERRORS = 'RECEIVE_ERRORS';

export const receiveUser = (user) => ({
  type: RECEIVE_USER,
  user
});

export const receiveErrors = (errors) => ({
  type: RECEIVE_ERRORS,
  errors
});

export const createUser = (user) => dispatch => (
  ApiUtil.createUser(user).then( user => dispatch(receiveUser(user)),
    errors => dispatch(receiveErrors(errors))
  )
);

export const fetchUser = (user) => dispatch => (
  ApiUtil.fetchUser(user).then( user => dispatch(receiveUser(user)),
    errors => dispatch(receiveErrors(errors))
  )
);

export const createSession = (user) => dispatch => (
  ApiUtil.createSession(user).then( user => dispatch(receiveUser(user)),
    errors => dispatch(receiveErrors(errors))
  )
);
