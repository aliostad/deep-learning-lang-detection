'use strict';

module.exports = function(json){

	try {
		
		var valid_json = JSON.parse(json);
		
		return {
			response:	build_shows(valid_json)
		}
	} catch(e) {
		return {
    		"error": "Could not decode request: JSON parsing failed"
		}
	}

	
	/*	filters the shows to match the requirements then reduces the show object to only the requested fields */
	function build_shows(shows_json){
			
			return shows_json.payload.filter(function(show){
					
					if(show.drm && show.episodeCount>0 && check_show_obj(show)) return true;
				}).map(function(show){
					
					return show_obj(show);
				});
	}

	/* checks the show object has the required items */
	function check_show_obj(show){
		if(!show.image || !show.slug || ! show.title || !show.image.showImage) return false;
		return true;
	}

	/* build the show object with the required items */
	function show_obj(show){
		return {
					image: show.image.showImage,
					slug: show.slug,
					title: show.title
				};

	}
}