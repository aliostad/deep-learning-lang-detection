import React, { PropTypes } from 'react'
import shouldPureComponentUpdate from 'react-pure-render/function'

import TodoList from './TodoList'
import CreateTodo from './CreateTodo'
import Footer from './Footer'

import * as actions from '../actions/TodoActions'

import './layout.scss'

export default class Layout extends React.Component {

	static propTypes = {
	}

	// shouldComponentUpdate = shouldPureComponentUpdate

	componentDidMount() {
		const { dispatch } = this.props
		dispatch(actions.fetchTodos())
	}

	render() {
		const { todos } = this.props.todoState
		const { dispatch } = this.props
		return (
			<main id='app-view' className='layout'>
				{<CreateTodo dispatch={dispatch} />}
				{<TodoList todos={todos} dispatch={dispatch} />}
				{<Footer todos={todos} dispatch={dispatch} />}
			</main>
		)
	}
}
