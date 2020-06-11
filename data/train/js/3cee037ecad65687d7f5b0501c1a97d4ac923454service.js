var serverController = require( './ServerController.js' );
var app 			 = serverController.createServer( 5000 );
var shows 			 = [];


app.post( '/', function( req, res ){

	try
	{
		var reqData  = req.body.payload;
		var showList = [];

		for( var i = 0; i < reqData.length; i++ )
		{
			var objShow = reqData[i];

			if( objShow.drm && objShow.episodeCount > 0 )
			{
				var reqShow   = {};
				reqShow.title = objShow.title;
				reqShow.slug  = objShow.slug;
				reqShow.image = objShow.image.showImage;

				showList.push( reqShow );
			}
		}

		res.status(200);
		res.json( { "response" : showList } );
		res.end
	}
	catch( ex )
	{
		res.set('Content-Type', 'application/json');
		res.status(400);
		res.json( { "error": "Could not decode request: JSON parsing failed" } ).end();
	}

});
