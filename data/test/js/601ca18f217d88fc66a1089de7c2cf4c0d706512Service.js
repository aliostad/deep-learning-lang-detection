//#include https://ajax.googleapis.com/ajax/libs/prototype/1.7.2.0/prototype.js
//#include https://code.jquery.com/jquery-1.10.2.js

/**
 * Singleton provider
 *  ex:
 * 		var graphics = Service.get("gfx");
 */
var Service = Class.create({
  initialize: function() {
  },
  g_services : []
});

//class methods for getting types
Service.get = function( serviceName  )
{
  return Service.prototype.g_services[ serviceName ];
}

Service.add = function( serviceName, service )
{
	Service.prototype.g_services[ serviceName ] = service;
}
