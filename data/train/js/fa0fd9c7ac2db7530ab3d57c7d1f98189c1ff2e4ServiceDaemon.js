/**
 * @package com.watchlr.system
 */
$.Class.extend("com.watchlr.system.ServiceDaemon", {}, {

	services: [],
	
	/**
	 * @param {String} name
	 * @param {com.watchlr.system.Service} service
	 */
	addService: function(name, service) {
        if(!name || !service) return;
		if(!(service instanceof $cws.Service)) throw new Error('Object "' + name + '" must be a legitimate system service.');
		this.services[name] = service;

        // Set shortcut in $ks
        var shortName = name.match(/^([A-Za-z0-9]+)Service/)[1];
        if (!shortName) throw new Error('[ServiceDaemon] invalid service name');
        $cws[shortName] = service;
	},
	
	/**
	 * @type com.watchlr.system.Service
	 * @param {String} name
	 */
	getService: function(name) {
        return this.services[name] || false;
	},
	
	/**
	 * @type Boolean
	 * @param {String} name
	 */
	removeService: function(name) {
		return delete this.services[name];
	}
	
});