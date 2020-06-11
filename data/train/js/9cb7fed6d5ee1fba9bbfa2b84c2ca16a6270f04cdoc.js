// @flow
import { history } from '../store/configureStore';
export const SET_FILE = 'SET_FILE';
export const SET_FUNCTIONS = 'SET_FUNCTIONS';
export const SET_LINES = 'SET_LINES';

export function setFile(file) {
  return (dispatch) => {
    dispatch({
      type: SET_FILE,
      payload: {
        file,
      }
    });
  }
}

export function setFunctions(functions) {
  return (dispatch) => {
    dispatch({
      type: SET_FUNCTIONS,
      payload: {
        functions,
      }
    });
  }
}

export function setLines(lines) {
  return (dispatch) => {
    dispatch({
      type: SET_LINES,
      payload: {
        lines,
      }
    });
  }
}
