/**
 * -------------------------------------------------------------------------------- Main init object
 */
window.currentNode						 =	new Object();
window.ExtAPI							 =	new Object();

ExtAPI.App								 = 	Class.extend
({

	init								 :	function() {
		
		ExtAPI.Feedback				 	 = 	new ExtAPI.App.feedback();
		ExtAPI.Getnode				 	 =	new ExtAPI.App.getnode();
		ExtAPI.Createnode				 =	new ExtAPI.App.createnode();
		
		var XHRhelper					 =	new ExtAPI.App.xhrhelper();
		
		ExtAPI.Createnode.buildModal();
	}

});

$(document).ready(function() { new ExtAPI.App(); });

