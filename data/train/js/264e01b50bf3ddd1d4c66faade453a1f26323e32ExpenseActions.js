import axios from 'axios';
import * as types from 'constants/ActionTypes';

export function fetchExpenses() {
  return dispatch => {
    axios.get('/api/expenses')
      .then((response) => {
        dispatch({
          type: types.FETCH_EXPENSES,
          expenses: response.data
        });
      })
      .catch(() => {
        dispatch({
          type: types.FETCH_EXPENSES,
          expenses: []
        });
      });
  };
}

export function addExpense(expense) {
  return dispatch => {
    axios.post('/api/expenses', expense)
      .then((response) => {
        dispatch({
          type: types.ADD_EXPENSE,
          expense: response.data
        });
      });
  };
}

export function deleteExpense({_id}) {
  return dispatch => {
    axios.delete(`/api/expenses/${_id}`)
      .then(() => {
        dispatch({
          type: types.DELETE_EXPENSE,
          _id
        });
      });
  };
}
