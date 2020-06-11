var APIUtils = (function () {
	
	var instance;
	
	function init() {

		function apiGet(apiUri) {
			return ajax(apiUri, "get", {});
		}
		
		function apiCreate(apiUri, data) {
			return ajax(apiUri, "post", data);
		}
		
		function apiUpdate(apiUri, data) {
			return ajax(apiUri, "put", data);
		}
		
		function apiDelete(apiUri) {
			return ajax(apiUri, "delete", {});
		}
		
		function ajax(apiUri, type, data) {
			event.preventDefault();
			return $.ajax({
		        type: type,
		        url: apiUri,
		        contentType: "application/json; charset=utf-8",
		        dataType: "json",
		        data: data
		    });
		}
	
	return {
		apiGet: apiGet,
		apiCreate: apiCreate,
		apiUpdate: apiUpdate,
		apiDelete: apiDelete
	};
};

return {
	getInstance: function () {
		if (!instance) {
			instance = init();
		}
		return instance;
	}
};

})();