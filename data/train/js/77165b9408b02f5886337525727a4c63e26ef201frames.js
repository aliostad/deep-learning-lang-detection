import {
  ADD_IMAGE,
  UNDO_IMAGE,
  UPDATE_INNING
} from '../constants';

export const addImage = (image, team, inning, order) => {
  return dispatch => {
    dispatch({
      type: ADD_IMAGE,
      image,
      team,
      inning,
      order
    });
  };
};

export const undoImage = (team, inning, order) => {
  return dispatch => {
    dispatch({
      type: UNDO_IMAGE,
      team,
      inning,
      order
    });
  };
};

export const updateInning = (team, inning) => {
  return dispatch => {
    dispatch({
      type: UPDATE_INNING,
      team,
      inning
    });
  };
};
