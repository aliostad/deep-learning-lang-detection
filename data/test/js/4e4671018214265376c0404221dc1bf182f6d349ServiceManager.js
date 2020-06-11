/**
 * @author jinlan
 * 2011-8-17
 */
define("blackJS/ServiceManager", ['dojo','blackJS.BlackJS'], function(dojo,BlackJS) {
	
	var ServiceManager=dojo.declare(null, new (function(){
		
		var NULL_ARUGMENT_EXCEPTION=BlackJS.NULL_ARUGMENT_EXCEPTION;
		
		this._serviceProviders;
		this._serviceObjects;
		this._defaultServiceProvider;
		
		this.constructor=function(){
			this._serviceProviders={};
			this._serviceObjects={};
		};
	
		this.registerServiceProvider=function(serviceName,serviceProvider){
			if(serviceProvider==null){
				throw NULL_ARUGMENT_EXCEPTION;
			}
			if(serviceName==null){
				this._defaultServiceProvider=serviceProvider;
			}else{
				this._serviceProviders[serviceName]=serviceProvider;
			}
		};
		this.registerServiceObject=function(serviceName,serviceObject){
			if(serviceName==null || serviceObject==null){
				throw NULL_ARUGMENT_EXCEPTION;
			}
			this._serviceObjects[serviceName]=serviceObject;
		};
		this.unregisterService=function(serviceRegistrationHandle){
			if(serviceRegistrationHandle==null){
				throw NULL_ARUGMENT_EXCEPTION;
			}
			var serviceName=serviceRegistrationHandle;
			if(this._serviceObjects[serviceName]!=null){
				delete this._serviceObjects[serviceName];
			}
			if(this._serviceProviders[serviceName]!=null){
				delete this._serviceProviders[serviceName];
			}
		};
		this.getService=function(serviceName){
			if(serviceName==null){
				throw NULL_ARUGMENT_EXCEPTION;
			}
			var serviceObjects=this._serviceObjects;
			var serviceObject=serviceObjects[serviceName];
			if(serviceObject!=null){
				return serviceObject;
			}
			var serviceProviders=this._serviceProviders;
			var serviceProvider=serviceProviders[serviceName];
			if(serviceProvider!=null){
				return serviceProvider.getService(serviceName);
			}
			var defaultServiceProvider=this._defaultServiceProvider;
			if(defaultServiceProvider!=null){
				return defaultServiceProvider.getService(serviceName);
			}
			return
		};
		this.getServiceList=function(){
			var serviceKeys={};
			for(var n in this._serviceObjects){
				serviceKeys[n]=true;
			}
			for(var n in this._serviceProviders){
				serviceKeys[n]=true;
			}
			var services=[];
			for(var n in serviceKeys){
				services.push(n);
			}
			return services;
		};

	})());
	
	return ServiceManager;
	
});