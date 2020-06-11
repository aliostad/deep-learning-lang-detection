import { app } from 'services';

// ----
// Edit current_user username from user.selected.username
// ----
export const editUsername = function ({ dispatch, state }) {

	dispatch( 'EDIT_CONNECTED_USER_USERNAME', state.users.selected.username );
}

// ----
// Get connected user
// ----
export const getConnectedUser = function ({ dispatch, state }) {

	dispatch( 'SET_CONNECTED_USER', app.get( 'user' ) );
}

// ----
// Empty connected user & disconnect user
// ----
export const destroyConnectedUser = function ({ dispatch, state }) {

	// Logout user
	app.logout();
	// Dispatch
	dispatch( 'SET_CONNECTED_USER', {} );
}
