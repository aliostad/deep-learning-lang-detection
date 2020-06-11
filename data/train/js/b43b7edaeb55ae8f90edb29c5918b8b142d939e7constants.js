(function() {
	
	myapp.constants = {} 
	
	myapp.constants.api = {}
	// myapp.constants.api.root = 'http://127.0.0.1:8000/api/';
	myapp.constants.api.root = 'http://alpha.infoscoutinc.com/api/';
	
	myapp.constants.api.user_params = 'device_id='+Ti.Platform.id+'&mobile_os=' + Ti.Platform.osname
	
	myapp.constants.api.userinfo =  myapp.constants.api.root+'user?' + myapp.constants.api.user_params;
	myapp.constants.api.postreceipt =  myapp.constants.api.root+'upload?' + myapp.constants.api.user_params;
	myapp.constants.api.receipts =  myapp.constants.api.root+'receipt?' + myapp.constants.api.user_params;
	myapp.constants.api.feedback =  myapp.constants.api.root+'feedback?' + myapp.constants.api.user_params;

})();
