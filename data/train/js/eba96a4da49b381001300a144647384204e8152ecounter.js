
export default {n:0};

export function sum() {

	return async (dispatch, getState) => {
		const {n}= getState();
		var r=await dispatch('asyncGet', {n:33});
		var rr=await dispatch('normalGet');
		var rrr=await dispatch('get');
		var rrrr=await dispatch('getByAsyncGet');
		return {
			n: r.n + rr.n + rrr.n + rrrr.n + n
		};
	}
}

export function asyncGet(options) {
	return async (dispatch, getState) => {
		return new Promise(function (resolve, reject) {
			setTimeout(() => { resolve({n:options.n}); }, 1000);
		});
	}
}

export function normalGet() {
	return (dispatch, getState) => {
		return {n:888}
	}
}

export function get() { 
	return {n:555}
}

export function getByAsyncGet() {
	return async (dispatch, getState) => {
		return await dispatch('asyncGet',{n:22});
	}
}













