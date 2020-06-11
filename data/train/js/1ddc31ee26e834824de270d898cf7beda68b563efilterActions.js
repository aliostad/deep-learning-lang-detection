import * as types from './types';

export function toggleFoundation (api) {
  return function(dispatch) {
    dispatch({type: types.TOGGLE_FOUNDATION, payload: api});
  }
}

export function toggleBuildpack (buildpack) {
  return function(dispatch) {
    dispatch({type: types.TOGGLE_BUILDPACK, payload: buildpack});
  }
}

export function toggleAppState (state) {
  return function(dispatch) {
    dispatch({type: types.TOGGLE_APP_STATE, payload: state});
  }
}

export function updateSort (sort) {
  return function(dispatch) {
    dispatch({type: types.SORT_UPDATED, payload: sort});
  }
}
