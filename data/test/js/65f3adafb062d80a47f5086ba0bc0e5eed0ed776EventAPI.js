(function(BTG){
	BTG.EventAPI = (function(){
		var	event = BTG.APIEvents;
		return {
			onConfig : function(data){
				event.ON_CONFIG.dispatch(data);
			},
			onMetadata : function(data){
				event.ON_METADATA.dispatch(data);
			},
			onPlay : function(data){
				event.ON_PLAY.dispatch(data);
			},
			onPlayhead : function(playhead){
				event.ON_PLAYHEAD.dispatch(playhead);
			},
			onPause : function(playhead){
				event.ON_PAUSE.dispatch(playhead);
			},
			onUnPause : function(playhead){
				event.ON_UNPAUSE.dispatch(playhead);
			},
			onSeekStart : function(playhead){
				event.ON_SEEKSTART.dispatch(playhead);
			},
			onSeekEnd : function(playhead){
				event.ON_SEEKEND.dispatch(playhead);
			},
			onBufferingStart : function(){
				event.ON_BUFFERINGSTART.dispatch();
			},
			onBufferingEnd : function(){
				event.ON_BUFFERINGEND.dispatch();
			},
			onPlayEnd : function(){
				event.ON_PLAYEND.dispatch();
			}
		};
	}());
})(BTG);
