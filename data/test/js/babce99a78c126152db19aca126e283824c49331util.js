import _ from 'lodash';

// loading: (Dispatch -> Promise[?]) => Dispatch => Promise[?]
export const loading = (action) => (dispatch) => {
  dispatch({ type: 'app:loading:show' });
  return action(dispatch).then(res => {
    dispatch({ type: 'app:loading:hide' });
    return res;
  });
};

export const all = (actions) => (dispatch) => {
  return Promise.all(actions.map(action => action(dispatch)))
    .then(results => _.every(results));
};

/**
 * All actions have type: ? -> (dispatch: Action -> Action) -> Promise[Boolean]
 */

export const showError = (code = 'unexpected', message = '情報を取得できませんでした。', millis = 0) => (dispatch) => {
  return new Promise(resolve => {
    dispatch({ type: 'app:error:show', error: { code, message } });
    resolve(false);
    if (millis) {
      setTimeout(() => {
        dispatch({ type: 'app:error:hide' });
      }, millis);
    }
  });
};
