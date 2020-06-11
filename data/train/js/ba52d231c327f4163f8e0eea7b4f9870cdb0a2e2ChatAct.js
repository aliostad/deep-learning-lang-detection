export const joinPers = (opts) => {
	return (dispatch) => {
		dispatch({
			type: 'JOIN_PERS_SUCCESS',
			messages: opts.messages,
			users: opts.users,
			roomId: opts.roomId,
		});
	}
};

export const err = (opts) => {
	return (dispatch) => {
		dispatch({
			type: 'CHAT_ERROR',
			error: opts.error,
		});
	}
};

export const message = (opts) => {
	return (dispatch) => {
		dispatch({
			...opts,
			type: 'MSG_SUCCESS',
		});
	}
};

export const joinGrp = (opts) => {
	return (dispatch) => {
		dispatch({
			type: 'JOIN_GRP_SUCCESS',
			messages: opts.messages,
			users: opts.users,
			// roomId: opts.roomId,
		});
	}
};