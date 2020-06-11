export const SET_FLASH_MESSAGE 	= "SET_FLASH_MESSAGE";
export const RESET_FLASH				= "RESET_FLASH";

export function setSuccessFlashMessage( message ) {
	return (dispatch) => {
		setFlashMessage(dispatch, {
			value: message,
			type:  'success'
		});
	}
}

export function setErrorFlashMessage( message ) {
	return (dispatch) => {
		setFlashMessage(dispatch, {
			value: message,
			type:  'danger'
		});
	}
}

export function resetFlash() {
	return (dispatch) => {
		dispatch({
			type: RESET_FLASH
		});
	}
}

function setFlashMessage( dispatch, message ) {
	dispatch({
		type: SET_FLASH_MESSAGE,
		message: message
	});
}