
var dispatcher = new Dispatcher();


function Dispatcher()
{

	this.dispatchMap = {};

	this.addEventListener = function( eventName, that, callback )
	{
		var array = this.dispatchMap[eventName];
		if( !array )
		{
			 array = [];
			 this.dispatchMap[eventName] = array;
		}
		array.push( 
		{
			that: that,
			callback: callback
		} );
	}
	
	this.dispatch = function( eventName, data )
	{
		var array = this.dispatchMap[eventName];
		if( array ) 
		{
			$.each( array, function( i, o )
			{
				o.callback( o.that, data );
			});
		}	
	}
	
	
}