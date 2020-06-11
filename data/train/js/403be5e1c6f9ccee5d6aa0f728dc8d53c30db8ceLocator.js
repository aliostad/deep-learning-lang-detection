dojo.provide("foo.service.Locator");
dojo.require("mojo.service.Locator");
dojo.require("mojo.service.Service");

/*
    Class: foo.service.Locator
    Author: Paul Ortchanian
    
    Singleton instance of the Service locator.  This file contains all service call information
	and is used to make XHR calls using the MOJO API
     

*/

// Necessary for Singleton pattern implementation
var __sphServiceLocator = null;

dojo.declare("foo.service.Locator", mojo.service.Locator,
{
	addServices: function() {
		
		// Local testing
		//this.addService(new mojo.service.Service("GetData","data/testData.html", {json:false, cache:true}));	

	}
});

// Singleton Implementation
foo.service.Locator.getInstance = function() {
	if (__fooServiceLocator == null) {
		__fooServiceLocator = new foo.service.Locator();
	}
	return __fooServiceLocator;
}
