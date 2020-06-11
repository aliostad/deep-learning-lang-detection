dojo.provide("ibm_soap.widget.RpcService");

dojo.require("dijit._Widget");
dojo.require("dijit._Templated");

dojo.declare("ibm_soap.widget.RpcService",dijit._Widget,
{
	// summary: A base widget for an RPC service
	// description:
	//		The RPC service created by sub-classes is set to 'service' property.
	//		Then the service is initialized with a service description specified
	//		with 'url'. If 'serviceUrl' is specified, it overrides the service endpoint
	//		defined in the service description.
	
	
	//	url: String
	//		A URL to a service description
	//	serviceUrl: String
	//		A URL to a service endpoint
	//	service: SoapService
	// 		SOAP Service used to make various method calls
	//			

	url: "",
	serviceUrl: "",
	service: "",

	postCreate: function(){
		// summary: Create an RPC service and generate methods
		// description:
		//		The RPC service is created by sub-classes and set to 'service'
		//		property.
	    
	    this.service = this._createService();
	},

	setUrl: function(url) {
		// summary: Set a URL to the service description
		// description: Set a URL to the service description
		// url: String
		//	A service description URL
		this.url = url;
	},

	setServiceUrl: function(serviceUrl){
		// summary: Set a service URL to the service
		// description: Set a service URL to the service
		// serviceUrl: String
		//	A service endpoint URL

		this.serviceUrl = serviceUrl;
		if(this.service){
			this.service.serviceUrl = this.serviceUrl;
		}
	},

	callMethod: function(method, parameters) {
		// summary:	Call a method with parameters
		// method: String
		//	A method name
		// parameters: Array
		//	An array of parameters

		var deferred = new dojo.Deferred();
		this.service.bind(method, parameters, deferred);
		return deferred;
	},

	_createService: function() {
		dojo.unimplemented("ibm_soap.widget.RpcService._createService");
	}
});
