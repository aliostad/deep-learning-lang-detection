
const state = {
	audio: {
		on: false
	},
	change: {
		stage: 0
	}
};

const mutators = {
	INIT ({state,dispatch},action) {
		state.page = 'ready';
	},
	TURN_AUDIO ({state,dispatch},action) {
		state.audio.on = !state.audio.on;
	},
	CHANGE ({state,dispatch},action) {
		state.change.stage = action.to;
	},
	CLICK_BTN ({state,dispatch},action) {
		if( state.meta.share ){
			dispatch({
				type: 'TO_APP'
			})
		}else{
			dispatch({
				type: 'SHARE'
			})
		}
	}
}

export default {state,mutators};