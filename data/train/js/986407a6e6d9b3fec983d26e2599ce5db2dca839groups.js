import { createAction } from 'redux-actions';
import Groups from 'models/Groups';
import {show} from './menu';

export const start = createAction('GROUPS_FETCHING');
export const error = createAction('GROUPS_ERROR', (err) => err);
export const load = createAction('GROUPS', (items) => items);

export function fetch(userID) {
  return (dispatch) => {
    dispatch(start());
    return Groups.getById(userID, 0, 1000).then((r) => {
      dispatch(load(r));
      dispatch(show());
    }, () => dispatch(error()));
  };
}
