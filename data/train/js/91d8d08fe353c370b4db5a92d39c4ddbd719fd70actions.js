export const incrementCounter = function ({ dispatch, state }, callback) {
	dispatch('SHOW_WAIT_MESSAGE')	
	setTimeout(function(){
		dispatch('HIDE_WAIT_MESSAGE')
		dispatch('INCREMENT')
	}, 2000)
}
export const decrementCounter = function ({ dispatch, state }) {
	dispatch('DECREMENT')
}

export const incrementCounterWithValue = function ({dispatch, state}, value) {
	let intValue = parseInt(value);
	if (isNaN(intValue)) {
		throw "Impossível converter para número inteiro."
	} else {
		dispatch('INCREMENTVALUE', intValue)
	}
}