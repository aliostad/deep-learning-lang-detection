import { push } from 'react-router-redux';
import { addNotification } from '../services/notifications';

export const criticalErrorHandler = (dispatch) => {
  dispatch(addNotification('Some error has occured.'));
  dispatch(push('/'));
};

export const nonCriticalErrorHandler = (dispatch) => {
  dispatch(addNotification('Some error has occured.'));
};

export const formErrorHandler = (
  dispatch,
  error,
  formErrorAction,
  formErrorNotification = undefined) => {
  switch (error.response.status) {
    case 403:
      dispatch(addNotification('You need to sign in again.'));
      dispatch(push('/sign_in'));
      return;
    case 422:
      dispatch({
        type: formErrorAction,
        errors: error.response.data.errors,
      });
      if (formErrorNotification) {
        dispatch(addNotification(formErrorNotification));
      }
      break;
    default:
      dispatch(addNotification('Some error has occured. Please try again later.'));
  }
};
