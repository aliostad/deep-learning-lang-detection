import { loadCards } from '../actions/cards';

export const LOAD_LISTS = 'LOAD_LISTS';
export const PICK_LIST = 'PICK_LIST';
export const TOGGLE_LIST = 'TOGGLE_LIST';

export function loadLists(boardId) {
  if (!boardId) {
    return dispatch({ type: LOAD_LISTS, data: [] });
  }

  return (dispatch) => {
    Trello.get('boards/' + boardId + '/lists', (data) => {
      dispatch({ type: LOAD_LISTS, data });
    }, (error) => {
      console.log(error);
    });
  };
}

export function pickList(list) {
  return (dispatch) => {
    dispatch({ type: PICK_LIST, list });
    dispatch(loadCards(list));
  };
}

export function toggleList(list) {
  return (dispatch) => {
    dispatch({ type: TOGGLE_LIST, list });
    dispatch(loadCards(list));
  };
}
