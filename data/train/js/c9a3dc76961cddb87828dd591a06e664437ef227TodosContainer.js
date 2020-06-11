import { connect } from 'react-redux'

import { createTodoRequest, fetchTodos, deleteTodoRequest, completeTodoRequest, openTodoRequest } from '../actions/TodoActions'
import Todos from './Todos'

const mapStateToProps = (state) => {
	return {
		todos: state.todoReducer.todos
	}
}

const mapDispatchToProps = (dispatch) => {
	return {
		createTodo: (todo) => {
			dispatch(createTodoRequest(todo));
		},
		fetchTodos: () => {
			dispatch(fetchTodos());
		},
		deleteTodo: (id) => {
			dispatch(deleteTodoRequest(id));
		},
		completeTodo: (id) => {
			dispatch(completeTodoRequest(id));
		},
		openTodo: (id) => {
			dispatch(openTodoRequest(id))
		},
		createTag: () => {
			dispatch(createTagRequest(tag))
		}
	}
}

export default connect(
	mapStateToProps,
	mapDispatchToProps
)(Todos)