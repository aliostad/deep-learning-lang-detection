import { combineReducers } from 'redux';
import {
  SET_STATE, ADD_MESSAGE, UPDATE_MESSAGE, DELETE_MESSAGE
} from './actions';

function messages(state = [], action) {
  switch (action.type) {
  case SET_STATE:
    return action.state;

  case ADD_MESSAGE:
    return [action.message, ...state];

  case UPDATE_MESSAGE:
    return state.map(message => {
        if (message.uuid === action.message.uuid) {
          return Object.assign({}, message, {
            id: action.message.id,
            url: action.message.url
          });
        }
        return message;
    });

  case DELETE_MESSAGE:
    return state.filter(message => message.uuid !== action.message.uuid);

  default:
    return state;
  }
}

export default combineReducers({messages});
