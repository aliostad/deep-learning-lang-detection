/**
 * App Actions
 */
import { browserHistory } from 'react-router';
import * as options from '../constants/Options';
import * as types from '../constants/ActionTypes';
import * as strings from '../constants/Strings';
import * as auth from '../shared/utils/auth';
import { setAuthState } from '../actions/authActions';

export const openConfirmExitEditor = cb => (
  dispatch =>
    Promise.resolve()
    .then(() => dispatch({ type: types.OPEN_CONFIRM_EXIT_EDITOR, cb }))
);

export const closeConfirmExitEditor = () => (
  dispatch =>
    dispatch({ type: types.CLOSE_CONFIRM_EXIT_EDITOR })
);

export const confirmExitEditor = () => (
  (dispatch, getState) =>
    Promise.resolve()
    .then(() => dispatch(closeConfirmExitEditor()))
    .then(() => {
      // REFACTOR
      const state = getState() && getState().app;
      dispatch(state.confirmCallback(state.currentSection));
    })
);

export const showLoader = () => (
  dispatch =>
   dispatch({ type: types.SHOW_LOADER })
);

export const hideLoader = () => (
  dispatch =>
    dispatch({ type: types.HIDE_LOADER })
);

export const loadDemos = id => (
  dispatch => (
    Promise.resolve()
    .then(() => dispatch(showLoader()))
    .then(() => dispatch({ type: types.LOAD_DEMOS, id }))
    .then(() => browserHistory.push(`/${id}`))
    .then(() => setTimeout(() => dispatch(hideLoader()), (Math.random() * 1000) + 100))
  )
);

export const newDemo = () => (
  (dispatch) => {
    browserHistory.push(`/${options.PATH_NEW_DEMO}`);
    dispatch({ type: types.NEW_DEMO });
  }
);

export const editDemo = name => (
  dispatch => (
    Promise.resolve()
    .then(() => dispatch(showLoader()))
    .then(() => dispatch({ type: types.EDIT_DEMO, name }))
    .then(() => browserHistory.push(`/${options.PATH_EDIT_DEMO}/${name}`))
    .then(() => setTimeout(() => dispatch(hideLoader()), (Math.random() * 1000) + 100))
  )
);

export const setTopBarTitle = (title, titleIndex = null) => {
  document.title = `${title} ${strings.FOOTPRINT_DEMO}`;
  return ({
    type: types.SET_TOPBAR_TITLE,
    title,
    titleIndex,
  });
};

export const signOut = () => (
  dispatch => (
    Promise.resolve()
    .then(() => new Promise(resolve => auth.signOut(resolve)))
    .then(() => dispatch(setAuthState(false)))
    .then(() => browserHistory.push(`/${options.PATH_SIGN_IN}`))
  )
);

export const changeTopBarMenu = id => (
  (dispatch, getState) => {
    const state = getState();
    const isConfirm = state.app.isNewDemo || state.app.isEditDemo;
    return Promise.resolve()
      .then(() => {
        if (id === options.PATH_SIGN_OUT) {
          return dispatch(isConfirm ? openConfirmExitEditor(signOut) : signOut());
        }
        return dispatch(isConfirm ? openConfirmExitEditor(() => loadDemos(id)) : loadDemos(id));
      });
  }
);
