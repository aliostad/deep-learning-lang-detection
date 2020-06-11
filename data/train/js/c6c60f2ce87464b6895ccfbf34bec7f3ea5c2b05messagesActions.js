import * as types from '../constants/MessagesTypes';
import * as webApiUtilities from '../utilities/webApiUtilities';
function request_to_add_message (message) {
	return {
		type: types.REQUEST_TO_ADD_MESSAGE,
		message
	}
}

function receive_to_add_message (message) {
	return {
		type: types.RECEIVE_TO_ADD_MESSAGE,
		message
	}
}

export function add_message (message) {
	return function (dispatch){
		dispatch(request_to_add_message(message));
		return webApiUtilities.add_message_api(message)
			.then((res) => {
				dispatch(receive_to_add_message(res.data));
			})
			.catch((err) => {

			});
	}
}