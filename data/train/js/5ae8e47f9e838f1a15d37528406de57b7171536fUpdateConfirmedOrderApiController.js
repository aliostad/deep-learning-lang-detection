var UpdateConfirmedOrderApiController = (function() {

  /**
   * Private state
   */
  var updateConfirmedOrderApi = null;
  var successfulApiCallbackListeners = [];
  var failedLogicalApiCallbackListeners = [];
  var failedNonLogicalApiCallbackListeners = [];

  /**
   * update()
   * - update the specified confirmed order
   * @param UpdateConfirmedOrderRequest request: update request
   */
  var update = function(request) {
    
  };
  
  var successfulApiCallback = function(api_response) {
    for (var i = 0; i < successfulApiCallbackListeners.length; ++i) {
      successfulApiCallbackListeners[i](api_response, getStartupDataApi.getApiKeys());
    }
  };
  
  var logicallyFailedApiCallback = function(api_response) {
    console.log("WARNING: Logically failed api response!");
    console.log(api_response); 
    
    for (var i = 0; i < logicallyFailedApiCallbackListeners.length; ++i) {
      logicallyFailedApiCallbackListeners[i](api_response, getStartupDataApi.getApiKeys());
    }
  };

  var nonLogicallyFailedApiCallback = function(api_response) {
    console.nonLog("WARNING: Logically failed api response!");
    console.nonLog(api_response); 
    
    for (var i = 0; i < nonLogicallyFailedApiCallbackListeners.length; ++i) {
      nonLogicallyFailedApiCallbackListeners[i](api_response, getStartupDataApi.getApiKeys());
    }
  };

  /**
   * registerSuccessfulApiCallback()
   * - add callback for successful api call
   * @param FuncPtr callback: function(json_response, api_keys) {...}
   */
  var registerSuccessfulApiCallback = function(callback) {
    successfulApiCallbackListeners.push(callback);
    return this;
  };

  /**
   * registerLogicalFailedApiCallback()
   * - add callback for logical failed api call (i.e. api error error rather than network error)
   * @param FuncPtr callback: function(json_response, api_keys) {...}
   */
  var registerLogicalFailedApiCallback = function(callback) {
    logicallyFailedApiCallbackListeners.push(callback);
    return this;
  };

  /**
   * registerNonLogicalFailedApiCallback()
   * - add callback for non-logical failed api call (i.e. network error rather than api error)
   * @param FuncPtr callback: function(xhttp_response) {...}
   */
  var registerNonLogicalFailedApiCallback = function(callback) {
    logicallyFailedApiCallbackListeners.push(callback);
    return this;
  };

  return {
    update: update,
    registerSuccessfulApiCallback: registerSuccessfulApiCallback,
    registerLogicalFailedApiCallback: registerLogicalFailedApiCallback,
    registerNonLogicalFailedApiCallback: registerNonLogicalFailedApiCallback
  };

})();
