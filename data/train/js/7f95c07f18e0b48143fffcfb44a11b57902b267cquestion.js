import {request} from "../../../shared/lib/socket";
import {QUESTION} from "../reducers/constants";

export const getCurrentQuestion = name => (dispatch => {
  dispatch({type: QUESTION.GET_CURRENT_PENDING});
  request("quiz.getCurrentQuestion", {search: {name}})
    .then(data => {
      if (data !== undefined) dispatch({type: QUESTION.GET_CURRENT_SUCCEEDED, payload: data.question});
      else dispatch({type: QUESTION.GET_CURRENT_SUCCEEDED, payload: undefined});
    })
    .catch(err => dispatch({type: QUESTION.GET_CURRENT_FAILED, payload: err}));
});