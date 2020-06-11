import {showAlert, showNotice} from "./flash";
import {navigateTo} from "./location";

export function createAction(type, handler, options = {}) {
  const {notifyWhenStarted, notice, to} = options;

  return (...parameters) => (dispatch) => {
    if (notifyWhenStarted) {
      dispatch({type});
    }
    
    handler.apply(null, parameters)
      .then((payload) => {
        payload = payload || {};

        dispatch({type, payload});

        if (notice) {
          dispatch(showNotice(notice));
        }

        if (to) {
          const interpolated = to.replace(":id", parameters[0]);
          dispatch(navigateTo(interpolated));
        }
      })
      .catch((error) => {
        dispatch({type, error});

        if (error) {
          dispatch(showAlert(error.message));
        }
      });
  };
}
