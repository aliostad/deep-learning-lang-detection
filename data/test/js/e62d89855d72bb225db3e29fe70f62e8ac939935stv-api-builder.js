export default class APIBuilder  {
	constructor() {
		// Grab Object containing api urls for current env
		let apiObj = STV.url;
		this.apiList = {};
		// If object exists in window
		if (typeof apiObj === 'object') {
			// Assign named values for a cleaner API interface
			this.apiList['player'] = apiObj.playerAPIUrl;
			this.apiList['stv'] = apiObj.stvAPI;
		} else {
			let playerAPIUrl = 'http://player.api.stv.tv/v1/';
			let stvAPI = 'http://api.stv.tv/';
			this.apiList = {
				'player' : playerAPIUrl,
				'stv' : stvAPI
			};
		}
	}
	fetchAPI(api) {
		// TODO throw exception if no API
		return this.apiList[api];
	}
}
