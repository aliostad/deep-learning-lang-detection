var dispatch = require('pico-flux').dispatch;
var request = require('superagent');

var GifStore = require('gifbin/gif.store.js');


module.exports = {
	login  : function(){
		dispatch('LOGIN');
	},
	logout : function(){
		dispatch('LOGOUT');
	},

	saveGif : function(gifData, callback){
		dispatch('SET_PENDING');
		request.post('/api/gifs')
			.set('Accept', 'application/json')
			.send(gifData)
			.end(function(err, res){
				if(err){
					dispatch('SET_ERRORS', err);
					return;
				}
				dispatch('SET_FINISHED');
				dispatch('UPDATE_GIF', res);
				callback && callback(res)
			})
	},
	updateGif : function(gifData, callback){
		dispatch('SET_PENDING');
		request.put('/api/gifs/' + gifData.id)
			.set('Accept', 'application/json')
			.send(gifData)
			.end(function(err, res){
				if(err){
					dispatch('SET_ERRORS', err);
					return;
				}
				dispatch('SET_FINISHED');
				dispatch('UPDATE_GIF', res);
				callback && callback(res)
			})
	},
	deleteGif : function(gifId, callback){
		dispatch('SET_PENDING');
		request.del('/api/gifs/' + gifId)
			.set('Accept', 'application/json')
			.end(function(err, res){
				if(err){
					dispatch('SET_ERRORS', err);
					return;
				}
				dispatch('SET_FINISHED');
				dispatch('REMOVE_GIF', gifId);
				callback && callback(res)
			})
	},

	favGif : function(gif){
		var newGif = { ...gif,
			favs : _.uniq(_.concat(gif.favs, GifStore.getUser()))
		}

		dispatch('UPDATE_GIF', newGif);
		request
			.put('/api/gifs/' + newGif.id)
			.send(newGif)
			.set('Accept', 'application/json')
			.end(function(err, res){
				//dispatch('UPDATE_GIF', res.body);
			})
	},
	unfavGif : function(gif){
		var newGif = { ...gif,
			favs : _.without(gif.favs, GifStore.getUser())
		}
		dispatch('UPDATE_GIF', newGif);
		request
			.put('/api/gifs/' + newGif.id)
			.send(newGif)
			.set('Accept', 'application/json')
			.end(function(err, res){
				//dispatch('UPDATE_GIF', res.body);
			})

	},
}
