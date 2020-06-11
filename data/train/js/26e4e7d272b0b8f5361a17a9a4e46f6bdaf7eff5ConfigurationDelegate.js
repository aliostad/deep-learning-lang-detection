
/* ============================================================
 * CONFIG MODULE DELEGATE
 * ==========================================================*/

BP.ConfigurationDelegate = (function ()
{
	var _serviceID = "config";
	
	return {
		
		viewConfigModule : function ( responder )
		{
			var _service = Cairngorm.ServiceLocator.getHttpService(_serviceID);
			_service.call( null, responder );
		},
	
		viewMicTester : function ( responder )
		{
			var _service = Cairngorm.ServiceLocator.getHttpService(_serviceID);
			_service.call( {action : "mic"}, responder );
		},
		
		viewWebcamTester : function ( responder )
		{
			var _service = Cairngorm.ServiceLocator.getHttpService(_serviceID);
			_service.call( {action : "webcam"}, responder );
		}
	
	};

})();