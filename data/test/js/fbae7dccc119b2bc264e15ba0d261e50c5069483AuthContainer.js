'use strict';

import { connect } from 'react-redux';
import { push } from 'react-router-redux';
import * as actions from '../actions';
import Auth from '../components/Auth';
import * as api from '../data/api';

const mapStateToProps = (state) => {
	return {
		authFailed: state.auth.authFailed,
		authError: state.auth.error,
		isFetching: state.fetch.isFetching
	};
}

const mapDispatchToProps = (dispatch) => {
	return {
		signIn: (username, password) => {
			dispatch(actions.fetchStart());
			api.signIn(username, password)
				.then((data) => {
					dispatch(actions.authenticateSuccess(data.username, data.token));
					dispatch(push('/'));
					dispatch(actions.fetchEnd());
				}).catch((data) => {
					dispatch(actions.authenticateFail(data.username, data.error));
					dispatch(actions.fetchEnd());
				});
		},
		signUp: (username, password) => {
			dispatch(actions.fetchStart());
			api.signUp(username, password)
				.then((data) => {
					dispatch(actions.authenticateSuccess(data.username, data.token));
					dispatch(push('/'));
					dispatch(actions.fetchEnd());
				}).catch((data) => {
					dispatch(actions.authenticateFail(data.username, data.error));
					dispatch(actions.fetchEnd());
				});
		}
	};
}

export default connect(mapStateToProps, mapDispatchToProps)(Auth);