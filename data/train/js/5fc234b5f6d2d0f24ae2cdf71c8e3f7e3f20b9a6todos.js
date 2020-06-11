import * as types from '../constans/actionTypes';

import { updateItem, newItem, deleteItem } from './todo';

export const addTodo = (id, text) => {
  return dispatch => {
    dispatch(pendingRequest())
    dispatch(newItem(id, text, json => dispatch({...json, type: types.ADD_TODO })))
  }
}

export const deleteTodo = (id) => {
  return dispatch => {
    dispatch(pendingRequest())
    dispatch(deleteItem(id, json => dispatch({...json, type: types.DELETE_TODO, id: id })))
  }
}

export const markAll = () => {
  return (dispatch, getState) => {
    const items = getState().todos.items;
    let count = 0;

    dispatch(pendingRequest())
    items.map(item => {
      dispatch(updateItem(item.id, item.text, true, json => dispatch({...json, type: types.TOGGLE_TODO})))
        .then(() => {
          if (count === items.length - 1) {
            dispatch(requestDone())
          } else {
            count++;
          }
        })
        .catch(error => console.log(error))
    });
  }
}

export const deleteMarked = () => {
  return (dispatch, getState) => {
    const markedItems = getState().todos.items.filter(o => o.completed);
    let count = 0;
    
    dispatch(pendingRequest())
    markedItems.map(item => {
      dispatch(deleteItem(item.id, json => dispatch({...json, type: types.TOGGLE_TODO})))
        .then(() => {
          if (count === markedItems.length - 1) {
            dispatch(requestDone())
          } else {
            count++;
          }
        })
        .catch(error => console.log(error))      
    });
  }
}

export const setFilter = (filter) => {
  return {
    type: types.SET_VISIBILITY_FILTER,
    filter: filter
  }
}

export const pendingRequest = () => {
  return {
    type: types.PENDING_REQUEST
  }
}

export const requestDone = () => {
  return {
    type: types.REQUEST_DONE
  }
}

export const receiveTodos = (json) => {
  return {
    type: types.RECEIVE_TODOS,
    todos: json
  }
}

export const fetchTodos = () => {
  return dispatch => {
    dispatch(pendingRequest())
    return fetch('http://localhost:3000/todos')
      .then(response => response.json())
      .then(json => dispatch(receiveTodos(json)))
      .catch(error => console.log(error))
  }
}