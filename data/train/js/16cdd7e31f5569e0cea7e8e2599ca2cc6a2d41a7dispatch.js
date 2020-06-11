/**
 * @author stewartmatheson
 */

var dispatch = 
{
	run : function()
	{
		//get the get data
		var getData = Jaxer.request.current.queryParts;
		//load the controller file
		
		var queryString = getData.q || 'welcome/index';
		var stringParts = queryString.split("/");
		
		controllerName = stringParts[0] || 'welcome';
		actionName = stringParts[1] || 'index';
		Controller.load(controllerName, actionName);
	},
	
	loadController : function(controllerName, actionName)
	{
		controllerName =  Utils.capitalize(controllerName);
		controllerAddress = 'file://' + applicationRoot + '/controllers/' + controllerName  + 'Controller.js';
		Jaxer.load(controllerAddress);
		
		if(window[controllerName + 'Controller']["beforeFilter"] != undefined)
			window[controllerName + 'Controller']["beforeFilter"]();
		
		window[controllerName + 'Controller'][actionName]();
	}
}