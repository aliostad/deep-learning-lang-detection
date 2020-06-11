import { AUTH } from './action-types';

function signup (query) {
  console.log('getContinents');
  return (dispatch, getState) => {
    continentApi.getContinents(query)
      .then(res => {
      console.log('gotContinents');
        dispatch(getContinentsSuccess(res));
      }, err => {
      console.log('gotContinents2');
        dispatch(getContinentsFail(err));
      });
  };
}

function login(res) {
  return dispatch => {
    dispatch({
      type: PLACE_ACTIONS.GET_CONTINENTS_SUCCESS,
      payload: res
    });
  }
}
function logout(err) {
  return dispatch => {
    dispatch({
      type: PLACE_ACTIONS.GET_CONTINENTS_FAIL,
      payload: err
    });
  }
}

export default {
  signup,
  login,
  logout
}
