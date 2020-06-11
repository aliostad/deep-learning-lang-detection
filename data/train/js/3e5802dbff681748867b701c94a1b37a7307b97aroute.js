define([
	'region/show/controller'
], function (c) {

	var data = DataInsightManager.module("ShowRegion"
        , function(ShowRegion, DataInsightManager, Backbone, Marionette, $, _) {

	  //////////////////////////////////////////////////////////定义接口
	  var API = {
		showShowView: function(){
	    	new ShowRegion.Controller();
	    }
	  };

	  //////////////////////////////////////////////////////////监听页面start
	  DataInsightManager.on("start", function(){
        // 由switch统一调度，自己不主动
	    //API.showShowView();
	  });
	});

	return data;
});
