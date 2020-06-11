import axios from 'axios';

export const deleteTodo = (id) => (dispatch) =>{
  dispatch({type:'ASYNC_DELETE_TODO'});
  axios.delete(`/todos/${id}`)
    .then(() => {
      dispatch({type:'ASYNC_DELETE_TODO_SUCCESS', id});
    }, () => {
      dispatch({type: 'ASYNC_DELETE_TODO_FAILURE'});
    });
};

export const addTodo = () => (dispatch, getState) => {
  dispatch({type: 'ASYNC_ADD_TODO'});
  console.log('ADD_TODO', getState());
  axios.post('/todos', {name: getState().asyncTodos.newTodo.name})
    .then((response) => {
      dispatch({type:'ASYNC_ADD_TODO_SUCCESS', data: response.data});
    }, () => {
      dispatch({type: 'ASYNC_ADD_TODO_FAILURE'});
    });
};
export const completeTodo = (id) => (dispatch) => {
  dispatch({type: 'ASYNC_COMPLETE_TODO'});
  axios.put(`/todos/${id}`, {})
    .then(() => {
      dispatch({type: 'ASYNC_COMPLETE_TODO_SUCCESS', id});
    }, () => {
      dispatch({type: 'ASYNC_COMPLETE_TODO_FAILURE'});
    })
};

export const fetchTodos = () => (dispatch) => {
  dispatch({type: 'ASYNC_FETCH_TODOS'});
  axios.get('/todos')
    .then((response) => {
      dispatch({type: 'ASYNC_FETCH_TODOS_SUCCESS', list: response.data});
    }, () => {
      dispatch({type: 'ASYNC_FETCH_TODOS_FAILURE'});
    });
}
export const updateName = (name) => ({type: 'ASYNC_UPDATE_NAME', name});